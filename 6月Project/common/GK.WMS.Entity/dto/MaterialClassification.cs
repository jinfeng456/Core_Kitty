﻿using GK.Common.dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HY.WCS.DAL.dto
{
    public class MaterialClassification : PageDto
    {
        public string name { get; set; }

        public string info { get; set; }

        public int stockWidth { get; set; }

        public int stockHigh { get; set; }

        public int stockDeep { get; set; }
    }
}