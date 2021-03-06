﻿using GK.Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity
{
    public class CoreStockDetail : BaseEntity
    {
        public long? stockId
        {
            get; set;
        }

        public int? pos
        {
            get; set;
        }
        public long? loctionId
        {
            get; set;
        }
        public long? itemId
        {
            get; set;
        }
        public string itemCode
        {
            get; set;
        }
        public DateTime? inTime
        {
            get; set;
        }
        public DateTime? outTime
        {
            get; set;
        }
        public long? receiptlnId
        {
            get; set;
        }
        public long? receiptlOutId
        {
            get; set;
        }

        public string wmsBanchNo
        {
            get; set;
        }
        public int? countDb
        {
            get; set;
        }
        public int? pkStatus
        {
            get; set;
        }
        public int? stockStatus
        {
            get; set;
        }
        public int? bussStatus
        {
            get; set;
        }
        public DateTime? businessCreateTime
        {
            get; set;
        }
        public DateTime? exp
        {
            get; set;
        }

        public string barCode
        {
            get; set;
        }
        public long? batchId
        {
            get; set;
        }

        public long? receiptpkid
        {
            get; set;
        }

        public int? Priority { get; set; }
        public string remark { get; set; }
        public DateTime? releaseDate
        {
            get; set;
        }
        /// <summary>
        /// 批次状态(冗余字段)
        /// </summary>
        public int rBussinessStatus { get; set; }

        public string packUnit {get;set;}
    }
}
