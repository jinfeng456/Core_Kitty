using Dapper;
using GK.WMS.Entity;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace GK.WMS.DAL.util
{
    public class SysUtil
    {
        public static string GetSerial(IDbConnection Connection, string tableName, int businessType = 0, string description = "")
        {
            string todayDate = DateTime.Now.ToString("yyMMdd");
            var sqlQuery = "select * from sys_code where 1=1  ";
            string param = GetParams(tableName, businessType, description);
            var codeInfo = Connection.Query<SysCode>(sqlQuery + param, new { tableName = tableName, businessType = businessType, description = description }).FirstOrDefault();
            if (codeInfo == null)
            {
                return string.Empty;
            }           
            string serialPrefix = codeInfo.serialPrefix;
            int codeNumber = 1;
            if (todayDate == (codeInfo.codeDate != null ? codeInfo.codeDate.ToString("yyMMdd") : ""))
            {
                codeNumber = (codeInfo.codeNumber ?? 0) + 1;
                var sqlUpdate = "UPDATE sys_code SET code_Number=@codeNumber WHERE 1=1 ";
                Connection.Execute(sqlUpdate + param, new { codeNumber = codeNumber, tableName = tableName, businessType = businessType, description = description });
            }
            else
            {
                var sqlUpdate = "UPDATE sys_code SET code_Number=1,code_Date=@codeDate WHERE 1=1 ";
                Connection.Execute(sqlUpdate + param, new { codeDate = todayDate, tableName = tableName, businessType = businessType, description = description });
            }
            string serial = serialPrefix + "-" + DateTime.Now.ToString("yyMMdd") + "000" + codeNumber;
            return serial;
        }

        private static string GetParams(string tableName, int businessType, string description)
        {
            string param = string.Empty;
            if (!string.IsNullOrEmpty(tableName))
            {
                param += "and table_name=@tableName ";
            }
            if (businessType != 0)
            {
                param += "and business_Type=@businessType ";
            }
            if (!string.IsNullOrEmpty(description))
            {
                param += "and table_description=@description ";
            }
            return param;
        }
    }
}
