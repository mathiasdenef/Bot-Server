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
        public string sourceClientListFileLocation = "";
        public string scriptFileLocation = "";
        public string multiLauncherFileLocation = "";

        public Form1()
        {
            InitializeComponent();
            listBoxClients.DataSource = clientList;
            listBoxClients.DisplayMember = "characterName";
            form = this;
            this.readFileForClients();
            this.checkedListBox1.Items.AddRange(sourceClientList.Select(x => x.characterName).ToArray());
        }


        private void buttonStartServer_Click(object sender, EventArgs e)
        {
            buttonStartServer.Enabled = false;
            buttonStartServer.Text = "Started";
            Log("Server Started");
            Thread ctThread = new Thread(ListenToNewClients);
            ctThread.Start();
        }
        private void buttonStartClients_Click(object sender, EventArgs e)
        {
            clientList.ToList().ForEach(
                            client =>
                            {
                                client.SendMessage("Start Trading");
                            });
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

        private void buttonStopClients_Click(object sender, EventArgs e)
        {
            clientList.ToList().ForEach(
                client =>
               {
                   client.SendMessage("Stop Trading");
               });
        }

        private void Form1_FormClosed(object sender, FormClosedEventArgs e)
        {
            clientList.ToList().ForEach(
                client =>
                {
                    client.SendMessage("Stopped Server");
                });
        }

        private void readFileForClients()
        {
            string line;

            // Read the file and display it line by line.  
            System.IO.StreamReader file =
                new System.IO.StreamReader(@"X:\Guild wars\sourceClientList.txt");
            while ((line = file.ReadLine()) != null)
            {
                var splittedLine = line.Split('|');
                var email = splittedLine[0];
                var password = splittedLine[1];
                var characterName = splittedLine[2];
                sourceClientList.Add(new Client(characterName, email, password));
            }
            file.Close();

        }

        private void buttonStartAllClients_Click(object sender, EventArgs e)
        {

            sourceClientList.Where(x => x.tcpClient == null).ToList().ForEach(client =>
            {
                using (Process pProcess = new Process())
                {

                    pProcess.StartInfo.FileName = @"C:\Program Files (x86)\AutoIt3\AutoIt3.exe";
                    pProcess.StartInfo.Arguments = "C:\\Users\\thiba\\OneDrive\\Bureaublad\\TCPConnect.au3 \"" + client.characterName + "\""; //argument
                    pProcess.StartInfo.UseShellExecute = true;
                    //pProcess.StartInfo.RedirectStandardOutput = true;
                    //pProcess.StartInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
                    //pProcess.StartInfo.CreateNoWindow = true; //not diplay a windows
                    //pProcess.StartInfo.Verb = "runas";
                    pProcess.Start();

                    //string output = pProcess.StandardOutput.ReadToEnd(); //The output result

                }
            });
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

        private void buttonSelectSourceTxt_Click(object sender, EventArgs e)
        {
            OpenFileDialog openFileDialog = new OpenFileDialog();
                DialogResult result = openFileDialog.ShowDialog(); // Show the dialog.
                if (result == DialogResult.OK) // Test result.
                {
                    sourceClientListFileLocation = openFileDialog.FileName;
                    this.textBoxSelectedSourceAccounts.Text = sourceClientListFileLocation;
                }
        }

        private void buttonSelectScript_Click(object sender, EventArgs e)
        {
            OpenFileDialog openFileDialog = new OpenFileDialog();
            DialogResult result = openFileDialog.ShowDialog(); // Show the dialog.
            if (result == DialogResult.OK) // Test result.
            {
                scriptFileLocation = openFileDialog.FileName;
                this.textBoxSelectedScript.Text = scriptFileLocation;
            }
        }

        private void buttonSelectMultiLauncher_Click(object sender, EventArgs e)
        {
            OpenFileDialog openFileDialog = new OpenFileDialog();
            DialogResult result = openFileDialog.ShowDialog(); // Show the dialog.
            if (result == DialogResult.OK) // Test result.
            {
                multiLauncherFileLocation = openFileDialog.FileName;
                this.textBoxSelectedMultiLauncher.Text = multiLauncherFileLocation;
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

        //    public override string ToString()
        //    {
        //        return clNo.ToString();
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
