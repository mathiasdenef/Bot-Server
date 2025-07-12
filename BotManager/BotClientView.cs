using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BotManager;
public class BotClientView
{
    public bool IsSelected { get; set; }
    public string CharacterName { get; set; }
    public string State { get; set; }
    public bool Connected { get; set; }
    [Browsable(false)]
    public BotClient Source { get; set; }
}
