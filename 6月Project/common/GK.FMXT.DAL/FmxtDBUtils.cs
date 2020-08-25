using Common;
using Oracle.DataAccess.Client;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Text;

namespace GK.BACK.DAL
{
    public class FmxtDBUtils
    {
        private static IDbConnection WCSConnection = null;
        static FmxtDBUtils() {
            Dapper.DefaultTypeMap.MatchNamesWithUnderscores = true;
        }
        public static IDbConnection CreateBACKConnection(GKDBType type) {
            if (WCSConnection != null) {
                return WCSConnection;
            }
            WCSConnection = CreateNewBACKConnection(type);
            return WCSConnection;
        }

        internal static IDbConnection CreateBACKConnection(object prefixal) {
            throw new NotImplementedException();
        }

        public static IDbConnection CreateNewBACKConnection(GKDBType type) {
             IDbConnection connection =null;
            if (type == GKDBType.sqlserver) {
                ConnectionStringSettings connectionStringSettings = ConfigurationManager.ConnectionStrings["DB_fmxt"];
                 connection =
                    DbProviderFactories.GetFactory(connectionStringSettings.ProviderName).CreateConnection();
                connection.ConnectionString = connectionStringSettings.ConnectionString;
              
            }
            if (type == GKDBType.oracle) {
                ConnectionStringSettings connectionStringSettings = ConfigurationManager.ConnectionStrings["DB_fmxt"];
                 connection = new OracleConnection(connectionStringSettings.ConnectionString);
              
            }

            connection.Open();
            return connection;
        }


    }
}
