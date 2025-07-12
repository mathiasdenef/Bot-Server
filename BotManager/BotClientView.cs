using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Windows.Forms.AxHost;

namespace BotManager;
public class BotClientView : INotifyPropertyChanged
{
    public bool IsSelected { get; set; }
    public string CharacterName { get; set; }
    private BotClientState _state;
    public BotClientState State
    {
        get => _state;
        set
        {
            if (_state != value)
            {
                _state = value;
                OnPropertyChanged(nameof(State));
            }
        }
    }
    [Browsable(false)]
    public BotClient Source { get; set; }

    public event PropertyChangedEventHandler? PropertyChanged;

    protected void OnPropertyChanged(string propertyName)
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }
}

public enum BotClientState
{
    Unknown,
    Idle,
    WaitCharacterSelect,
    EnterQuest,
    RunQuest,
    ResetQuest,
    HardReset,
    BuyEctos,
    Trade,
    Disconnected,
    Pause,
    Error
}
