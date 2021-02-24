using Blog.Core.Common;
using Blog.Core.Common.DB;
using Blog.Core.Common.Helper;
using Blog.Core.Model.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace Blog.Core.Model.Seed
{
    public class DBSeed
    {
        private static string SeedDataFolder = "BlogCore.Data.json/{0}.json";


        /// <summary>
        /// 异步添加种子数据
        /// </summary>
        /// <param name="myContext"></param>
        /// <param name="WebRootPath"></param>
        /// <returns></returns>
        public static async Task SeedAsync(MyContext myContext, string WebRootPath)
        {
            try
            {
                if (string.IsNullOrEmpty(WebRootPath))
                {
                    throw new Exception("获取wwwroot路径时，异常！");
                }

                SeedDataFolder = Path.Combine(WebRootPath, SeedDataFolder);

                Console.WriteLine("************ Blog.Core DataBase Set *****************");
                Console.WriteLine($"Is multi-DataBase: {Appsettings.app(new string[] { "MutiDBEnabled" })}");
                Console.WriteLine($"Is CQRS: {Appsettings.app(new string[] { "CQRSEnabled" })}");
                Console.WriteLine();
                Console.WriteLine($"Master DB ConId: {MyContext.ConnId}");
                Console.WriteLine($"Master DB Type: {MyContext.DbType}");
                Console.WriteLine($"Master DB ConnectString: {MyContext.ConnectionString}");
                Console.WriteLine();
                if (Appsettings.app(new string[] { "MutiDBEnabled" }).ObjToBool())
                {
                    var slaveIndex = 0;
                    BaseDBConfig.MutiConnectionString.Item1.Where(x => x.ConnId != MainDb.CurrentDbConnId).ToList().ForEach(m =>
                    {
                        slaveIndex++;
                        Console.WriteLine($"Slave{slaveIndex} DB ID: {m.ConnId}");
                        Console.WriteLine($"Slave{slaveIndex} DB Type: {m.DbType}");
                        Console.WriteLine($"Slave{slaveIndex} DB ConnectString: {m.Connection}");
                        Console.WriteLine($"--------------------------------------");
                    });
                }
                else if (Appsettings.app(new string[] { "CQRSEnabled" }).ObjToBool())
                {
                    var slaveIndex = 0;
                    BaseDBConfig.MutiConnectionString.Item2.Where(x => x.ConnId != MainDb.CurrentDbConnId).ToList().ForEach(m =>
                    {
                        slaveIndex++;
                        Console.WriteLine($"Slave{slaveIndex} DB ID: {m.ConnId}");
                        Console.WriteLine($"Slave{slaveIndex} DB Type: {m.DbType}");
                        Console.WriteLine($"Slave{slaveIndex} DB ConnectString: {m.Connection}");
                        Console.WriteLine($"--------------------------------------");
                    });
                }
                else
                {
                }

                Console.WriteLine();


                // 创建数据库
                Console.WriteLine($"Create Database(The Db Id:{MyContext.ConnId})...");
                myContext.Db.DbMaintenance.CreateDatabase();
                ConsoleHelper.WriteSuccessLine($"Database created successfully!");


                // 创建数据库表，遍历指定命名空间下的class，
                // 注意不要把其他命名空间下的也添加进来。
                Console.WriteLine("Create Tables...");
                var modelTypes = from t in Assembly.GetExecutingAssembly().GetTypes()
                        where t.IsClass && t.Namespace == "Blog.Core.Model.Models" 
                        select t;
                modelTypes.ToList().ForEach(t =>
                {
                    if (!myContext.Db.DbMaintenance.IsAnyTable(t.Name))
                    {
                        Console.WriteLine(t.Name);
                        myContext.Db.CodeFirst.InitTables(t);
                    }
                });
                ConsoleHelper.WriteSuccessLine($"Tables created successfully!");
                Console.WriteLine();


                if (Appsettings.app(new string[] { "AppSettings", "SeedDBDataEnabled" }).ObjToBool())
                {
                    JsonSerializerSettings setting = new JsonSerializerSettings();
                    JsonConvert.DefaultSettings = new Func<JsonSerializerSettings>(() =>
                    {
                        //日期类型默认格式化处理
                        setting.DateFormatHandling = DateFormatHandling.MicrosoftDateFormat;
                        setting.DateFormatString = "yyyy-MM-dd HH:mm:ss";

                        //空值处理
                        setting.NullValueHandling = NullValueHandling.Ignore;

                        //高级用法九中的Bool类型转换 设置
                        setting.Converters.Add(new BoolConvert("是,否"));

                        return setting;
                    });

                    Console.WriteLine($"Seeding database data (The Db Id:{MyContext.ConnId})...");
                    
                    #region OperateLog
                    //if (!await myContext.Db.Queryable<OperateLog>().AnyAsync())
                    //{
                    //    myContext.GetEntityDB<OperateLog>().InsertRange(JsonHelper.JsonConvertJsonToObject<List<OperateLog>>(FileHelper.ReadFile(string.Format(SeedDataFolder, "OperateLog"), Encoding.UTF8), "RECORDS").ToList());
                    //    Console.WriteLine("Table:OperateLog created success!");
                    //}
                    //else
                    //{
                    //    Console.WriteLine("Table:OperateLog already exists...");
                    //}
                    #endregion

                    #region SysCode
                    if (!await myContext.Db.Queryable<SysCode>().AnyAsync())
                    {
                        myContext.GetEntityDB<SysCode>().InsertRange(JsonHelper.DeserializeJsonToObject<List<SysCode>>(FileHelper.ReadFile(string.Format(SeedDataFolder, "SysCode"), Encoding.UTF8), "RECORDS").ToList());
                        Console.WriteLine("Table:SysCode created success!");
                    }
                    else
                    {
                        Console.WriteLine("Table:SysCode already exists...");
                    }
                    #endregion

                    #region SysDict
                    if (!await myContext.Db.Queryable<SysDict>().AnyAsync())
                    {
                        myContext.GetEntityDB<SysDict>().InsertRange(JsonHelper.DeserializeJsonToObject<List<SysDict>>(FileHelper.ReadFile(string.Format(SeedDataFolder, "SysDict"), Encoding.UTF8), "RECORDS").ToList());
                        Console.WriteLine("Table:SysDict created success!");
                    }
                    else
                    {
                        Console.WriteLine("Table:SysDict already exists...");
                    }
                    #endregion

                    #region SysDictClass
                    if (!await myContext.Db.Queryable<SysDictClass>().AnyAsync())
                    {
                        myContext.GetEntityDB<SysDictClass>().InsertRange(JsonHelper.DeserializeJsonToObject<List<SysDictClass>>(FileHelper.ReadFile(string.Format(SeedDataFolder, "SysDictClass"), Encoding.UTF8), "RECORDS").ToList());
                        Console.WriteLine("Table:SysDictClass created success!");
                    }
                    else
                    {
                        Console.WriteLine("Table:SysDictClass already exists...");
                    }
                    #endregion

                    #region SysMenu
                    if (!await myContext.Db.Queryable<SysMenu>().AnyAsync())
                    {
                        myContext.GetEntityDB<SysMenu>().InsertRange(JsonHelper.DeserializeJsonToObject<List<SysMenu>>(FileHelper.ReadFile(string.Format(SeedDataFolder, "SysMenu"), Encoding.UTF8), "RECORDS").ToList());
                        Console.WriteLine("Table:SysMenu created success!");
                    }
                    else
                    {
                        Console.WriteLine("Table:SysMenu already exists...");
                    }
                    #endregion

                    #region SysRole
                    if (!await myContext.Db.Queryable<SysRole>().AnyAsync())
                    {
                        myContext.GetEntityDB<SysRole>().InsertRange(JsonHelper.DeserializeJsonToObject<List<SysRole>>(FileHelper.ReadFile(string.Format(SeedDataFolder, "SysRole"), Encoding.UTF8), "RECORDS").ToList());
                        Console.WriteLine("Table:SysRole created success!");
                    }
                    else
                    {
                        Console.WriteLine("Table:SysRole already exists...");
                    }
                    #endregion

                    #region SysRoleMenu
                    if (!await myContext.Db.Queryable<SysRoleMenu>().AnyAsync())
                    {
                        myContext.GetEntityDB<SysRoleMenu>().InsertRange(JsonHelper.DeserializeJsonToObject<List<SysRoleMenu>>(FileHelper.ReadFile(string.Format(SeedDataFolder, "SysRoleMenu"), Encoding.UTF8), "RECORDS").ToList());
                        Console.WriteLine("Table:SysRoleMenu created success!");
                    }
                    else
                    {
                        Console.WriteLine("Table:SysRoleMenu already exists...");
                    }
                    #endregion

                    #region SysUser
                    if (!await myContext.Db.Queryable<SysUser>().AnyAsync())
                    {
                        myContext.GetEntityDB<SysUser>().InsertRange(JsonHelper.DeserializeJsonToObject<List<SysUser>>(FileHelper.ReadFile(string.Format(SeedDataFolder, "SysUser"), Encoding.UTF8), "RECORDS").ToList());
                        Console.WriteLine("Table:SysUser created success!");
                    }
                    else
                    {
                        Console.WriteLine("Table:SysUser already exists...");
                    }
                    #endregion

                    #region SysUserRole
                    if (!await myContext.Db.Queryable<SysUserRole>().AnyAsync())
                    {
                        myContext.GetEntityDB<SysUserRole>().InsertRange(JsonHelper.DeserializeJsonToObject<List<SysUserRole>>(FileHelper.ReadFile(string.Format(SeedDataFolder, "SysUserRole"), Encoding.UTF8), "RECORDS").ToList());
                        Console.WriteLine("Table:SysUserRole created success!");
                    }
                    else
                    {
                        Console.WriteLine("Table:SysUserRole already exists...");
                    }
                    #endregion

                    #region TasksQz
                    if (!await myContext.Db.Queryable<TasksQz>().AnyAsync())
                    {
                        myContext.GetEntityDB<TasksQz>().InsertRange(JsonHelper.DeserializeJsonToObject<List<TasksQz>>(FileHelper.ReadFile(string.Format(SeedDataFolder, "TasksQz"), Encoding.UTF8), "RECORDS").ToList());
                        Console.WriteLine("Table:TasksQz created success!");
                    }
                    else
                    {
                        Console.WriteLine("Table:TasksQz already exists...");
                    }
                    #endregion

                    #region CoreItem
                    if (!await myContext.Db.Queryable<CoreItem>().AnyAsync())
                    {
                        myContext.GetEntityDB<CoreItem>().InsertRange(JsonHelper.DeserializeJsonToObject<List<CoreItem>>(FileHelper.ReadFile(string.Format(SeedDataFolder, "CoreItem"), Encoding.UTF8), "RECORDS").ToList());
                        Console.WriteLine("Table:CoreItem created success!");
                    }
                    else
                    {
                        Console.WriteLine("Table:CoreItem already exists...");
                    }
                    #endregion

                    #region CoreClassify
                    if (!await myContext.Db.Queryable<CoreClassify>().AnyAsync())
                    {
                        myContext.GetEntityDB<CoreClassify>().InsertRange(JsonHelper.DeserializeJsonToObject<List<CoreClassify>>(FileHelper.ReadFile(string.Format(SeedDataFolder, "CoreClassify"), Encoding.UTF8), "RECORDS").ToList());
                        Console.WriteLine("Table:CoreClassify created success!");
                    }
                    else
                    {
                        Console.WriteLine("Table:CoreClassify already exists...");
                    }
                    #endregion

                    ConsoleHelper.WriteSuccessLine($"Done seeding database!");
                }

                Console.WriteLine();

            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message+"1、如果使用的是Mysql，生成的数据库字段字符集可能不是utf8的，手动修改下，或者尝试方案：删掉数据库，在连接字符串后加上CharSet=UTF8mb4，重新生成数据库. \n 2、其他错误：" + ex.Message);
            }
        }
    }
}