using System;
using System.Text;
using System.Linq;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
using Dapper;
using static Dapper.SqlMapper;
using GK.BACK.DAL;
using GK.WMS.DAL.abs;
using Common.DAL.abs;
using Common.DAL.inter;
using Common;

namespace GK.BACK.DAL.abs
{//
    public abstract class AbsFmxtBaseServer :AbsBaseServer, IBaseServer
    {
    
            protected override  IDbConnection getConnection() {
            return FmxtDBUtils.CreateBACKConnection(FmxtDalFactray.prefixal);
        }
        

        override public  GKDBType getGKDBType() {
          return   FmxtDalFactray.prefixal;
        }
    }

}
