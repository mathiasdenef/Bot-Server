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

    public TcpBotServer(BotManagerForm form)
    {
        _form = form;
    }

    private static readonly Dictionary<int, BotClientState> StateIdMap = new()
    {
        [0] = BotClientState.Idle,
        [1] = BotClientState.WaitCharacterSelect,
        [2] = BotClientState.EnterQuest,
        [3] = BotClientState.RunQuest,
        [4] = BotClientState.ResetQuest,
        [5] = BotClientState.HardReset,
        [6] = BotClientState.BuyEctos,
        [7] = BotClientState.Trade,
        [8] = BotClientState.Disconnected,
        [9] = BotClientState.Pause,
        [10] = BotClientState.Error
    };

    public async Task StartAsync(int port = 5000)
    {
        _listener = new TcpListener(IPAddress.Any, port);
        _listener.Start();
        _form.AppendLog($"[Server] Luistert op poort {port}");

        while (true)
        {
            TcpClient tcpClient = await _listener.AcceptTcpClientAsync();
            _form.AppendLog("[Server] Nieuwe bot verbonden.");
            _ = HandleClientAsync(tcpClient);
        }
    }

    private async Task HandleClientAsync(TcpClient tcpClient)
    {
        var stream = tcpClient.GetStream();
        byte[] buffer = new byte[1024];
        BotClient? botClient = null;

        try
        {
            while (tcpClient.Connected)
            {
                int bytesRead = await stream.ReadAsync(buffer, 0, buffer.Length);
                if (bytesRead == 0)
                {
                    break;
                }

                string message = Encoding.UTF8.GetString(buffer, 0, bytesRead).Trim();
                //_form.AppendLog("[Client] " + message);

                if (message.StartsWith("IDENTIFY"))
                {
                    string name = message.Substring("IDENTIFY|".Length).Trim();
                    botClient = _form.clients.FirstOrDefault(c => c.CharacterName == name);
                    if (botClient != null)
                    {
                        botClient.TcpConnection = tcpClient;
                        _form.AppendLog($"[Manager] Bot '{name}' is now connected.");

                        var view = new BotClientView
                        {
                            IsSelected = false,
                            CharacterName = botClient.CharacterName,
                            State = BotClientState.Unknown,
                            Source = botClient
                        };
                        botClient.View = view;
                        _form.AddRunningBotClient(view);
                    }
                    else
                    {
                        _form.AppendLog($"[Warning] Bot '{name}' not found in loaded client list.");
                    }
                }
                else if (message.StartsWith("PONG"))
                {
                    if (botClient != null)
                    {
                        _form.pingManager.HandlePong(botClient);
                        //_form.AppendLog($"[PONG] {botClient.CharacterName} responded.");
                    }
                    else
                    {
                        //_form.AppendLog($"[Warning] PONG from unknown bot.");
                    }
                }
                else if (message.StartsWith("STATE|"))
                {
                    // Verwacht: STATE|<CharacterName>|<StateName>
                    var parts = message.Split('|');
                    if (parts.Length == 2 && int.TryParse(parts[1].Trim(), out int stateId))
                    {

                        if (botClient.View != null)
                        {
                            if (StateIdMap.TryGetValue(stateId, out var newState))
                            {
                                botClient.View.State = newState;
                                _form.AppendLog($"[STATE] {botClient.CharacterName} updated to {newState}");
                            }
                            else
                            {
                                _form.AppendLog($"[STATE] Unknown state '{stateId}' for bot '{botClient.CharacterName}'");
                            }
                        }
                        else
                        {
                            _form.AppendLog($"[STATE] BotClientView for '{botClient.CharacterName}' not found.");
                        }
                    }
                    else
                    {
                        _form.AppendLog("[STATE] Invalid state message format.");
                    }
                }
            }
        }
        catch (Exception ex)
        {
            _form.AppendLog($"[Error while reading] {ex.Message}");
        }
        finally
        {
            _form.AppendLog("[Disconnect] Client disconnected.");
            if (botClient != null)
            {
                botClient.TcpConnection?.Close();
                botClient.TcpConnection = null;
                _form.RemoveRunningBotClient(botClient);
            }
            else
            {
                tcpClient.Close();
            }
        }
    }
}
