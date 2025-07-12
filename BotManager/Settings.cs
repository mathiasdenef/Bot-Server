using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace BotManager
{
    public sealed class Settings
    {
        public string sourceClientListFileLocation;
        public string scriptFileLocation;
        public string multiLauncherFileLocation;
        public string autoLaunchFileLocation;
        public string settingsFileLocation = Environment.CurrentDirectory.ToString() + "\\guildwarsSettingsFile.txt";

        public static Settings settings { get; } = new Settings();

        private Settings() { }

        public static void Initalize() {
            SearchDesktopForSettingsFile();
        }

        public static void SetSourceListFileLocation(string location) {
            settings.sourceClientListFileLocation = location;
            BotManagerForm.form.textBoxSelectedSourceAccounts.Text = settings.sourceClientListFileLocation;
            Settings.writeToSettingsFile();
        }
        public static void SetMultiLauncherFileLocation(string location)
        {
            settings.multiLauncherFileLocation = location;
            BotManagerForm.form.textBoxSelectedMultiLauncher.Text = settings.multiLauncherFileLocation;
            Settings.writeToSettingsFile();
        }
        public static void SetScriptFileLocation(string location)
        {
            settings.scriptFileLocation = location;
            BotManagerForm.form.textBoxSelectedScript.Text = settings.scriptFileLocation;
            Settings.writeToSettingsFile();
        }
        public static void SetAutoLaunchFileLocation(string location)
        {
            settings.autoLaunchFileLocation = location;
            BotManagerForm.form.textBoxSelectedAutoLaunch.Text = settings.autoLaunchFileLocation;
            Settings.writeToSettingsFile();
        }
        public static string GetSourceListFileLocation()
        {
            return settings.sourceClientListFileLocation.ToString();
        }
        public static string GetScriptFileLocation()
        {
            return settings.scriptFileLocation.ToString();
        }
        public static string GetMultiLauncherFileLocation()
        {
            return settings.multiLauncherFileLocation.ToString();
        }
        public static string GetAutoLaunchFileLocation()
        {
            return settings.autoLaunchFileLocation.ToString();
        }
        public static void writeToSettingsFile()
        {
            // Create a string array that consists of three lines.
            string sourceAccounts = "Source Accounts = " + settings.sourceClientListFileLocation;
            string script = "Script = " + settings.scriptFileLocation;
            string multiLauncher = "Multi Launcher = " + settings.multiLauncherFileLocation;
            string autoLaunch = "Auto Launch = " + settings.autoLaunchFileLocation;
            string[] lines = { sourceAccounts, script, multiLauncher, autoLaunch };

            System.IO.File.WriteAllLines(settings.settingsFileLocation, lines);
        }

        public static void SearchDesktopForSettingsFile()
        {
            string line;
            // Read the file and display it line by line.  
            if (File.Exists(settings.settingsFileLocation))
            {
                System.IO.StreamReader file =
                    new System.IO.StreamReader(settings.settingsFileLocation);
                if (file != null)
                {
                    while ((line = file.ReadLine()) != null)
                    {
                        var splittedLine = line.Split('=');
                        var settingsType = splittedLine[0].Trim();
                        var fileLocation = splittedLine[1].Trim();
                        switch (settingsType)
                        {
                            case "Source Accounts":
                                settings.sourceClientListFileLocation = fileLocation;
                                BotManagerForm.form.textBoxSelectedSourceAccounts.Text = settings.sourceClientListFileLocation;
                                break;

                            case "Multi Launcher":
                                settings.multiLauncherFileLocation = fileLocation;
                                BotManagerForm.form.textBoxSelectedMultiLauncher.Text = settings.multiLauncherFileLocation;
                                break;

                            case "Script":
                                settings.scriptFileLocation = fileLocation;
                                BotManagerForm.form.textBoxSelectedScript.Text = settings.scriptFileLocation;
                                break;

                            case "Auto Launch":
                                settings.autoLaunchFileLocation = fileLocation;
                                BotManagerForm.form.textBoxSelectedAutoLaunch.Text = settings.autoLaunchFileLocation;
                                break;

                        }
                    }
                }
                file.Close();
            }
        }
    }
}
