﻿using System;
using System.Collections.Generic;
using System.Windows.Forms;
using GK.WCS.Client.Station;
using CMNetLib.Robots.Crane;
using GK.WCS.DAL;
using GK.WCS.Client.Control;
using GK.WCS.Client;
using WCS.Crane;

namespace GK.WCS.Client.Control
{
    public partial class CraneAuto:BaseControl {

        public int CraneId=0;
        public List<RadioButton> rbList = new List<RadioButton>();
        public CraneAuto()
        {
            InitializeComponent();
            var values = Enum.GetValues(typeof(SemiAuto));
            List<String> list = new List<string>();
            list.Add("行走");
            list.Add("取放");
            cboxSEMI_AUTOActionType.DataSource = list;
            semiAutoPanel.Enabled = true;


        }

        public void ShowInfo(GkCraneStatus taskStatus,int craneId) {
            if(CraneId == craneId) {
                return;
            }

            this.Invoke(new Action(() => {
                this.CraneId = craneId;
                if (taskStatus.craneMode == 4)
                {
                    //lblCurrentMode.Text = "自动模式";
                    SetModeButtonState(1);
                }
                else if (taskStatus.craneMode == 2)
                {
                    //lblCurrentMode.Text = "非自动模式";
                    SetModeButtonState(0);
                }
            }));



        }

        private void SetModeButtonState(int status)
        {
            if (status == 0)
            {
                cboxSEMI_AUTOActionType.Enabled = false;
                btnExcuteSEMI_AUTO.Enabled = false;
                textBox1.Enabled = false;
                textBox2.Enabled = false;
                textBox3.Enabled = false;
            }
            else if (status == 1)
            {
                cboxSEMI_AUTOActionType.Enabled = true;
                btnExcuteSEMI_AUTO.Enabled = true;
                textBox1.Enabled = true;
                textBox2.Enabled = true;
                textBox3.Enabled = true;
            }
            else
            {
                cboxSEMI_AUTOActionType.Enabled = false;
                btnExcuteSEMI_AUTO.Enabled = false;
                textBox1.Enabled = false;
                textBox2.Enabled = false;
                textBox3.Enabled = false;
            }
        }

        public List<Pare> SourceShelve
        {
            get; set;
        }
      

        private void btnExcuteSEMI_AUTO_Click(object sender,EventArgs e) {
            String way = cboxSEMI_AUTOActionType.Text;
            int smatCodeField = 0;
            if(way == "取放") {
                smatCodeField = 1;
            }else if(way == "行走") {
                smatCodeField =4;
            } else {
                return;
            }
            int forkNo = 1;
            int taskType = smatCodeField;
            int fromPlcShelf = Convert.ToInt32(textBox1.Text);
            int fromPlcRow = Convert.ToInt32(textBox2.Text);
            int fromPlcCol = Convert.ToInt32(textBox3.Text);
            int toPlcShelf = Convert.ToInt32(textBox4.Text);
            int toPlcRow = Convert.ToInt32(textBox5.Text);
            int toPlcCol = Convert.ToInt32(textBox6.Text);

            String infod = DoSemiAutoTask(CraneId, forkNo, taskType, fromPlcShelf, fromPlcRow, fromPlcCol, toPlcShelf, toPlcRow, toPlcCol);
            info(infod);
        }

        public string DoSemiAutoTask(int CraneId, int forkNo, int taskType, int fromPlcShelf, int fromPlcRow, int fromPlcCol, int toPlcShelf, int toPlcRow, int toPlcCol)
        {
            if (HttpCraneUtil.sendTask(CraneId, forkNo, taskType, fromPlcShelf, fromPlcRow, fromPlcCol, toPlcShelf, toPlcRow, toPlcCol))
            {
                return @"自动任务发送成功";
            }
            else
            {
                return "自动任务发送失败";
            }
        }


        void updateComboBox(String key,ComboBox row,ComboBox col,ComboBox desDeep) {

            row.Items.Clear();
            String[] rowdata = CU.getRow(key,1,18);
            row.Items.AddRange(rowdata);
            row.SelectedIndex = 0;
        

            col.Items.Clear();
            col.Items.AddRange(CU.getRow(key,0,36));
            col.SelectedIndex = 0;
       
            desDeep.Items.Clear();
            desDeep.Items.AddRange(CU.getRow(key,1,12));
            desDeep.SelectedIndex = 0;
         

        }

      

        private void ShelveList_SelectedIndexChanged(object sender,EventArgs e) {
        }

        private void comboBox1_SelectedIndexChanged(object sender,EventArgs e) {

        }

        private void radioButton4_CheckedChanged(object sender,EventArgs e) {

        }

    }
}
