using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace BotManager;
public class TcpBotServer
{
    private readonly BotManagerForm _form;
    private TcpListener _listener;
    private readonly List<TcpClient> _clients = [];

    public TcpBotServer(BotManagerForm form)
    {
        _form = form;
    }

    public async Task StartAsync(int port = 5000)
    {
        _listener = new TcpListener(IPAddress.Any, port);
        _listener.Start();
        _form.AppendLog($"[Server] Luistert op poort {port}");

        while (true)
        {
            TcpClient client = await _listener.AcceptTcpClientAsync();
            _clients.Add(client);

            _form.AppendLog("[Server] Nieuwe bot verbonden.");
            _ = HandleClientAsync(client);
        }
    }
    private async Task HandleClientAsync(TcpClient client)
    {
        using NetworkStream stream = client.GetStream();
        using StreamReader reader = new(stream, Encoding.UTF8);
        using StreamWriter writer = new(stream, Encoding.UTF8) { AutoFlush = true };

        try
        {
            while (true)
            {
                string line = await reader.ReadLineAsync();
                if (line == null) break;

                _form.AppendLog("[Ontvangen] " + line);

                string[] parts = line.Split('|');
                string command = parts[0];

                switch (command)
                {
                    case "IDENTIFY":
                        _form.AppendLog($"→ Botnaam: {parts[1]}");
                        break;

                    case "TRADE_READY":
                        _form.AppendLog($"→ Trade klaar van: {parts[1]}");
                        break;

                    case "STATS":
                        _form.AppendLog($"→ Stats: {string.Join(", ", parts[1..])}");
                        break;

                    case "PING":
                        await writer.WriteLineAsync("PONG");
                        break;

                    default:
                        _form.AppendLog($"→ Onbekend commando: {command}");
                        break;
                }

                // Terugkoppeling naar bot (optioneel)
                await writer.WriteLineAsync($"ACK|{command}");
            }
        }
        catch (IOException)
        {
            _form.AppendLog("[Verbinding] Client abrupt verbroken.");
        }
        catch (Exception ex)
        {
            _form.AppendLog("[Fout] " + ex.Message);
        }
        finally
        {
            client.Close();
            _clients.Remove(client);
        }
    }
}
