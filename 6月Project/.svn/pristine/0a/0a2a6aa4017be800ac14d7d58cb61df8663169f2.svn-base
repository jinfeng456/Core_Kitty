///////////主窗口--WCS控制系统主页面/////////////////
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Threading.Tasks;
using System.Threading;
using GK.WCS.Client.Device;
using GK.WCS.Client.Frm;
using HY.WCS.Client.Frm.Device;

namespace GK.WCS.Client
{
    public partial class FrmMain : Form
    {
        //public Common_User LogInPerson { get; set; }
        //private LoginInfo MLoginInfo { get; set; }
        double SysRunTickts;

        public static FrmMain main =null;
        public FrmMain()
        {
            InitializeComponent();
            main = this;
        }
        private void FrmMain_Load(object sender, EventArgs e)
        {

        }

        private void timerRefresh_Tick(object sender, EventArgs e) {
            //DateTime SysDate = DateTime.Now;         
            // tspsLabelDate.Text = "系统时间:" + SysDate.ToString("yyyy-MM-dd HH:mm");
        }
        
        public void setNetInfo(String info) {
            if(toolStripStatusLabel1.Text != info) {
                toolStripStatusLabel1.Text = info;
            }       
        }      

        private void 设备状态ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            //FrmCraneCtrl frm = new FrmCraneCtrl();
            FrmCrane frm = new FrmCrane();
            mainTab.ShowForm(frm);
        }     

        private void FrmMain_FormClosed(object sender, FormClosedEventArgs e)
        {
            try
            {
                System.Environment.Exit(System.Environment.ExitCode);
                this.Dispose();
                System.Threading.Thread.Sleep(125);
                Application.Exit();
            }
            catch { }
        }

        private void 任务列表ToolStripMenuItem_Click(object sender,EventArgs e) {
            TaskViewFrm frm = new TaskViewFrm();
            mainTab.ShowForm(frm);
        }
              

        private void 日志ToolStripMenuItem_Click(object sender,EventArgs e) {
            LogFrm frm = new LogFrm();
            mainTab.ShowForm(frm);
        }

        private void 统计ToolStripMenuItem_Click(object sender,EventArgs e) {

            StatTaskFrm frm = new StatTaskFrm();
            mainTab.ShowForm(frm);
        }

        private void 传输线2ToolStripMenuItem_Click(object sender,EventArgs e) {
            mainTab.ShowForm(new p());
        }

        private void msMain_ItemClicked(object sender,ToolStripItemClickedEventArgs e) {

        } 
    }
}