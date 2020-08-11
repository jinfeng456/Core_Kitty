using Blog.Core.Common;
using Blog.Core.Common.DB;
using Blog.Core.Common.Helper;
using Blog.Core.Model.Models;
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
        private static string SeedDataFolder = "BlogCore.Data.json/{0}.tsv";


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


                //if (Appsettings.app(new string[] { "AppSettings", "SeedDBDataEnabled" }).ObjToBool())
                //{
                //    Console.WriteLine($"Seeding database data (The Db Id:{MyContext.ConnId})...");

                //    #region SysCode
                //    if (!await myContext.Db.Queryable<SysCode>().AnyAsync())
                //    {
                //        myContext.GetEntityDB<SysCode>().InsertRange(JsonHelper.ParseFormByJson<List<SysCode>>(FileHelper.ReadFile(string.Format(SeedDataFolder, "SysCode"), Encoding.UTF8)));
                //        Console.WriteLine("Table:SysCode created success!");
                //    }
                //    else
                //    {
                //        Console.WriteLine("Table:SysCode already exists...");
                //    }
                //    #endregion

                //    #region SysDict
                //    if (!await myContext.Db.Queryable<SysDict>().AnyAsync())
                //    {
                //        myContext.GetEntityDB<SysDict>().InsertRange(JsonHelper.ParseFormByJson<List<SysDict>>(FileHelper.ReadFile(string.Format(SeedDataFolder, "SysDict"), Encoding.UTF8)));
                //        Console.WriteLine("Table:SysDict created success!");
                //    }
                //    else
                //    {
                //        Console.WriteLine("Table:SysDict already exists...");
                //    }
                //    #endregion

                //    #region SysDictClass
                //    if (!await myContext.Db.Queryable<SysDictClass>().AnyAsync())
                //    {
                //        myContext.GetEntityDB<SysDictClass>().InsertRange(JsonHelper.ParseFormByJson<List<SysDictClass>>(FileHelper.ReadFile(string.Format(SeedDataFolder, "SysDictClass"), Encoding.UTF8)));
                //        Console.WriteLine("Table:SysDictClass created success!");
                //    }
                //    else
                //    {
                //        Console.WriteLine("Table:SysDictClass already exists...");
                //    }
                //    #endregion

                //    #region SysLog
                //    if (!await myContext.Db.Queryable<SysLog>().AnyAsync())
                //    {
                //        myContext.GetEntityDB<SysLog>().InsertRange(JsonHelper.ParseFormByJson<List<SysLog>>(FileHelper.ReadFile(string.Format(SeedDataFolder, "SysLog"), Encoding.UTF8)));
                //        Console.WriteLine("Table:SysLog created success!");
                //    }
                //    else
                //    {
                //        Console.WriteLine("Table:SysLog already exists...");
                //    }
                //    #endregion

                //    #region SysMenu
                //    if (!await myContext.Db.Queryable<SysMenu>().AnyAsync())
                //    {
                //        myContext.GetEntityDB<SysMenu>().InsertRange(JsonHelper.ParseFormByJson<List<SysMenu>>(FileHelper.ReadFile(string.Format(SeedDataFolder, "SysMenu"), Encoding.UTF8)));
                //        Console.WriteLine("Table:SysMenu created success!");
                //    }
                //    else
                //    {
                //        Console.WriteLine("Table:SysMenu already exists...");
                //    }
                //    #endregion

                //    #region SysRole
                //    if (!await myContext.Db.Queryable<SysRole>().AnyAsync())
                //    {
                //        myContext.GetEntityDB<SysRole>().InsertRange(JsonHelper.ParseFormByJson<List<SysRole>>(FileHelper.ReadFile(string.Format(SeedDataFolder, "SysRole"), Encoding.UTF8)));
                //        Console.WriteLine("Table:SysRole created success!");
                //    }
                //    else
                //    {
                //        Console.WriteLine("Table:SysRole already exists...");
                //    }
                //    #endregion

                //    #region SysRoleMenu
                //    if (!await myContext.Db.Queryable<SysRoleMenu>().AnyAsync())
                //    {
                //        myContext.GetEntityDB<SysRoleMenu>().InsertRange(JsonHelper.ParseFormByJson<List<SysRoleMenu>>(FileHelper.ReadFile(string.Format(SeedDataFolder, "SysRoleMenu"), Encoding.UTF8)));
                //        Console.WriteLine("Table:SysRoleMenu created success!");
                //    }
                //    else
                //    {
                //        Console.WriteLine("Table:SysRoleMenu already exists...");
                //    }
                //    #endregion

                //    #region SysUser
                //    if (!await myContext.Db.Queryable<SysUser>().AnyAsync())
                //    {
                //        myContext.GetEntityDB<SysUser>().InsertRange(JsonHelper.ParseFormByJson<List<SysUser>>(FileHelper.ReadFile(string.Format(SeedDataFolder, "SysUser"), Encoding.UTF8)));
                //        Console.WriteLine("Table:SysUser created success!");
                //    }
                //    else
                //    {
                //        Console.WriteLine("Table:SysUser already exists...");
                //    }
                //    #endregion

                //    #region SysUserRole
                //    if (!await myContext.Db.Queryable<SysUserRole>().AnyAsync())
                //    {
                //        myContext.GetEntityDB<SysUserRole>().InsertRange(JsonHelper.ParseFormByJson<List<SysUserRole>>(FileHelper.ReadFile(string.Format(SeedDataFolder, "SysUserRole"), Encoding.UTF8)));
                //        Console.WriteLine("Table:SysUserRole created success!");
                //    }
                //    else
                //    {
                //        Console.WriteLine("Table:SysUserRole already exists...");
                //    }
                //    #endregion

                //    ConsoleHelper.WriteSuccessLine($"Done seeding database!");
                //}

                Console.WriteLine();

            }
            catch (Exception ex)
            {
                throw new Exception("1、如果使用的是Mysql，生成的数据库字段字符集可能不是utf8的，手动修改下，或者尝试方案：删掉数据库，在连接字符串后加上CharSet=UTF8mb4，重新生成数据库. \n 2、其他错误：" + ex.Message);
            }
        }
    }
}