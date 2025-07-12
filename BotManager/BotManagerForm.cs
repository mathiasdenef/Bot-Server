using BotManager.Game_Launcher;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace BotManager
{

    public partial class BotManagerForm : Form
    {
        public static BotManagerForm form = null;
        public BindingList<Client> clientList = new BindingList<Client>();
        public List<Client> sourceClientList = new List<Client>();
        private BindingSource bindingSource1 = new BindingSource();
        public BindingList<ClientViewModel> clientViewModelBindingList;

        public BindingList<BotClient> clients = [];
        private BindingList<BotClientView> _runningClientsViews = [];
        private TcpBotServer _server;
        public PingManager pingManager;

        public BotManagerForm()
        {
            InitializeComponent();
            form = this;
            Settings.Initalize();
        }

        private async void BotManagerForm_Load(object sender, EventArgs e)
        {
            ConfigureBotGrid();
            LoadBotClients();
            _server = new TcpBotServer(this);
        }
        protected override async void OnShown(EventArgs e)
        {
            base.OnShown(e);

            try
            {
                pingManager = new PingManager(_runningClientsViews);
                await _server.StartAsync(5055);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Server start faalde: " + ex.Message);
            }
        }

        private void selectAllBotClientsButton_Click(object sender, EventArgs e)
        {
            //for (int i = 0; i < botClientCheckList.Items.Count; i++)
            //{
            //    botClientCheckList.SetItemChecked(i, true);
            //}
            foreach (var view in _runningClientsViews)
            {
                if (view.Source != null && view.Source.TcpConnection != null)
                {
                    try
                    {
                        view.Source.SendMessage("PING");
                        AppendLog($"[DEBUG] PING sent to {view.CharacterName}");
                    }
                    catch (Exception ex)
                    {
                        AppendLog($"[DEBUG] PING FAIL {view.CharacterName}: {ex.Message}");
                    }
                }
                else
                {
                    AppendLog($"[DEBUG] {view.CharacterName} not connected, ping skipped.");
                }
            }
        }

        private void BotClientCheckList_ItemCheck(object sender, ItemCheckEventArgs e)
        {
            // ItemCheck event wordt vóór de waarde effectief wijzigt, dus we tellen handmatig
            int checkedCount = botClientCheckList.CheckedItems.Count + (e.NewValue == CheckState.Checked ? 1 : -1);
            startSelectBotClientsButton.Enabled = checkedCount > 0;
        }

        private void ConfigureBotGrid()
        {
            runningBotClientsGrid.DataSource = _runningClientsViews;
            runningBotClientsGrid.AutoGenerateColumns = true;
            runningBotClientsGrid.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            runningBotClientsGrid.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            runningBotClientsGrid.AllowUserToAddRows = false;
            runningBotClientsGrid.AlternatingRowsDefaultCellStyle.BackColor = Color.LightGray;
            runningBotClientsGrid.CellFormatting += botClientGrid_CellFormatting;
            foreach (DataGridViewColumn column in runningBotClientsGrid.Columns)
            {
                column.ReadOnly = true;
            }

            runningBotClientsGrid.Columns["IsSelected"].ReadOnly = false;
        }

        private void botClientGrid_CellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
        {
            string columnName = runningBotClientsGrid.Columns[e.ColumnIndex].Name;

            if (columnName == "State" && e.Value is BotClientState state)
            {
                e.CellStyle.Font = new Font(e.CellStyle.Font, FontStyle.Bold);

                switch (state)
                {
                    case BotClientState.Error:
                        e.CellStyle.BackColor = Color.IndianRed;
                        break;

                    case BotClientState.RunQuest:
                    case BotClientState.EnterQuest:
                    case BotClientState.Trade:
                    case BotClientState.BuyEctos:
                        e.CellStyle.BackColor = Color.LightGreen;
                        break;

                    case BotClientState.Pause:
                        e.CellStyle.BackColor = Color.LightYellow;
                        break;

                    case BotClientState.Disconnected:
                        e.CellStyle.BackColor = Color.LightGray;
                        break;

                    case BotClientState.HardReset:
                    case BotClientState.ResetQuest:
                        e.CellStyle.BackColor = Color.LightBlue;
                        break;

                    case BotClientState.WaitCharacterSelect:
                        e.CellStyle.BackColor = Color.Orange;
                        break;

                    default:
                        e.CellStyle.BackColor = Color.White;
                        break;
                }
            }
        }

        private async void buttonStartSelectedClients_Click(object sender, EventArgs e)
        {
            startSelectBotClientsButton.Enabled = false;

            var checkedClients = botClientCheckList.CheckedItems
                .Cast<BotClient>()
                .ToList();

            foreach (var client in checkedClients)
            {
                if (client.TcpConnection == null)
                {
                    StartClient(client);
                    //await Task.Delay(12000); // niet Thread.Sleep, maar non-blocking
                }
            }

            startSelectBotClientsButton.Enabled = true;
        }

        private void LoadBotClients()
        {
            try
            {
                string path = Path.Combine(Application.StartupPath, "clients.json");
                var loadedClients = BotClientLoader.LoadFromJson(path);

                clients = new BindingList<BotClient>(loadedClients);
                botClientCheckList.DataSource = clients;
                botClientCheckList.DisplayMember = "CharacterName";

                AppendLog("Bot clients geladen uit clients.json");
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Failed to load bot clients:\n{ex.Message}", "Load Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                AppendLog("Fout bij laden van clients.json: " + ex.Message);
            }
        }

        public static void Log(string log)
        {
            form.Invoke(new MethodInvoker(delegate ()
            {
                form.textBoxLog.AppendText(" >> Server: " + log + Environment.NewLine);
            }));
        }

        public void AppendLog(string text)
        {
            if (InvokeRequired)
                Invoke(new Action<string>(AppendLog), text);
            else
                textBoxLog.AppendText($"{DateTime.Now:HH:mm:ss} >> {text}{Environment.NewLine}");
        }

        public void AddRunningBotClient(BotClientView view)
        {
            if (InvokeRequired)
            {
                Invoke(new Action<BotClientView>(AddRunningBotClient), view);
                return;
            }
            _runningClientsViews.Add(view);

            if (view.Source != null)
            {
                clients.Remove(view.Source);
            }
        }

        public void RemoveRunningBotClient(BotClient client)
        {
            if (InvokeRequired)
            {
                Invoke(new Action<BotClient>(RemoveRunningBotClient), client);
                return;
            }

            _runningClientsViews.Remove(client.View);

            if (client != null)
            {
                clients.Add(client);
            }
        }

        #region Button Clicks

        private void buttonSelectSourceTxt_Click(object sender, EventArgs e)
        {
            OpenFileDialog openFileDialog = new OpenFileDialog();
            DialogResult result = openFileDialog.ShowDialog(); // Show the dialog.
            if (result == DialogResult.OK) // Test result.
            {
                Settings.SetSourceListFileLocation(openFileDialog.FileName);
                //ReadFileForClients();
                this.botClientCheckList.Items.Clear();
                this.botClientCheckList.Items.AddRange(sourceClientList.Select(x => x.characterName).ToArray());
            }
        }
        private void buttonSelectScript_Click(object sender, EventArgs e)
        {
            OpenFileDialog openFileDialog = new OpenFileDialog();
            DialogResult result = openFileDialog.ShowDialog(); // Show the dialog.
            if (result == DialogResult.OK) // Test result.
            {
                Settings.SetScriptFileLocation(openFileDialog.FileName);
            }
        }
        private void buttonSelectMultiLauncher_Click(object sender, EventArgs e)
        {
            OpenFileDialog openFileDialog = new OpenFileDialog();
            DialogResult result = openFileDialog.ShowDialog(); // Show the dialog.
            if (result == DialogResult.OK) // Test result.
            {
                Settings.SetMultiLauncherFileLocation(openFileDialog.FileName);
            }
        }
        private void buttonSelectAutoLaunch_Click(object sender, EventArgs e)
        {
            OpenFileDialog openFileDialog = new OpenFileDialog();
            DialogResult result = openFileDialog.ShowDialog(); // Show the dialog.
            if (result == DialogResult.OK) // Test result.
            {
                Settings.SetAutoLaunchFileLocation(openFileDialog.FileName);
            }
        }



        private void buttonEndAllSelectedClients_Click(object sender, EventArgs e)
        {
            sourceClientList.Where(x => x.tcpClient == null).ToList().ForEach(client =>
            {
                client.SendMessage("Stop process");
            });
        }

        #endregion



        public void StartClient(BotClient client)
        {

            string args = "-fps 15 -noshaders -email " + client.Email + " -password " + client.Password + " -character \"" + client.CharacterName + "\"";
            var started = Launcher.LaunchGame(client.GameClientPath, args);

            if (started)
            {
                //Thread.Sleep(2000);
                using (Process sProcess = new Process())
                {

                    //pProcess.StartInfo.FileName = @Settings.GetMultiLauncherFileLocation();
                    sProcess.StartInfo.FileName = @"C:\Program Files (x86)\AutoIt3\AutoIt3.exe";
                    sProcess.StartInfo.Arguments = "\"" + Settings.GetScriptFileLocation() + "\" \"" + client.CharacterName + "\"" + " True";
                    sProcess.StartInfo.UseShellExecute = true;
                    //pProcess.StartInfo.RedirectStandardOutput = true;
                    //pProcess.StartInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
                    //pProcess.StartInfo.CreateNoWindow = true; //not diplay a windows
                    sProcess.StartInfo.Verb = "runas";
                    sProcess.Start();

                    //do
                    //{
                    //    Thread.Sleep(1000);
                    //}
                    //while (client.TcpConnection == null);
                }
            }
        }
        private void Data_Load(object sender, System.EventArgs e)
        {
            // Populate the data source.
            foreach (var client in sourceClientList)
            {
                bindingSource1.Add(client.clientViewModel);

            }
            // Initialize the DataGridView.
            dataGridView1.AutoGenerateColumns = true;
            dataGridView1.AutoSize = true;
            dataGridView1.DataSource = bindingSource1;

        }

        private void groupBox4_Enter(object sender, EventArgs e)
        {

        }

        private void groupBox3_Enter(object sender, EventArgs e)
        {

        }

        private void tabPage1_Click(object sender, EventArgs e)
        {

        }

        private void textBoxStartupDelay_TextChanged(object sender, EventArgs e)
        {

        }

        private void checkedListBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void checkedListBox4_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void buttonSelectScript_Click_1(object sender, EventArgs e)
        {

        }

        private void textBoxSelectedScript_TextChanged(object sender, EventArgs e)
        {

        }
    }
}