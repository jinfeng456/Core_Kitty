﻿using GK.Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WCS.Entity
{
   public  class TaskCompleteParam : BaseEntity
    {

        public TaskCompleteParam() { }
        public long completeId
        {
            get; set;
        }

        public long detailId
        {
            get; set;
        }

        public int des
        {
            get; set;
        }

        public int pos
        {
            get; set;
        }

        public int status
        {
            get; set;
        }

    }
}
