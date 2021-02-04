using System;
using System.Collections.Generic;
using System.Text;

namespace Blog.Core.Common.Helper
{
    /**
	 *┌────────────────────────────────────────────────┐
	 *│　描    述：SqlToCsharpHelper                                                    
	 *│　作    者：jf                                              
	 *│　版    本：1.0                                              
	 *│　创建时间：2021-2-3 9:07:32                        
	 *└────────────────────────────────────────────────┘
	 **/
	public static class SqlToCsharpHelper
    {
        /// <summary>
        /// sql到C#的数据类型转换
        /// </summary>
        /// <param name="typename">sql数据类型名称</param>
        /// <returns>C#名称</returns>
        public static string SqlToCsharp(string typename)
        {

            switch (typename)
            {
                case "bit": return "bool";
                case "bigint": return "long";
                case "int": return "int";
                case "smallint": return "int";
                case "tinyint": return "Byte";
                case "numeric":
                case "money":
                case "smallmoney":
                case "decimal": return "decimal";
                case "float": return "double";
                case "real": return "Single";
                case "smalldatetime":
                case "timestamp":
                case "datetime": return "DateTime";
                case "char":
                case "varchar":
                case "text":
                case "Unicode":
                case "nvarchar":
                case "ntext": return "string";
                case "binary":
                case "varbinary":
                case "image": return "Byte[]";
                case "uniqueidentifier": return "Guid";
                default: return "Object";
            }

        }
    }
}
