using GK.Common.Entity;
using System;


namespace GK.WMS.Entity

{

    /// <summary>
    /// 货架
    /// </summary>
    public class CoreTask : BaseEntity
    {
        public long stockId
        {
            get; set;
        }

        public long areaId
        {
            get; set;
        }
        public string boxCode
        {
            get; set;
        }
        public int status
        {
            get; set;
        }
        public int taskType
        {
            get; set;
        }

        public DateTime createTime
        {
            get; set;
        }
        public DateTime? finshTime
        {
            get; set;
        }
        public long relyTaskId
        {
            get; set;
        }
        public int maxstock
        {
            get; set;
        }

        public string info
        {
            get; set;
        }
        public int bussType
        {
            get; set;
        }
        public int Priority
        {
            get; set;
        }
        public int src
        {
            get; set;
        }
        public int des
        {
            get; set;
        }
        public int upload
        {
            get; set;
        }

    }
}