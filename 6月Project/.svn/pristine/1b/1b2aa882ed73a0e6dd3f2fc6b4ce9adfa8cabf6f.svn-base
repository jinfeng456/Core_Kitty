
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
    public class OtherOutEngine : OutEngine
    {

        public override bool checkBatch()
        {
            return true;
        }
        public override String getParamQueryOrder()
        {
            return "order by A.is_Full,A.create_Time DESC";
        }

        public override int getStatus()
        {
            return 299;
        }


    }
}
