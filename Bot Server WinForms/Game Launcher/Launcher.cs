using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;



namespace Bot_Server_WinForms.Game_Launcher
{



    static class Launcher
    {
        [DllImport("user32.dll")]
        private static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
        public const int SC_MINIMIZE = 6;

        [DllImport("USER32.DLL")]
        public static extern bool SetForegroundWindow(IntPtr hWnd);
        public static bool LaunchGame(string gwPath, string gwArgs)
        {
  
            //check if the install exists
            if (!File.Exists(gwPath))
            {
                MessageBox.Show("The path: " + gwPath + " does not exist!");
                return false;

            }
            else
            {
                bool forced = false;
                //bool forced = forceUnlockCheckBox.CheckBoxControl.Checked;
                if (forced)
                {
                    HandleManager.ClearDatLock(Directory.GetParent(gwPath).FullName);
                }

                //attempt to launch
                var started = LaunchGame(gwPath, gwArgs, forced);
                if (started)
                {
                    //give time for gw to read path before it gets changed again.
                    System.Threading.Thread.Sleep(Program.settings.RegistryCooldown);
                }
                return started;
            }
        }
        public static bool LaunchGame(string gwPath, string args, bool forced)
        {
            bool success = false;

            if (!forced)
            {
                //check to see if this copy is already started
                if (IsCopyRunning(gwPath))
                {
                    MessageBox.Show(gwPath + " is already running, please launch a different copy.",
                        Program.ERROR_CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return success;
                }
            }

            do
            {
                Process gw = new Process();
                gw.StartInfo.FileName = gwPath;
                gw.StartInfo.Arguments = args;
                gw.StartInfo.WorkingDirectory = Directory.GetParent(gwPath).FullName;
                gw.StartInfo.UseShellExecute = true;
                gw.StartInfo.WindowStyle = ProcessWindowStyle.Minimized;

                try
                {
                    //set new gw path
                    RegistryManager.SetGWRegPath(gwPath);

                    //clear mutex to allow for another gw launch
                    HandleManager.ClearMutex();

                    //attempt to start gw process
                    gw.Start();
                    Thread.Sleep(10000);
                    success = true;
                }
                catch (Exception e)
                {
                    success = false;
                    gw.Kill();
                    Thread.Sleep(3000);
                    //MessageBox.Show("Error launching: " + gwPath + "!\n" + e.Message,
                    //    Program.ERROR_CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
            while (!success);

            return success;
        }
        public static bool IsCopyRunning(string gwPath)
        {
            //get list of currently running system processes
            List<Process> processList = Process.GetProcesses().Where(x => x.ProcessName.Equals(Program.GW_PROCESS_NAME, StringComparison.OrdinalIgnoreCase)).ToList();

            foreach (Process i in processList)
            {
                try
                {
                    string processPath = i.MainModule.FileName;

                    //does filename match?
                    if (processPath.Equals(gwPath, StringComparison.OrdinalIgnoreCase))
                    {
                        return true;
                    }
                }
                catch (Exception)
                {
                    //Exception is caught if gw.exe is in the process of closing itself
                }
            }

            return false;
        }
    }
}
