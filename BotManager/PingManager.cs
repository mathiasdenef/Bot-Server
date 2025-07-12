using System;
using System.ComponentModel;

namespace BotManager;
public class PingManager
{
    private readonly BindingList<BotClientView> _clients;
    private readonly System.Windows.Forms.Timer _pingTimer;

    public PingManager(BindingList<BotClientView> clients)
    {
        _clients = clients;
        _pingTimer = new System.Windows.Forms.Timer();
        _pingTimer.Interval = 5000; // elke 5 seconden pingen
        _pingTimer.Tick += PingAllClients;
        _pingTimer.Start();
    }

    private void PingAllClients(object? sender, EventArgs e)
    {
        foreach (var client in _clients.ToList())
        {
            if (client.Source.TcpConnection == null) continue;

            try
            {
                client.Source.SendMessage("PING");
            }
            catch (Exception ex)
            {
                BotManagerForm.Log($"[PING FAIL] {client.CharacterName}: {ex.Message}");
            }
        }

        //RemoveDeadClients();
    }

    public void HandlePong(BotClient client)
    {
        client.LastPongTime = DateTime.Now;
    }

    private void RemoveDeadClients()
    {
        foreach (var client in _clients.ToList())
        {
            if (!client.Source.IsAlive)
            {
                BotManagerForm.Log($"[TIMEOUT] {client.CharacterName} disconnected (no PONG).");
                client.Source.CloseConnection();
                _clients.Remove(client);
            }
        }
    }
}
