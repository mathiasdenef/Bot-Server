using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace BotManager;
public class BotClientLoader
{
    public static List<BotClient> LoadFromJson(string jsonPath)
    {
        if (!File.Exists(jsonPath))
            throw new FileNotFoundException("Bot clients config file not found.", jsonPath);

        string json = File.ReadAllText(jsonPath);

        var configs = JsonSerializer.Deserialize<List<BotClientConfig>>(json, new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true
        });

        var clients = new List<BotClient>();

        foreach (var cfg in configs ?? Enumerable.Empty<BotClientConfig>())
        {
            var client = new BotClient(cfg.Email, cfg.Password, cfg.CharacterName, cfg.GameClientPath);
            clients.Add(client);
        }

        return clients;
    }
}
