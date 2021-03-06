﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GK.WMS.Entity
{
    public class CoreStockParam
    {
        public long whId { get; set; }

        public long classifyId { get; set; }
        public long receiptDetailId { get; set; }
        public int pileType { get; set; }
        public int areaId { get; set; }

        public int locIndex { get; set; }

        public string boxCode { get; set; }
        public string barCode { get; set; }
        public int status { get; set; }

        public int infoCount { get; set; }
        public int locked { get; set; }

        public DateTime createTime { get; set; }

        public string sameCode { get; set; }

        public DateTime changeTime { get; set; }

        public int occupancy { get; set; }

        public int pkStatus { get; set; }

        public long stockId { get; set; }

        public int pos { get; set; }
        public long loctionId { get; set; }
        public long itemId { get; set; }
        public long batchId { get; set; }
        public string itemCode { get; set; }
        public DateTime inTime { get; set; }
        public DateTime outTime { get; set; }
        public long receiptlnId { get; set; }
        public long receiptlOutId { get; set; }
        public long soOutId { get; set; }
        public string wmsBanchNo { get; set; }
        public int countDb { get; set; }
        public int stockStatus { get; set; }
        public int bussStatus { get; set; }
        public DateTime businessCreateTime { get; set; }
        public int businessExp { get; set; }
        public long stockDetailId { get; set; }
        public long id { get; set; }
        public int isFull { get; set; }

        public int pkDetailStatus { get; set; }

        public int locId { get; set; }
        //批次相关实体-----------------------
        //public string itemName { get; set; }
        /*
        1 待检验
        2 已抽样
        3 合规
        4 不合规
        */
        public int? businessStatus { get; set; }

        public int? type { get; set; } //1.原料 2.成品


        public DateTime? retestDate { get; set; }

        public int? frozen { get; set; }
        //无领用超过半年的时间
        public int noOutTime { get; set; }

        public string itemName { get; set; }

        public int priority { get; set; }
        public DateTime? releaseDate
        {
            get; set;
        }
    }
}