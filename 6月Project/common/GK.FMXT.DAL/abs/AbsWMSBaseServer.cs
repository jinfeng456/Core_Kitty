using System;
using System.Text;
using System.Linq;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
using Dapper;
using static Dapper.SqlMapper;
using GK.BACK.DAL;
using Common;
using Common.DAL.abs;
using Common.DAL.inter;

namespace GK.WMS.DAL.abs
{//
    public abstract class AbsWMSBaseServer : AbsBaseServer,IBaseServer
    {
        

          protected  override IDbConnection getConnection() {
            return FmxtDBUtils.CreateBACKConnection(FmxtDalFactray.prefixal);
        }
        

         public override GKDBType getGKDBType() { 
            return FmxtDalFactray.prefixal;
            }

       
    }

}
