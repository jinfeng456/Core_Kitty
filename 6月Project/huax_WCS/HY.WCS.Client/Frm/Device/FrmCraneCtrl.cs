using CMFrameWork.Common;
using CMNetLib.Robots.Crane;
using GK.WCS.Client.Station;
using GK.WCS.Crane;
using GK.WCS.DAL;
using GK.WCS.Entity;
using HY.WCS.Client.Station;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Threading;
using System.Windows.Forms;

namespace GK.WCS.Client.Device
{
    public partial class FrmCraneCtrl : Form
    {
        private int cId = 1;
        IMechineStatusServer rTConfigServer = ServerFactray.getServer<IMechineStatusServer>();
        public FrmCraneCtrl()
        {
            InitializeComponent();
            TaskInfo2.setForkNO(1);
          
        }

        private void FrmCraneCtrl_Load(object sender, EventArgs e)
        {
            cId = 1;
            init();
        }

        private void radioButton1_CheckedChanged(object sender, EventArgs e)
        {
            RadioButton rb = (RadioButton)sender;
            cId = rb.Tag.ToInt32();
        }


        private void ChangeMode_Click(object sender, EventArgs e)
        {
            var ctrl = sender as Button;
            if (ctrl == null)
                return;
            var tag = ctrl.Tag.ToString();
            if (string.IsNullOrEmpty(tag))
            {
                return;
            }

            int model;
            if (!int.TryParse(tag, out model))
                return;
            if (MessageBox.Show("确认切换模式到" + ctrl.Text, "提示", MessageBoxButtons.OKCancel, MessageBoxIcon.Question) != DialogResult.OK)
            {
                return;
            }
            bool result = HttpMechineStatusUtil.Update(cId, model);
            string success = string.Empty;
            var info = string.Format("{1}号堆垛机切换成{2}{0}", result ? "成功" : "失败", cId, success);
            MessageUtil.warning(info);
        }
        private void timerRefresh_Tick(object sender, EventArgs e)
        {
            try
            {
                lblCraneName.Text = cId + @"号堆垛机";
                GkDYGCraneStatus craneData = HttpCraneUtil.loadData(cId);
                List<string> list = HttpCraneUtil.GetErrorList(cId);
                this.Invoke(new Action(() =>
                {
                    try
                    {
                        SetUiValue(craneData);
                    }
                    catch { }
                }));
                if (craneData == null)
                {
                    return;
                }
                TaskInfo2.ShowInfo(craneData, cId);
                craneAuto1.ShowInfo(craneData, cId);
            }
            catch(Exception ex)
            {

            }
            Thread.Sleep(300);
        }





        private void SetUiValue(GkDYGCraneStatus craneData)
        {
            if (craneData==null)
            {
                SetModeButtonState(2);
            }
            else
            {
                if (craneData.craneMode == 1)
                {
                    lblCurrentMode.Text = "自动模式";
                    SetModeButtonState(1);
                }
                else if (craneData.craneMode == 0)
                {
                    lblCurrentMode.Text = "非自动模式";
                    SetModeButtonState(0);
                }
                if (craneData.isfault())
                {
                    button2.Visible = true;
                }
                else
                {
                    button2.Visible = false;
                }
            }
        }


            //0非自动
            //1自动
            private void SetModeButtonState(int status){
            if (status == 0)
            {              
                btnSemiAuto.Visible = false;
                autoButton1.Visible = false;
                craneAuto1.Enabled = true;              
            }
            else if (status == 1)
            {                            
                btnSemiAuto.Visible = true;
                autoButton1.Visible = true;
                craneAuto1.Enabled = true;
            }
            else if(status == 2)
            {
                btnSemiAuto.Visible = false;
                autoButton1.Visible = false;
                craneAuto1.Enabled = true;
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            HttpCraneUtil.EmergencyStop(1, RobotMode.SEMI_AUTO);
        }

        private void button4_Click(object sender, EventArgs e)
        {
            HttpCraneUtil.EmergencyStop(2, RobotMode.SEMI_AUTO);
        }

        private void button3_Click(object sender, EventArgs e)
        {
            HttpCraneUtil.EmergencyStop(3, RobotMode.SEMI_AUTO);
        }

        private void button2_Click(object sender, EventArgs e)
        {
            HttpCraneUtil.EmergencyStop(4, RobotMode.SEMI_AUTO);
        }

        private void FrmCraneCtrl_Paint(object sender, PaintEventArgs e)
        {
            this.timerRefresh.Enabled = true;
        }
        string idle = "点击恢复执行";
        string working = "点击循环停止";
        private void btnCrane1stop_Click(object sender, EventArgs e)
        {
         
            if (working == btnCrane1stop.Text)
            {
                bool updateOverStop = HttpMechineStatusUtil.UpdateCraneOverStop(1,1);
            }
            else
            {               
                bool updateOverStop = HttpMechineStatusUtil.UpdateCraneOverStop(1, 0);
            }
            init();
        }
        private void init()
        {         
            int crane1Stop = HttpMechineStatusUtil.GetCraneOverStop(1);
            int autoOrNot = HttpMechineStatusUtil.GetCraneRunStatus(1); 
            changeCraneButton(crane1Stop, autoOrNot,btnCrane1stop, btnSemiAuto);
            int crane2Stop = HttpMechineStatusUtil.GetCraneOverStop(2);
            int auto2OrNot = HttpMechineStatusUtil.GetCraneRunStatus(2);
            changeCraneButton(crane2Stop, auto2OrNot,btnCrane2stop, autoButton1);
        }
        void changeCraneButton(int craneStop, int autoOrNot, Button btnCrane,Button auto)
        {
            this.Invoke(new Action(() =>
            {
                if (craneStop == 1)
                {
                    btnCrane.Text = idle;
                }
                else if(craneStop == 0)
                {
                    btnCrane.Text = working;
                }
                if (autoOrNot==2)
                {
                    auto.Enabled = false;
                }
                else if (autoOrNot==3)
                {
                    auto.Enabled = false;
                }
            }));
        }

        private void btnCrane2stop_Click(object sender, EventArgs e)
        {
            if (working == btnCrane2stop.Text)
            {
                bool updateOverStop = HttpMechineStatusUtil.UpdateCraneOverStop(2, 1);
            }
            else
            {
                bool updateOverStop = HttpMechineStatusUtil.UpdateCraneOverStop(2, 0);
            }
            init();
        }

        private void button2_Click_1(object sender, EventArgs e)
        {
            bool result = HttpCraneUtil.ClearCraneFault(cId);
        }

        private void craneAuto1_Load(object sender, EventArgs e)
        {

        }
    }
}
