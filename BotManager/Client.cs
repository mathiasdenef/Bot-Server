using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace BotManager
{
    public class Client
    {
        public TcpClient tcpClient { get; set; }
        public string clientId { get; set; }
        public string characterName { get; set; }
        public string email { get; set; }
        public string password { get; set; }
        public string gameClient { get; set; }
        public ClientViewModel clientViewModel { get; set; }

        public Client(TcpClient tcpClient, string clNo)
        {
            this.tcpClient = tcpClient;
            this.clientId = clNo;
        }
        public Client(string characterName, string email, string password, string gameClient, ClientViewModel clientViewModel)
        {
            this.characterName = characterName;
            this.email = email;
            this.password = password;
            this.gameClient = gameClient;
            this.clientViewModel = clientViewModel;
        }

        public Client()
        { }
        //public void Start()
        //{
        //    Connect();
        //    BotManager.form.Invoke(new MethodInvoker(delegate ()
        //   {
        //       this.clientViewModel.Running = "Yes";
        //       BotManager.form.clientList.Add(this);
        //       BotManager.form.botClientCheckList.Items.Remove(this.characterName);
        //       BotManager.form.checkedListBox2.Items.Add(this.characterName);
        //       BotManager.form.checkedListBox3.Items.Add(this.characterName);
        //       BotManager.form.dataGridView1.Refresh();
        //   }));
        //    Thread ctThread = new Thread(StartListening);
        //    ctThread.Start();
        //    Thread hearthBeatThread = new Thread(SendHeartBeat);
        //    hearthBeatThread.Start();
        //}

        //public void Stop()
        //{
        //    this.tcpClient = null;
        //    BotManager.form.Invoke(new MethodInvoker(delegate ()
        //    {
        //        this.clientViewModel.Running = "No";
        //        BotManager.form.clientList.Remove(this);
        //        BotManager.form.botClientCheckList.Items.Add(this.characterName);
        //        BotManager.form.checkedListBox2.Items.Remove(this.characterName);
        //        BotManager.form.checkedListBox3.Items.Remove(this.characterName);
        //        BotManager.form.dataGridView1.Refresh();
        //    }));

        //    Disconnect();
        //}

        public void Connect()
        {
            BotManagerForm.Log(characterName + " connected!");
        }

        public void Disconnect()
        {
            BotManagerForm.Log(characterName + " disconnected!");
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
                            var warSuppliesString = dataFromClientSplitted.Where(x => x.Contains("War Supplies")).FirstOrDefault();
                            this.clientViewModel.WarSupplies = Convert.ToInt32(warSuppliesString.Substring(warSuppliesString.LastIndexOf('=') + 1));
                            var successRunsString = dataFromClientSplitted.Where(x => x.Contains("Success Runs")).FirstOrDefault();
                            this.clientViewModel.SuccesRuns = Convert.ToInt32(successRunsString.Substring(successRunsString.LastIndexOf('=') + 1));
                            var failRunsString = dataFromClientSplitted.Where(x => x.Contains("Fail Runs")).FirstOrDefault();
                            this.clientViewModel.FailRuns = Convert.ToInt32(failRunsString.Substring(failRunsString.LastIndexOf('=') + 1));
                            BotManagerForm.form.Invoke(new MethodInvoker(delegate ()
                            {

                                BotManagerForm.form.dataGridView1.Refresh();
                            }));
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
                    //Stop();
                    break;
                }
            }
        }

        public void SendHeartBeat()
        {
            while (true)
            {
                if (tcpClient != null)
                {
                    SendMessage("HeartBeat");
                    Thread.Sleep(30000);
                }
            }
        }

        public void SendMessage(string text)
        {
            if (tcpClient != null)
            {
                NetworkStream networkStream = tcpClient.GetStream();
                byte[] sendBytes = Encoding.ASCII.GetBytes(text);
                networkStream.Write(sendBytes, 0, sendBytes.Length);
                networkStream.Flush();
            }
        }

        public void Log(string log)
        {
            BotManagerForm.form.Invoke(new MethodInvoker(delegate ()
            {
                BotManagerForm.form.textBoxLog.AppendText(" >> " + characterName + ": " + log + Environment.NewLine);
            }));
        }

        public override string ToString()
        {
            return characterName;
        }
    }
}
