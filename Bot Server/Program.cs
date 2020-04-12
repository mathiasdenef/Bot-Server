using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;

namespace Bot_Server
{
    class Program
    {
        static List<HandleClient> handleClientList = new List<HandleClient>();
        static void Main(string[] args)
        {
            Thread ctThread = new Thread(ListenToNewClients);
            ctThread.Start();

            while (true)
            {
                switch (Console.ReadLine())
                {
                    case "test1":
                        Console.WriteLine("JUST SOME RANDOM TESTING");
                        handleClientList.ForEach(
                            handleClient =>
                            {
                                handleClient.SendMessage("E:\\Guild Wars Clients\\Guild Wars 1\\Gw.exe");
                            });
                        break;

                    case "test2":
                        Console.WriteLine("JUST SOME RANDOM TESTING");
                        handleClientList.ForEach(
                            handleClient =>
                            {
                                handleClient.SendMessage("E:\\Guild Wars Clients\\Guild Wars 2\\Gw.exe");
                            });
                        break;
                }
            }
        }

        public static void ListenToNewClients()
        {
            //IPHostEntry host = Dns.GetHostEntry("localhost");
            //IPAddress ipAddress = host.AddressList[0];

            TcpListener serverSocket = new TcpListener(IPAddress.Parse("127.0.0.1"), 11000);
            serverSocket.Start();
            Console.WriteLine(" >> Server Started");

            int counter = 0;

            while (true)
            {
                counter += 1;
                TcpClient clientSocket = serverSocket.AcceptTcpClient();
                Console.WriteLine(" >> Client No:" + Convert.ToString(counter) + " started!");
                HandleClient handleClient = new HandleClient();
                handleClientList.Add(handleClient);
                handleClient.StartClient(clientSocket, Convert.ToString(counter));
            }
        }

        //Class to handle each client request separatly
        public class HandleClient
        {
            TcpClient tcpClient;
            string clNo;
            public void StartClient(TcpClient tcpClient, string clineNo)
            {
                this.tcpClient = tcpClient;
                this.clNo = clineNo;
                Thread ctThread = new Thread(DoChat);
                ctThread.Start();
            }
           
            public void DoChat()
            {
                byte[] bytesFrom = new byte[10025];
                int requestCount = 0;

                while (true)
                {
                    try
                    {
                        requestCount += 1;
                        NetworkStream networkStream = tcpClient.GetStream();
                        networkStream.Read(bytesFrom);
                        string dataFromClient = System.Text.Encoding.ASCII.GetString(bytesFrom);
                        dataFromClient = dataFromClient.Substring(0, dataFromClient.IndexOf("$"));
                        Console.WriteLine(" >> " + "From client-" + clNo + dataFromClient);

                        string rCount = Convert.ToString(requestCount);
                        string serverResponse = "Server to client(" + clNo + ") " + rCount;
                        byte[] sendBytes = Encoding.ASCII.GetBytes(serverResponse);
                        networkStream.Write(sendBytes, 0, sendBytes.Length);
                        networkStream.Flush();
                        Console.WriteLine(" >> " + serverResponse);
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine(" >> " + ex.ToString());
                        handleClientList.Remove(this);
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
        }
    }
}
