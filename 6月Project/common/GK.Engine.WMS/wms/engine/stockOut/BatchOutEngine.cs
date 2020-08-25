
using System;
using System.Data;
using Dapper;
using System.Collections.Generic;
using GK.WMS.Entity;
using System.Linq;
using GK.WMS.DAL;
using GK.WMS.Entity.wms;
using GK.Engine.WMS.wms;

namespace GK.Engine.WMS
{
    public class BatchOutEngine : OutEngine
    {

        public override bool checkBatch()
        {
            return false;
        }
        override public String getParamQueryOrder()
        {

            return "order by B.receiptl_Out_Id ASC,A.is_Full,A.create_Time DESC";
        }
        public override int getStatus()
        {
            return 3;
        }
    
    }
}
