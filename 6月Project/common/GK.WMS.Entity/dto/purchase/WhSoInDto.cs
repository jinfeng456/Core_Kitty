﻿using Common.dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HY.WCS.DAL.dto
{
    public class WhSoInDto : PageDto
    {
        public long id { get; set; }
        public string soNo { get; set; }

        public string srcSoBill { get; set; }

        public string gysName { get; set; }

        public DateTime createDate { get; set; }

        public DateTime finshDate { get; set; }

        public long gysId { get; set; }

        public string gysCode { get; set; }

        public string status { get; set; }

        public string vbillcode { get; set; }

    }
}