using System;
using System.Text;
using System.Linq;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
using Dapper;
using static Dapper.SqlMapper;
using GK.BACK.DAL;
using Common.DAL.abs;
using Common;
using Common.DAL.inter;

namespace GK.BACK.DAL.abs
{//
    public abstract class AbsBackBaseServer :AbsBaseServer, IBaseServer
    {
    
            protected override  IDbConnection getConnection() {
            return BackDBUtils.CreateBACKConnection(BackDalFactray.prefixal);
        }
        

        override public  GKDBType getGKDBType() {
          return   BackDalFactray.prefixal;
        }
    }

}
