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

namespace Bot_Server_WinForms
{

    public partial class Form1 : Form
    {
        public static Form1 form = null;
        public BindingList<Client> clientList = new BindingList<Client>();
        public List<Client> sourceClientList = new List<Client>();
        private BindingSource bindingSource1 = new BindingSource();
      
        public Form1()
        {
            InitializeComponent();
            listBoxClients.DataSource = clientList;
            listBoxClients.DisplayMember = "characterName";
            form = this;
            Settings.Initalize();
            this.ReadFileForClients();
            this.checkedListBox1.Items.AddRange(sourceClientList.Where(x => x.tcpClient == null).Select(x => x.characterName).ToArray());
            this.checkedListBox3.Items.AddRange(sourceClientList.Where(x => x.tcpClient != null).Select(x => x.characterName).ToArray());
            this.checkedListBox2.Items.AddRange(sourceClientList.Where(x => x.tcpClient != null).Select(x => x.characterName).ToArray());
            this.Load += new System.EventHandler(Data_Load);
        }

        public void ListenToNewClients()
        {
            try
            {
                Log("Start listening to new clients...");
                TcpListener serverSocket = new TcpListener(IPAddress.Parse("127.0.0.1"), 11000);
                serverSocket.Start();

                int counter = 0;

                while (true)
                {
                    counter += 1;
                    TcpClient clientSocket = serverSocket.AcceptTcpClient();
                    var characterName = WaitForCharacterNameForClient(clientSocket);
                    var client = sourceClientList.Where(x => x.characterName == characterName).FirstOrDefault();
                    client.tcpClient = clientSocket;
                    client.clientId = counter.ToString();
                    client.Connect();
                    client.Start();
                }
            }
            catch (Exception e)
            {

            }
        }

        public static void Log(string log)
        {
            form.Invoke(new MethodInvoker(delegate ()
            {
                form.textBoxLog.AppendText(" >> Server: " + log + Environment.NewLine);
            }));
        }

        #region Button Clicks
        private void buttonStartServer_Click(object sender, EventArgs e)
        {
            StartServer();
        }

        private void buttonSelectSourceTxt_Click(object sender, EventArgs e)
        {
            OpenFileDialog openFileDialog = new OpenFileDialog();
            DialogResult result = openFileDialog.ShowDialog(); // Show the dialog.
            if (result == DialogResult.OK) // Test result.
            {
                Settings.SetSourceListFileLocation(openFileDialog.FileName);
                ReadFileForClients();
                this.checkedListBox1.Items.Clear();
                this.checkedListBox1.Items.AddRange(sourceClientList.Select(x => x.characterName).ToArray());
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


        private void buttonStartSelectedClients_Click(object sender, EventArgs e)
        {
            var checkedList = checkedListBox1.CheckedItems.Cast<string>().ToList();
            ThreadStart ths = new ThreadStart(() =>
            {

                foreach (string clientCharacterName in checkedList)
                {
                    var client = sourceClientList.Where(x => x.characterName == clientCharacterName).FirstOrDefault();
                    if (client.tcpClient == null)
                    {

                        StartClient(client);
                        Thread.Sleep(10000);
                    }
                }
            });
            Thread th = new Thread(ths);
            th.Start();
        }
        private void buttonStartAllClients_Click(object sender, EventArgs e)
        {
            ThreadStart ths = new ThreadStart(() =>
            {

                sourceClientList.Where(x => x.tcpClient == null).ToList().ForEach(client =>
                {
                    StartClient(client);
                    Thread.Sleep(10000);
                });
            });

            Thread th = new Thread(ths);
            th.Start();
        }
        private void buttonStopSelectedClients_Click(object sender, EventArgs e)
        {
            var checkedList = checkedListBox3.CheckedItems.Cast<string>().ToList();
            foreach (string clientCharacterName in checkedList)
            {
                var client = sourceClientList.Where(x => x.characterName == clientCharacterName).FirstOrDefault();
                if (client.tcpClient != null)
                {
                    client.SendMessage("Stop process");
                }
            }
        }
        private void buttonEndAllSelectedClients_Click(object sender, EventArgs e)
        {
            sourceClientList.Where(x => x.tcpClient == null).ToList().ForEach(client =>
            {
                client.SendMessage("Stop process");
            });
        }


        private void buttonStartTradeAllClients_Click(object sender, EventArgs e)
        {
            var checkedList = checkedListBox2.Items.Cast<string>().ToList();
            foreach (string clientCharacterName in checkedList)
            {
                var client = sourceClientList.Where(x => x.characterName == clientCharacterName).FirstOrDefault();
                client.SendMessage("Start Trading");

            }
        }
        private void buttonStopTradeClients_Click(object sender, EventArgs e)
        {

            var checkedListTrade = checkedListBox2.Items.Cast<string>().ToList();
            foreach (string clientCharacterName in checkedListTrade)
            {
                var client = sourceClientList.Where(x => x.characterName == clientCharacterName).FirstOrDefault();
                client.SendMessage("Stop Trading");

            }
        }
        private void buttonStartTradeSelectedClients_Click(object sender, EventArgs e)
        {
            var checkedList = checkedListBox2.CheckedItems.Cast<string>().ToList();
            foreach (string clientCharacterName in checkedList)
            {
                var client = sourceClientList.Where(x => x.characterName == clientCharacterName).FirstOrDefault();
                client.SendMessage("Start Trading");

            }
        }

        #endregion

        #region Helper Functions
        private void ReadFileForClients()
        {
            string line;
            sourceClientList = new List<Client>();
            // Read the file and display it line by line.  
            if (File.Exists(Settings.settings.sourceClientListFileLocation))
            {
                System.IO.StreamReader file =
                    new System.IO.StreamReader(Settings.settings.sourceClientListFileLocation);
                while ((line = file.ReadLine()) != null)
                {
                    var splittedLine = line.Split('|');
                    var email = splittedLine[0];
                    var password = splittedLine[1];
                    var characterName = splittedLine[2];
                    var gameClient = splittedLine[3];
                    sourceClientList.Add(new Client(characterName, email, password, gameClient));
                }
                file.Close();
            }

        }
        public string WaitForCharacterNameForClient(TcpClient tcpClient)
        {
            byte[] bytesFrom = new byte[10025];
            NetworkStream networkStream = tcpClient.GetStream();
            networkStream.Read(bytesFrom, 0, bytesFrom.Length);
            string dataFromClient = Encoding.ASCII.GetString(bytesFrom);
            dataFromClient = dataFromClient.Substring(0, dataFromClient.IndexOf("\0"));
            return dataFromClient;
        }

        public void StartServer()
        {
            buttonStartServer.Enabled = false;
            buttonStartServer.Text = "Started";
            Log("Server Started");
            Thread ctThread = new Thread(ListenToNewClients);
            ctThread.Start();
        }

        public void StartClient(Client client)
        {
            using (Process cProcess = new Process())
            {

                //pProcess.StartInfo.FileName = @Settings.GetMultiLauncherFileLocation();
                cProcess.StartInfo.FileName = @"C:\Program Files (x86)\AutoIt3\AutoIt3.exe";
                cProcess.StartInfo.Arguments = "\"" + Settings.GetAutoLaunchFileLocation() + "\" \"" + Settings.GetMultiLauncherFileLocation() + "\" \"" + client.gameClient + "\" \"" + client.email + "\" \"" + client.password + "\" \"" + client.characterName + "\" \"" + this.checkBoxMinimizedClient.Checked + "\"";
                //pProcess.StartInfo.UseShellExecute = true;
                //pProcess.StartInfo.RedirectStandardOutput = true;
                //pProcess.StartInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
                //pProcess.StartInfo.CreateNoWindow = true; //not diplay a windows
                //cProcess.StartInfo.Verb = "runas";
                cProcess.Start();

                do
                {
                    Thread.Sleep(1000);
                }
                while (!cProcess.HasExited);


                using (Process sProcess = new Process())
                {

                    //pProcess.StartInfo.FileName = @Settings.GetMultiLauncherFileLocation();
                    sProcess.StartInfo.FileName = @"C:\Program Files (x86)\AutoIt3\AutoIt3.exe";
                    sProcess.StartInfo.Arguments = "\"" + Settings.GetScriptFileLocation() + "\" \"" + client.characterName + "\"";
                    //pProcess.StartInfo.UseShellExecute = true;
                    //pProcess.StartInfo.RedirectStandardOutput = true;
                    //pProcess.StartInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
                    //pProcess.StartInfo.CreateNoWindow = true; //not diplay a windows
                    sProcess.StartInfo.Verb = "runas";
                    sProcess.Start();

                    do
                    {
                        Thread.Sleep(1000);
                    }
                    while (client.tcpClient == null);
                }
            }
        }
        private void Data_Load(object sender, System.EventArgs e)
        {
            // Populate the data source.
            bindingSource1.Add(new Client() { characterName = "Bob", warSupplies = 10, succesRuns = 20, failRuns = 30 });
            bindingSource1.Add(new Client() { characterName = "Snow", warSupplies = 20, succesRuns = 45, failRuns = 3045 });
            bindingSource1.Add(new Client() { characterName = "Prop", warSupplies = 60, succesRuns = 686, failRuns = 455 });
            bindingSource1.Add(new Client() { characterName = "Dana", warSupplies = 404, succesRuns = 489, failRuns = 879 });
            bindingSource1.Add(new Client() { characterName = "WILLY", warSupplies = 778, succesRuns = 456, failRuns = 787 });

            // Initialize the DataGridView.
            dataGridView1.AutoGenerateColumns = true;
            dataGridView1.AutoSize = true;
            dataGridView1.DataSource = bindingSource1;

        }
        #endregion

        #region Form Handlers
        private void Form1_FormClosed(object sender, FormClosedEventArgs e)
        {
            clientList.ToList().ForEach(
                client =>
                {
                    client.SendMessage("Stopped Server");
                });
        }
        private void Form1_Load(object sender, EventArgs e)
        {
            StartServer();
        }


        #endregion

        private void buttonTestClick_Click(object sender, EventArgs e)
        {
            using (Process pProcess = new Process())
            {

                pProcess.StartInfo.FileName = @"C:\Program Files (x86)\AutoIt3\AutoIt3.exe";
                //pProcess.StartInfo.Arguments = "\"" + Settings.GetAutoLaunchFileLocation() + "\" \"" + Settings.GetMultiLauncherFileLocation() + "\" \"" + client.gameClient + "\" \"" + client.email + "\" \"" + client.password + "\" \"" + client.characterName + "\" \"" + Settings.GetScriptFileLocation() + "\" \"" + this.checkBoxMinimizedClient.Checked + "\""; //argument
                pProcess.StartInfo.UseShellExecute = true;
                //pProcess.StartInfo.RedirectStandardOutput = true;
                //pProcess.StartInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
                //pProcess.StartInfo.CreateNoWindow = true; //not diplay a windows
                pProcess.StartInfo.Verb = "runas";
                pProcess.Start();

            }
        }

        //Class to handle each client request separatly
        //public class HandleClient
        //{
        //    public TcpClient tcpClient;
        //    public string clNo;
        //    public void StartClient(TcpClient tcpClient, string clineNo)
        //    {
        //        this.tcpClient = tcpClient;
        //        this.clNo = clineNo;
        //        form.Invoke(new MethodInvoker(delegate ()
        //        {
        //            form.handleClientList.Add(this);

        //        }));
        //        Thread ctThread = new Thread(DoSomething);
        //        ctThread.Start();
        //    }

        //    public void DoSomething()
        //    {
        //        byte[] bytesFrom = new byte[10025];
        //        int requestCount = 0;

        //        while (true)
        //        {
        //            try
        //            {
        //                requestCount += 1;
        //                NetworkStream networkStream = tcpClient.GetStream();
        //                networkStream.Read(bytesFrom, 0, bytesFrom.Length);
        //                string dataFromClient = System.Text.Encoding.ASCII.GetString(bytesFrom);
        //                dataFromClient = dataFromClient.Substring(0, dataFromClient.IndexOf("$"));
        //                Console.WriteLine(" >> " + "From client-" + clNo + dataFromClient);

        //                string rCount = Convert.ToString(requestCount);
        //                string serverResponse = "Server to client(" + clNo + ") " + rCount;
        //                byte[] sendBytes = Encoding.ASCII.GetBytes(serverResponse);
        //                networkStream.Write(sendBytes, 0, sendBytes.Length);
        //                networkStream.Flush();
        //                Console.WriteLine(" >> " + serverResponse);
        //            }
        //            catch (Exception ex)
        //            {
        //                form.Invoke(new MethodInvoker(delegate ()
        //                {
        //                    form.textBoxLog.AppendText(" >> Client No:" + Convert.ToString(clNo) + " disconnected!" + Environment.NewLine);
        //                }));

        //                form.Invoke(new MethodInvoker(delegate ()
        //                {
        //                    form.handleClientList.Remove(this);
        //                }));
        //                break;
        //            }
        //        }
        //    }

        //    public void SendMessage(string text)
        //    {
        //        NetworkStream networkStream = tcpClient.GetStream();
        //        byte[] sendBytes = Encoding.ASCII.GetBytes(text);
        //        networkStream.Write(sendBytes, 0, sendBytes.Length);
        //        networkStream.Flush();
        //    }
        //}
    }
}