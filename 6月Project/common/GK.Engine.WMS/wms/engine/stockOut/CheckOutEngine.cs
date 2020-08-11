﻿
using System;
using System.Data;
using Dapper;
using System.Collections.Generic;
using GK.WMS.Entity;
using System.Linq;
using GK.WMS.DAL;
using GK.WMS.Entity.wms;
using GK.Engine.WMS.wms;
using GK.Mongon;

namespace GK.Engine.WMS
{
    public class CheckOutEngine : OutEngine
    {

        public override bool checkBatch()
        {
            return false;
        }
        override public String getParamQueryOrder()
        {

            return "";
        }

        public override int getStatus()
        {
            return 206;
        }

    }
}
