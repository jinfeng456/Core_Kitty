using Common.dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GK.WMS.Entity.dto
{
    public class ReceiptInReportDto : PageDto
    {
        //主表

        public int status { get; set; }

        public string receiptNo { get; set; }


        public int stn { get; set; }

        public DateTime beginTime { get; set; }

        public DateTime finshTime { get; set; }

        //子表

        public long? receiptId
        {
            get; set;
        }

        public int? planCount
        {
            get; set;
        }
        public int? finshCount
        {
            get; set;
        }
        public int? activeCount
        {
            get; set;
        }

        public string itemName
        {
            get; set;
        }

        public string wmsBanchNo
        {
            get; set;
        }

        public int inType
        {
            get; set;
        }

        public string fromCorpName
        {
            get; set;
        }

        public string fromCorpBatchNo
        {
            get; set;
        }

        public string packageSpec
        {
            get; set;
        }

        public string packUnit
        { 
            get; set;
        }
    }
}