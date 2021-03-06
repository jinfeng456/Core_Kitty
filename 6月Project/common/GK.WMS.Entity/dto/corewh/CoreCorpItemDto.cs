﻿using Common.dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HY.WCS.DAL.dto
{
    public class CoreCorpItemDto : PageDto
    {
        public long id { get; set; }
        public long supplierId { get; set; }
        public string gysName { get; set; }
        public string name { get; set; }
        public long itemId { get; set; }

        public string code { get; set; }

        public string modelSpecs
        {
            get; set;
        }

        public string packageSpecs
        {
            get; set;
        }
        public long classifyId { get; set; }
        public int coreItemType { get; set; }
    }
}