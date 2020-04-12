using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
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
        //static List<HandleClient> handleClientList = new List<HandleClient>();

        public Form1()
        {
            InitializeComponent();
            listBoxClients.DataSource = clientList;
            listBoxClients.DisplayMember = "clNo";
            form = this;
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
                                client.SendMessage("Dit is een test");
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
                    Client client = new Client(clientSocket, Convert.ToString(counter));
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
                   client.SendMessage("Close");
               });
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
