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
using GK.BACK.DAL;
using GK.WMS.DAL.abs;

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
