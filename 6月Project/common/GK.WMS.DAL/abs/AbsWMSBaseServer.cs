using System;
using System.Text;
using System.Linq;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
using Dapper;

using static Dapper.SqlMapper;
using GK.Common.dto;
using GK.Common;
using GK.DAL.inter;
using GK.DAL.dialect;
using GK.Common;

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
