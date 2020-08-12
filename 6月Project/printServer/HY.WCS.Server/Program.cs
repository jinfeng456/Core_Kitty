using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Windows.Forms;

namespace GK.WCS.Server
{
    static class Program
    {
        /// <summary>
        /// 应用程序的主入口点。
        /// </summary>
        [STAThread]
        static void Main()
        {
            if(IsRunning()) {
                return;
            }
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new FrmServer());
       
        }



        public static bool IsRunning() {
            Process current = default(Process);
            current = System.Diagnostics.Process.GetCurrentProcess();
            Process[] processes = null;
            processes = System.Diagnostics.Process.GetProcessesByName(current.ProcessName);

            Process process = default(Process);

            foreach(Process tempLoopVar_process in processes) {
                process = tempLoopVar_process;

                if(process.Id != current.Id) {
                    if(System.Reflection.Assembly.GetExecutingAssembly().Location.Replace("/","\\") == current.MainModule.FileName) {
                        return true;

                    }

                }
            }
            return false;

        }

    }
}
