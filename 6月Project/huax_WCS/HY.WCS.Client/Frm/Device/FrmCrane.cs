using CMFrameWork.Common;
using CMNetLib.Robots.Crane;
using GK.WCS.Client.Station;
using HY.WCS.Client.Station;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using WCS.Crane;

namespace HY.WCS.Client.Frm.Device
{
    public partial class FrmCrane : Form
    {
        private int CraneId = 1;
        string idle = "点击恢复执行";
        string working = "点击循环停止";
        public FrmCrane()
        {
            InitializeComponent();
            List<String> list = new List<string>();
            list.Add("行走");
            list.Add("取放");
            ComTaskType.DataSource = list;
        }
        private void FrmCrane_Load(object sender, EventArgs e)
        {
            init();
        }
        protected override CreateParams CreateParams
        {
            get
            {
                CreateParams paras = base.CreateParams;
                paras.ExStyle |= 0x02000000;
                return paras;
            }
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            try
            {
                GkCraneStatus craneData = HttpCraneUtil.loadData(CraneId);
                if (craneData == null)
                {
                    return;
                }
                List<string> list = HttpCraneUtil.GetErrorList(CraneId);
                ShowInfo(craneData, CraneId);
                ShowStatus(craneData);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void ShowStatus(GkCraneStatus craneData)
        {
            if (craneData.craneState == 1)
            {
                LabMsg1.Text = "堆垛机状态：" + "启动";
            }
            else if (craneData.craneState == 2)
            {
                LabMsg1.Text = "堆垛机状态：" + "停止";
            }
            else if (craneData.craneState == 3)
            {
                LabMsg1.Text = "堆垛机状态：" + "急停";
            }

            if (craneData.craneMode == 1)
            {
                LabMsg2.Text = "堆垛机模式：" + "维修";
            }
            else if (craneData.craneMode == 2)
            {
                LabMsg2.Text = "堆垛机模式：" + "手动";
            }
            else if (craneData.craneMode == 3)
            {
                LabMsg2.Text = "堆垛机模式：" + "半自动";
            }
            else if (craneData.craneMode == 4)
            {
                LabMsg2.Text = "堆垛机模式：" + "自动";
            }
            else if (craneData.craneMode == 5)
            {
                LabMsg2.Text = "堆垛机模式：" + "联机";
            }
            craneData.GkCraneError();
            List<String> list = craneData.getError();

            list.Add("");
            list.Add("");
            list.Add("");
            list.Add("");
            errorshow(list);
        }

        private void errorshow(List<string> list)
        {
            LabMsg3.Text = list[0].ToString();
            LabMsg4.Text = list[1].ToString();
            LabMsg5.Text = list[2].ToString();
            LabMsg6.Text = list[3].ToString();
        }

        private void ShowInfo(GkCraneStatus craneData, int craneId)
        {
            TxtTaskNo.Text = craneData.finishTaskNo.ToString();
            TxtTaskStatus.Text = craneData.finishFlag.ToString();
        }

        private void LabCrane1_Click(object sender, EventArgs e)
        {
            Label label = (Label)sender;
            CraneId = label.Tag.ToInt32();
        }

        private void LabExecute_Click(object sender, EventArgs e)
        {
            if (CheckIsNull())
            {
                int smatCodeField = 0;
                if (ComTaskType.Text == "取放")
                {
                    smatCodeField = 1;
                }
                else if (ComTaskType.Text == "行走")
                {
                    smatCodeField = 4;
                }
                else
                {
                    return;
                }
                int forkNo = 1;
                int taskType = smatCodeField;
                int fromPlcShelf = Convert.ToInt32(TxtStartPai.Text);
                int fromPlcRow = Convert.ToInt32(TxtStartLie.Text);
                int fromPlcCol = Convert.ToInt32(TxtStartCeng.Text);
                int toPlcShelf = Convert.ToInt32(TxtEndPai.Text);
                int toPlcRow = Convert.ToInt32(TxtEndLie.Text);
                int toPlcCol = Convert.ToInt32(TxtEndCeng.Text);
                String infod = DoSemiAutoTask(CraneId, forkNo, taskType, fromPlcShelf, fromPlcRow, fromPlcCol, toPlcShelf, toPlcRow, toPlcCol);
            }
            else
            {
                MessageBox.Show("起点终点排列层信息不能为空！");
            }
        }

        private bool CheckIsNull()
        {
            if (string.IsNullOrEmpty(TxtStartPai.Text.Trim()))
            {
                return false;
            }
            if (string.IsNullOrEmpty(TxtStartLie.Text.Trim()))
            {
                return false;
            }
            if (string.IsNullOrEmpty(TxtStartCeng.Text.Trim()))
            {
                return false;
            }
            if (string.IsNullOrEmpty(TxtEndPai.Text.Trim()))
            {
                return false;
            }
            if (string.IsNullOrEmpty(TxtEndLie.Text.Trim()))
            {
                return false;
            }
            if (string.IsNullOrEmpty(TxtEndCeng.Text.Trim()))
            {
                return false;
            }
            return true;
        }

        private string DoSemiAutoTask(int craneId, int forkNo, int taskType, int fromPlcShelf, int fromPlcRow, int fromPlcCol, int toPlcShelf, int toPlcRow, int toPlcCol)
        {
            if (HttpCraneUtil.sendTask(CraneId, forkNo, taskType, fromPlcShelf, fromPlcRow, fromPlcCol, toPlcShelf, toPlcRow, toPlcCol))
            {
                return @"自动任务发送成功";
            }
            else
            {
                return @"自动任务发送失败";
            }
        }



        private void LabAuto_Click(object sender, EventArgs e)
        {
            var ctrl = sender as Label;
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
            bool result = HttpMechineStatusUtil.Update(CraneId, model);
            string success = string.Empty;
            var info = string.Format("{1}号堆垛机切换成{2}{0}", result ? "成功" : "失败", CraneId, success);
            MessageUtil.warning(info);
        }

        private void LabClearAlarm_Click(object sender, EventArgs e)
        {
            bool result = HttpCraneUtil.ClearCraneFault(CraneId);
            if (result)
            {
                MessageBox.Show("解警成功！");
            }
            else
            {
                MessageBox.Show("解警失败！");
            }
        }

        private void LabChange_Click(object sender, EventArgs e)
        {
            if (working == LabChange.Text)
            {
                bool updateOverStop = HttpMechineStatusUtil.UpdateCraneOverStop(CraneId, 1);
            }
            else
            {
                bool updateOverStop = HttpMechineStatusUtil.UpdateCraneOverStop(CraneId, 0);
            }
            init();
        }

        private void init()
        {
            int craneStop = HttpMechineStatusUtil.GetCraneOverStop(CraneId);
            int autoOrNot = HttpMechineStatusUtil.GetCraneRunStatus(CraneId);
            changeCraneButton(craneStop, autoOrNot);
        }

        private void changeCraneButton(int craneStop, int autoOrNot)
        {
            this.Invoke(new Action(() =>
            {
                if (craneStop == 1)
                {
                    LabChange.Text = idle;
                }
                else if (craneStop == 0)
                {
                    LabChange.Text = working;
                }
                if (autoOrNot == 2)
                {
                    LabManual.Enabled = false;
                }
                else if (autoOrNot == 3)
                {
                    LabAuto.Enabled = false;
                }
            }));
        }

        private void LabStop_Click(object sender, EventArgs e)
        {
            bool result = HttpCraneUtil.EmergencyStop(CraneId, RobotMode.SEMI_AUTO);
        }

        private void LabDeleteTask_Click(object sender, EventArgs e)
        {
            bool result = HttpCraneUtil.ClearCraneTask(CraneId);
        }

        private void LabAllStop_Click(object sender, EventArgs e)
        {
            for (int craneId = 1; craneId < 12; craneId++)
            {
                bool result = HttpCraneUtil.EmergencyStop(craneId, RobotMode.SEMI_AUTO);
            }
        }

        private void LabCrane1_MouseUp(object sender, MouseEventArgs e)
        {
            Label panel = (Label)sender;
            panel.BorderStyle = System.Windows.Forms.BorderStyle.None;
        }

        private void LabCrane1_MouseDown(object sender, MouseEventArgs e)
        {
            Label panel = (Label)sender;
            panel.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
        }

        private void label13_Click(object sender, EventArgs e)
        {
            var ctrl = sender as Label;
            if (ctrl == null)
                return;
            var tag = Convert.ToInt32(ctrl.Tag);
            HttpDeviceInOrNotUtil.UpdateInOrNot(CraneId,tag);
        }

        private void label18_Click(object sender, EventArgs e)
        {
            var ctrl = sender as Label;
            if (ctrl == null)
                return;
            var tag = Convert.ToInt32(ctrl.Tag);
            HttpDeviceInOrNotUtil.UpdateInOrNot(CraneId, tag);
        }
    }
}
