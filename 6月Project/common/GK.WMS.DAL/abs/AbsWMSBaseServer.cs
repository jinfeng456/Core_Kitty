using System;
using System.Text;
using System.Linq;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
using Dapper;
using static Dapper.SqlMapper;
using Common.DAL.inter;
using Common.DAL.abs;
using Common;
using WMS.DAL;

namespace GK.WMS.DAL.abs
{//
    public abstract class AbsWMSBaseServer : AbsBaseServer,IBaseServer
    {
        

          protected  override IDbConnection getConnection() {
            return DBUtils.wMSConn(WMSDalFactray.prefixal);
        }
        

         public override GKDBType getGKDBType() { 
            return WMSDalFactray.prefixal;
            }

       
    }

}
