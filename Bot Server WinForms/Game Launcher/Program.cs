using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bot_Server_WinForms.Game_Launcher
{
    static class Program
    {
        public const string MUTEX_MATCH_STRING = "AN-Mute";
        public const string DEFAULT_ARGUMENT = "-windowed";
        public const string ERROR_CAPTION = "GWMultiLaunch Error";

        public const string SHORTCUT_PREFIX = "Guild Wars ML-";
        public const string AUTO_LAUNCH_SHORTCUT = "Guild Wars ML-X";
        public const string AUTO_LAUNCH_SWITCH = "-auto";

        public const string GW_PROCESS_NAME = "Gw";
        public const string GW_FILENAME = "Gw.exe";
        public const string GW_DAT = "Gw.dat";
        public const string GW_REG_LOCATION = "SOFTWARE\\ArenaNet\\Guild Wars";
        public const string GW_REG_LOCATION_AUX = "SOFTWARE\\Wow6432Node\\ArenaNet\\Guild Wars";
        public const string GW_TEMPLATES = "\\Templates";
        public const string TM_FILENAME = "texmod.exe";

        public static SettingsManager settings = new SettingsManager();
    }
}
