using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace BotManager;
public class BotClient
{
    public string Email { get; set; }
    public string Password { get; set; }
    public string CharacterName { get; set; }
    public string GameClientPath { get; set; }

    public TcpClient? TcpConnection { get; set; }

    public NetworkStream? Stream => TcpConnection?.Connected == true ? TcpConnection.GetStream() : null;

    public bool IsConnected => TcpConnection?.Connected ?? false;

    public BotClient(string email, string password, string characterName, string gameClientPath)
    {
        Email = email;
        Password = password;
        CharacterName = characterName;
        GameClientPath = gameClientPath;
    }

    public bool IsValid()
    {
        return !string.IsNullOrWhiteSpace(Email) &&
               !string.IsNullOrWhiteSpace(Password) &&
               !string.IsNullOrWhiteSpace(CharacterName) &&
               File.Exists(GameClientPath);
    }

    public void CloseConnection()
    {
        try
        {
            Stream?.Close();
            TcpConnection?.Close();
        }
        catch { }
        TcpConnection = null;
    }

    public void SendMessage(string message)
    {
        if (!IsConnected || Stream == null) return;

        byte[] buffer = Encoding.UTF8.GetBytes(message + "\n");
        try
        {
            Stream.Write(buffer, 0, buffer.Length);
        }
        catch
        {
            CloseConnection();
        }
    }

    public string? ReadMessage()
    {
        if (!IsConnected || Stream == null || !Stream.DataAvailable) return null;

        try
        {
            byte[] buffer = new byte[1024];
            int bytesRead = Stream.Read(buffer, 0, buffer.Length);
            return Encoding.UTF8.GetString(buffer, 0, bytesRead).Trim();
        }
        catch
        {
            CloseConnection();
            return null;
        }
    }

    public override string ToString()
    {
        return $"{CharacterName} ({Email}) [{(IsConnected ? "Online" : "Offline")}]";
    }
}
