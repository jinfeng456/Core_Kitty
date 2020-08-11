using GK.Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WCS.Entity
{
    [Serializable]
    public class TaskComplete : BaseEntity
    {
        public TaskComplete() { }

        public long wmsTaskId
        {
            get; set;
        }

        public string boxCode
        {
            get; set;
        }
        public int taskType
        {
            get; set;
        }

        public int src
        {
            get; set;
        }
        public int des {
            get; set;
        }
        /*
         * 1待分解 2执行中 3不可插入 4执行完成 5上报完成
         * */
        public int status
        {
            get; set;
        }

        public int Priority
        {
            get; set;
        }

        public string info
        {
            get; set;
        }

        public long relyTaskId
        {
            get; set;
        }

        public int upload
        {
            get;set;
        }


        public DateTime createTime
        {
            get; set;
        }

        public DateTime finshTime
        {
            get; set;
        }
    }
}
