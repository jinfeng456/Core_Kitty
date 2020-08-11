

using System.Data;
using GK.WMS.Entity;
using GK.WMS.DAL;
using GK.WMS.Common;
using GK.Common.trans;
using Dapper;
using static Dapper.SqlMapper;
using GK.WCS.DAL;
using System;
using GK.WCS.Entity;

namespace GK.Common.Engine {
    public  class WcsCreateInEngine : GkTransaction {
        long completeId;
      
        protected override bool Execute(IDbConnection connection, IDbTransaction transaction) {
         
            TaskCarrier Carrier = new TaskCarrier();
            // Carrier.endPath = getCarrierEnd(connection, transaction);
            Carrier.endPath = 2445;
            Carrier.startPath = 123;
            Carrier.completeId = 123;
            Carrier.conpleteParamId = 234;
            Carrier.StartTime= DateTime.Now;
            connection.InsertNoNull(Carrier, transaction);
            
            //TaskCrane tc = new TaskCrane();
            //connection.Insert(tc, transaction);
            
            return true;
           
        }

        protected int getCarrierEnd(IDbConnection connection, IDbTransaction transaction) {
            return 1;
        }
        protected  int getCraneEnd(IDbConnection connection, IDbTransaction transaction)
        {
            return 1;
        }


    }
}
