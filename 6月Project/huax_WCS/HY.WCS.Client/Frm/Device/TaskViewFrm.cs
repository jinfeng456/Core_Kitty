﻿using System;
using System.Windows.Forms;
using CMFrameWork.Common;
using System.Collections.Generic;
using GK.WCS.DAL;
using GK.WCS.Carrier;
using GK.WCS.Client.Station;
using WCS.Entity;
using WCS.Common;

namespace GK.WCS.Client.Device {
    public partial class TaskViewFrm: Form
    {
        //TaskCraneDAL ctDal = new TaskCraneDAL();
        //TaskCarrierDAL carrierDal = new TaskCarrierDAL();
        //TaskHumentDAL robotDal = new TaskHumentDAL();

        //ITaskCraneServer ctDal = ServerFactray.getServer<ITaskCraneServer>();
        // ITaskCarrierServer carrierDal = ServerFactray.getServer<ITaskCarrierServer>();
        List<Label> lableList = new List<Label>();
        public TaskViewFrm()
        {
            InitializeComponent();
            dataGridViewComplete.AutoGenerateColumns = false;
            dataGridViewCarrier.AutoGenerateColumns = false;
            //冻结某列 从左开始 0，1，2
            dataGridViewComplete.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            //dataGridViewCarrier.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            dataGridViewCarrier.Columns[5].AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill;
         
            lableList.Add(label6);
            lableList.Add(label7);
            lableList.Add(label8);
            lableList.Add(label9);
        }

        //complete 相关
        private void StockInfoFrm_Load(object sender, EventArgs e)
        {
            List<TaskComplete> list= HttpTaskUtil.getComplete();
            dataGridViewComplete.DataSource = list;
            if (list.Count==0)
            {
                dataGridViewCarrier.DataSource = null; 
            }
            //loadSubTask();           
        }

        void InidataGridViewComplete()
        {
            dataGridViewComplete.DataSource = HttpTaskUtil.getComplete();
        }


        private void dataGridViewComplete_CellFormatting(object sender,DataGridViewCellFormattingEventArgs e) {
            
            DataGridView grid = (DataGridView)sender;
            int column = e.ColumnIndex;
            String name = grid.Columns[column].DataPropertyName;
            object value = e.Value;
            e.Value = change("complete",name,value);
        }

        long selectcomplateId = 0;
        private void dataGridViewComplete_CellContentClick(object sender,DataGridViewCellEventArgs e) {
            DataGridView view = (DataGridView)sender;
            if(e.RowIndex < 0) {
                return;
            }
            DataGridViewRow row = view.Rows[e.RowIndex];
            selectcomplateId = row.Cells[0].Value.ToString().ToInt64();
            loadSubTask();
        }
        private void txButton1_Click(object sender,EventArgs e) {
            if(selectcomplateId > 0) {
               // ctDal.UpdateTaskPriorityByCompleteId(selectcomplateId,4);
               bool updateTaskPriority = HttpTaskUtil.UpdateTaskPriorityByCompleteId(selectcomplateId);
                InidataGridViewComplete();
            } else {
                MessageBox.Show("请选择一条记录","警告",MessageBoxButtons.OK,MessageBoxIcon.Warning);
            }

        }
        private void deleteComplete_Click(object sender,EventArgs e) {
            if (selectcomplateId > 0)
            {

                var res = MessageBox.Show("确定要删除该任务？", "警告", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
                if (res == DialogResult.Yes)
                {
                    bool deleteTask = HttpCraneUtil.DeleteCraneAndCarrierTask(selectcomplateId);
                    loadSubTask();
                }
            }
            else
            {
                MessageBox.Show("请选择一条记录", "警告", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }



        private void dataGridViewRGV_CellFormatting(object sender,DataGridViewCellFormattingEventArgs e) {
            //DataGridView grid = (DataGridView)sender;
            //int column = e.ColumnIndex;
            //String name = grid.Columns[column].Name ;
            //String type = grid.Rows[e.RowIndex].Cells[1].Value.ToString();
            //e.Value = change(type,name,e.Value);
        }
        
      
        long subTaskId = 0;
        int  _deviceType = 0;
        private void dataGridViewCarrer_CellContentClick(object sender,DataGridViewCellEventArgs e) {
            DataGridView view = (DataGridView)sender;
            if(e.RowIndex < 0) {
                return;
            }
            DataGridViewRow row = view.Rows[e.RowIndex];
            subTaskId = row.Cells[0].Value.ToString().ToInt64();
            _deviceType = row.Cells[1].Value.ToString().ToInt32();

            List<BaseTask> res = (List<BaseTask>)view.DataSource;
            BaseTask bt = res[e.RowIndex];
            List<String> data = null;// bt.getLableData();

            //for (int i = 0; i < lableList.Count; i++)
            //{
            //    if (i >= data.Count)
            //    {
            //        lableList[i].Text = "";
            //    }
            //    else
            //    {
            //        lableList[i].Text = data[i];
            //    }

            //}
            
        }



        
        
        void loadSubTask() {
            subTaskId = 0;
            List<TaskCrane> craneList = HttpCraneUtil.getTaskCraneBycompleteId(selectcomplateId);
            List<TaskCarrier> carrierList = HttpCarrierUtil.getCarrierTaskByCompleteId(selectcomplateId);
            // List<TaskHumen> robotList = robotDal.getRobotTasks(selectcomplateId);             
            //res = TaskUtil.margin(TaskUtil.margin(craneList, carrierList), robotList);
            List<BaseTask> res= TaskUtil.margin(craneList, carrierList);
            dataGridViewCarrier.DataSource = res;
        }

     

        private void csxRest_Click(object sender,EventArgs e) {
            if(subTaskId == 0) {
                MessageBox.Show("请选择一条记录","警告",MessageBoxButtons.OK,MessageBoxIcon.Warning);
                return;
            }
            var res = MessageBox.Show("可以再次执行该任务？","警告",MessageBoxButtons.YesNo,MessageBoxIcon.Warning);
            if(res != DialogResult.Yes) {
                return;
            }
            //堆垛机1 输送线2
            if(_deviceType == 1) {
                //  ctDal.resetTaskStatus(subTaskId);
                bool resetCraneTask = HttpCraneUtil.ResetCraneTaskById(subTaskId);
            } else if(_deviceType == 2) {
               // robotDal.update(subTaskId,1);
               bool resetCarrierTask = HttpCarrierUtil.ResetCarrierTaskById(subTaskId);
            } /*else if(selectClassType == "humen") {*/
            //   // carrierDal.UpdateTaskCarrierStatus(subTaskId,1);
            //}  
        
            loadSubTask();
        }

        private void csxfinsh_Click(object sender,EventArgs e) {
            if(subTaskId == 0) {
                MessageBox.Show("请选择一条记录","警告",MessageBoxButtons.OK,MessageBoxIcon.Warning);
                return;
            }
            var res = MessageBox.Show("确定任务已完成？","警告",MessageBoxButtons.YesNo,MessageBoxIcon.Warning);
            if(res != DialogResult.Yes) {
                return;
            }
            if(_deviceType == 1) {
                //ctDal.finshTaskStatus(subTaskId);
                bool finishCraneTask = HttpCraneUtil.FinishCraneTaskById(subTaskId);
            } else if(_deviceType == 2) {
                // robotDal.update(subTaskId,3);
                bool finishCarrierTask = HttpCarrierUtil.FinishCarrierTaskById(subTaskId);
            }
            //} else if(selectClassType == "carrier") {
            //   // carrierDal.finshTaskCarrier(subTaskId);
            //}
            loadSubTask();
        }
        

      





        static Dictionary<String,String> myDictionary = new Dictionary<String,String>();

        static TaskViewFrm() {
            myDictionary.Add("humen.status.1","待执行");
            myDictionary.Add("humen.status.2","执行中");
            myDictionary.Add("humen.status.3","完成");

            myDictionary.Add("crane.motiontype.-1","删除");
            myDictionary.Add("crane.motiontype.1","取货");
            myDictionary.Add("crane.motiontype.2","放货");
            myDictionary.Add("crane.status.1","待执行");
            myDictionary.Add("crane.status.2","取货行走");
            myDictionary.Add("crane.status.3","取货中");
            myDictionary.Add("crane.status.4","取货结束");
            myDictionary.Add("crane.status.5","放货行走");
            myDictionary.Add("crane.status.6","放货中");
            myDictionary.Add("crane.status.7","完成");
            myDictionary.Add("crane.status.8","运行");
            myDictionary.Add("crane.status.9","自动完成");
            myDictionary.Add("crane.status.255","未知状态");

            myDictionary.Add("carrier.status.1","待执行");
            myDictionary.Add("carrier.status.2","执行中");
            myDictionary.Add("carrier.status.3","完成");

            myDictionary.Add("complete.status.1","待执行");
            myDictionary.Add("complete.status.2","执行中");
            myDictionary.Add("complete.status.3","完成");
            myDictionary.Add("complete.type.1","入库");
            myDictionary.Add("complete.type.2","出库");
            myDictionary.Add("complete.type.3","移库");
            myDictionary.Add("complete.type.4","盘库");

            myDictionary.Add("crane.classtypedisplay.crane","垛机");
            myDictionary.Add("humen.classtypedisplay.humen","人工");
            myDictionary.Add("carrier.classtypedisplay.carrier","传输线");

        }

       
        private static String change(String type,String name,object value) {
            if(value == null) {
                return "";
            }
            if(value.GetType() == typeof(DateTime)) {
                if(((DateTime)value).Ticks == 0) {
                    return "";
                }
                return Tools.seconds2DateSring(value);
            }
            String key = type + "." + name.ToLower() + "." + value.ToString();
            if(myDictionary.ContainsKey(key)) {
                return myDictionary[key];
            } else {
                return value.ToString();
            }
        }
    }
}