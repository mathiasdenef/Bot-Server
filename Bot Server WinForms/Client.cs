using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Bot_Server_WinForms
{
    public class Client
    {
        public TcpClient tcpClient;
        public string clientId;
        public string characterName;
        public string email;
        public string password;
        public string gameClient;
        public int warSupplies;
        public int succesRuns;
        public int failRuns;

        public Client(TcpClient tcpClient, string clNo)
        {
            this.tcpClient = tcpClient;
            this.clientId = clNo;
        }
        public Client(string characterName, string email, string password, string gameClient)
        {
            this.characterName = characterName;
            this.email = email;
            this.password = password;
            this.gameClient = gameClient;
        }
        public void Start()
        {
             Form1.form.Invoke(new MethodInvoker(delegate ()
            {
                Form1.form.clientList.Add(this);
                Form1.form.checkedListBox1.Items.Remove(this.characterName);
                Form1.form.checkedListBox2.Items.Add(this.characterName);
                Form1.form.checkedListBox3.Items.Add(this.characterName);
            }));
            Thread ctThread = new Thread(StartListening);
            ctThread.Start();
        }

        public void Stop()
        {
            this.tcpClient = null;
            Form1.form.Invoke(new MethodInvoker(delegate ()
            {
                Form1.form.clientList.Remove(this);
                Form1.form.checkedListBox1.Items.Add(this.characterName);
                Form1.form.checkedListBox2.Items.Remove(this.characterName);
                Form1.form.checkedListBox3.Items.Remove(this.characterName);
            }));
     
            Disconnect();
        }

        public void Connect()
        {
            Form1.Log(characterName + " connected!");
        }

        public void Disconnect()
        {
            Form1.Log(characterName + " disconnected!");
        }

        private void StartListening()
        {
            byte[] bytesFrom = new byte[10025];

            while (true)
            {
                try
                {
                    NetworkStream networkStream = tcpClient.GetStream();
                    networkStream.Read(bytesFrom, 0, bytesFrom.Length);
                    string dataFromClient = Encoding.ASCII.GetString(bytesFrom);
                    dataFromClient = dataFromClient.Substring(0, dataFromClient.IndexOf("\0"));

                    var dataFromClientSplitted = dataFromClient.Split('|');
                    var messageType = dataFromClientSplitted[0];
                    switch (messageType)
                    {
                        case "Stats":
                            var warSuppliesString = dataFromClientSplitted.Contains("War Supplies").ToString();
                            this.warSupplies = Convert.ToInt32(warSuppliesString.Substring(warSuppliesString.LastIndexOf('=') + 1));
                            var successRunsString = dataFromClientSplitted.Contains("Success Runs").ToString();
                            this.succesRuns = Convert.ToInt32(successRunsString.Substring(successRunsString.LastIndexOf('=') + 1));
                            var failRunsString = dataFromClientSplitted.Contains("Fail Runs").ToString();
                            this.failRuns = Convert.ToInt32(failRunsString.Substring(failRunsString.LastIndexOf('=') + 1)); 
                            break;
                    }
                    

                    //string serverResponse = "Server to client(" + clientId + ") ";
                    //byte[] sendBytes = Encoding.ASCII.GetBytes(serverResponse);
                    //networkStream.Write(sendBytes, 0, sendBytes.Length);
                    //networkStream.Flush();
                    //Log("Send response to client");
                }
                catch (Exception ex)
                {
                    Stop();
                    break;
                }
            }
        }

        public void SendMessage(string text)
        {
            NetworkStream networkStream = tcpClient.GetStream();
            byte[] sendBytes = Encoding.ASCII.GetBytes(text);
            networkStream.Write(sendBytes, 0, sendBytes.Length);
            networkStream.Flush();
        }

        public void Log(string log)
        {
            Form1.form.Invoke(new MethodInvoker(delegate ()
            {
                Form1.form.textBoxLog.AppendText(" >> " + characterName + ": " + log + Environment.NewLine);
            }));
        }

        public override string ToString()
        {
            return characterName;
        }
    }
}
