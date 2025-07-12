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

        private BindingList<BotClient> _clients = [];
        private BindingList<BotClientView> _clientViews = [];
        private TcpBotServer _server;

        public BotManagerForm()
        {
            InitializeComponent();
            form = this;
            Settings.Initalize();
        }

        private async void BotManagerForm_Load(object sender, EventArgs e)
        {
            ConfigureBotGrid();
            GenerateTestClients();
            LoadBotClients();
            _server = new TcpBotServer(this);
            await _server.StartAsync(5000);
            
        }

        private void selectAllBotClientsButton_Click(object sender, EventArgs e)
        {
            for (int i = 0; i < botClientCheckList.Items.Count; i++)
            {
                botClientCheckList.SetItemChecked(i, true);
            }
        }

        private void BotClientCheckList_ItemCheck(object sender, ItemCheckEventArgs e)
        {
            // ItemCheck event wordt vóór de waarde effectief wijzigt, dus we tellen handmatig
            int checkedCount = botClientCheckList.CheckedItems.Count + (e.NewValue == CheckState.Checked ? 1 : -1);
            startSelectBotClientsButton.Enabled = checkedCount > 0;
        }

        private void GenerateTestClients()
        {
            var random = new Random();
            _clientViews = new BindingList<BotClientView>();

            string[] states = { "Idle", "Running", "Disconnected", "Error" };

            for (int i = 1; i <= 10; i++)
            {
                _clientViews.Add(new BotClientView
                {
                    IsSelected = false,
                    CharacterName = $"Bot_{i}",
                    State = states[random.Next(states.Length)],
                    Connected = random.Next(2) == 1,
                    Source = null // kan vervangen worden door een dummy BotClient als je wil
                });
            }

            botClientGrid.DataSource = _clientViews;
        }

        private void ConfigureBotGrid()
        {
            botClientGrid.DataSource = _clientViews;
            botClientGrid.AutoGenerateColumns = true;
            botClientGrid.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            botClientGrid.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            botClientGrid.AllowUserToAddRows = false;
            botClientGrid.AlternatingRowsDefaultCellStyle.BackColor = Color.LightGray;
            botClientGrid.CellFormatting += botClientGrid_CellFormatting;
            foreach (DataGridViewColumn column in botClientGrid.Columns)
            {
                column.ReadOnly = true;
            }

            botClientGrid.Columns["IsSelected"].ReadOnly = false;
        }

        private void botClientGrid_CellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
        {
            if (botClientGrid.Columns[e.ColumnIndex].Name == "Connected" && e.Value is bool connected)
            {
                e.CellStyle.BackColor = connected ? Color.LightGreen : Color.MistyRose;
                e.CellStyle.Font = new Font(e.CellStyle.Font, FontStyle.Bold);
            }

            if (botClientGrid.Columns[e.ColumnIndex].Name == "State" && e.Value is string state)
            {
                if (state.Contains("Error"))
                    e.CellStyle.BackColor = Color.IndianRed;
                else if (state.Contains("Running"))
                    e.CellStyle.BackColor = Color.LightGreen;
                else if (state.Contains("Disconnected"))
                    e.CellStyle.BackColor = Color.LightGray;
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

                _clients = new BindingList<BotClient>(loadedClients);
                botClientCheckList.DataSource = _clients;
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