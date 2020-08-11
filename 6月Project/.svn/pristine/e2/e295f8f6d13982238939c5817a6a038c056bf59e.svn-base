
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Data.Common;
using Dapper;
using System.Collections.Generic;
using GK.WCS.DAL;
using GK.WMS.Entity;
using GK.WMS.DAL;
using GK.WMS.Common;
using GK.Common.trans;

namespace GK.Common
{
    public  class StockOutEngine : GkTransaction {
        long WhReceiptId; int stn; long locId = 0;
        protected override bool Execute(IDbConnection connection, IDbTransaction transaction)  
        {
          
            
            List<long> loc = getLoction(WhReceiptId, stn,connection,  transaction);
            bool check = checkLoction(WhReceiptId, stn, loc, connection, transaction);
            if (check) {
                saveData(WhReceiptId, stn, loc, connection, transaction);
            }
            return true;
        }


        public List<long> getLoction(long WhReceiptId, int stn,IDbConnection connection, IDbTransaction transaction) {
            return null;
        }
        public bool checkLoction(long WhReceiptId, int stn, List<long> loction,IDbConnection connection, IDbTransaction transaction) {
         return false;
        }
        void saveData(long WhReceiptId, int stn, List<long> loc ,IDbConnection connection, IDbTransaction transaction) { 
        
        }


    }
}
