﻿using System;
using System.Linq;
using GK.WCS.Client.Station;
using System.Collections.Generic;
using CMNetLib.Robots.Crane;
using GK.WCS.Open.http.server;
using GK.WCS.DAL;
using GK.WCS.Client.Control;
using WCS.Crane;
//using GK.WCS.Client.ClientServiceReference;

namespace GK.WCS.Client.Control
{
    public partial class SingleTaskInfo :BaseControl {
        public int CraneId=0;

        public int forkNoData = 0;
        public void setForkNO(int forkNo) {
            forkNoData = forkNo;
         
        }
        public SingleTaskInfo()
        {
            InitializeComponent();
           
        }

        public void ShowInfo(GkCraneStatus taskStatus,int CraneId) {
            this.Invoke(new Action(() => {
                this.CraneId = CraneId;
                Name = "TaskInfo";
                Status.Text = taskStatus.finishTaskNo.ToString();
                taskNo.Text = taskStatus.finishTaskNo.ToString();
               
            }));

        }

        private void btnTaskClear_Click(object sender,EventArgs e) {
            //GkDYGCraneStatus carrierData = HttpCraneUtil.loadData(CraneId);
            //if (taskCheck(carrierData))
            //{

            //    if (!HttpCraneUtil.ClearTaskState(CraneId, forkNoData))
            //    {
            //        info(@"任务清除失败，请检查网络连接");
            //    }
            //    else
            //    {
            //        //TaskStatusModel taskStatus = carrierData.taskState[0];
            //        ITaskCraneServer taskCraneServer = ServerFactray.getServer<ITaskCraneServer>();
            //        //taskCraneServer.UpdateTaskStatus(taskStatus.TaskNo,1,forkNoData);
            //        info(@"任务清除成功");
            //    }
            //}
            HttpCraneUtil.ClearCraneTask(CraneId);
        }


        bool taskCheck(GkCraneStatus carrierData) {
            if(carrierData == null) {
                info("当前堆垛机不在线！");
                return false;
            }
            //List<TaskStatusModel> status = carrierData.taskState;

            //if( status.Count() == 0) {
            //    info("当前垛机无任务！");
            //    return false;
            //}

            //TaskStatusModel taskStatus = status[forkNoData-1];
            
            //if(taskStatus.State ==TaskStatus.UNLOADED) {
            //    error(@"当前选择的任务已完成");
            //    return false;
            //}


            if(HttpCraneUtil.IsAutoRunning(CraneId)) {
                info(@"当前堆垛机处于正常自动允许状态");
                return false;
            }

            if(!warning("确认修改任务状态?")) {
                return false;
            }

            return true;
        }

      
    }
}
