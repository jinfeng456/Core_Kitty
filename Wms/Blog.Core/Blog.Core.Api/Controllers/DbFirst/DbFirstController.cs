using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Hosting;
using SqlSugar;
using System.Threading.Tasks;
using Blog.Core.Model;
using Blog.Core.Common.DB;
using Blog.Core.Common;
using Blog.Core.IServices;
using Blog.Core.Model.Seed;
using System.IO;
using System;

namespace Blog.Core.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    //[Authorize(Permissions.Name)]
    public class DbFirstController : ControllerBase
    {
        private readonly SqlSugarClient _sqlSugarClient;
        private readonly IWebHostEnvironment Env;
        private readonly ITableServices _tableServices;


        /// <summary>
        /// 构造函数
        /// </summary>
        public DbFirstController(ISqlSugarClient sqlSugarClient, IWebHostEnvironment env, ITableServices tableServices)
        {
            _tableServices = tableServices;
            _sqlSugarClient = sqlSugarClient as SqlSugarClient;
            Env = env;
        }

        
        /// <summary>
        /// DbFrist 根据数据库表名 生成整体框架,包含Model层
        /// </summary>
        /// <param name="ConnID">数据库链接名称</param>
        /// <param name="tableNames">需要生成的表名</param>
        /// <param name="templete">view模板</param>
        /// <returns></returns>
        [HttpPost]
        public MessageModel<string> GetAllFrameFilesByTableNames([FromBody]string[] tableNames, [FromQuery]string ConnID = null, [FromQuery]string templete = "")
        {
            ConnID = ConnID == null ? MainDb.CurrentDbConnId.ToLower() : ConnID;
            var isMuti = Appsettings.app(new string[] { "MutiDBEnabled" }).ObjToBool();
            var data = new MessageModel<string>() { success = true, msg = "" };

            var currentPath = Path.GetDirectoryName(Path.GetDirectoryName(Path.GetDirectoryName(Path.GetDirectoryName(Path.GetDirectoryName(AppDomain.CurrentDomain.BaseDirectory + "..") + "..") + "..") + "..") + "..");
            var ViewPath = @"E:\项目代码\Core_Kitty\6月Project\kitty - ui\src\views\Test";
            var JsPath = @"E:\项目代码\Core_Kitty\6月Project\kitty-ui\src\http\moudules\test";
            var ControllerPath = Path.Combine(currentPath, "Controllers_New");
            var DtoPath = Path.Combine(Path.GetDirectoryName(currentPath + ".."), "Blog.Core.Model", "ViewModels_New");
            var ModelPath = Path.Combine(Path.GetDirectoryName(currentPath + ".."), "Blog.Core.Model", "Models_New");
            var IRepositorysPath = Path.Combine(Path.GetDirectoryName(currentPath + ".."), "Blog.Core.IRepository", "IRepositories_New");
            var IServicesPath = Path.Combine(Path.GetDirectoryName(currentPath + ".."), "Blog.Core.IServices", "IServices_New");
            var RepositoryPath = Path.Combine(Path.GetDirectoryName(currentPath + ".."), "Blog.Core.Repository", "Repository_New");
            var ServicesPath = Path.Combine(Path.GetDirectoryName(currentPath + ".."), "Blog.Core.Services", "Services_New");

            if (Env.IsDevelopment())
            {
                _sqlSugarClient.ChangeDatabase(ConnID.ToLower());
                data.response += $"View生成：{FrameSeed.CreateView(_sqlSugarClient,ViewPath, ConnID, isMuti, tableNames, templete)} || ";
                data.response += $"JS生成：{FrameSeed.CreateJS(_sqlSugarClient,JsPath, ConnID, isMuti, tableNames)} || ";
                data.response += $"Controller层生成：{FrameSeed.CreateControllers(_sqlSugarClient,ControllerPath, ConnID, isMuti, tableNames)} || ";
                data.response += $"库{ConnID}-Dto层生成：{FrameSeed.CreateDto(_sqlSugarClient,DtoPath, ConnID, isMuti, tableNames)} || ";
                data.response += $"库{ConnID}-Model层生成：{FrameSeed.CreateModels(_sqlSugarClient,ModelPath, ConnID, isMuti, tableNames)} || ";
                data.response += $"库{ConnID}-IRepositorys层生成：{FrameSeed.CreateIRepositorys(_sqlSugarClient,IRepositorysPath, ConnID, isMuti, tableNames)} || ";
                data.response += $"库{ConnID}-IServices层生成：{FrameSeed.CreateIServices(_sqlSugarClient,IServicesPath, ConnID, isMuti, tableNames)} || ";
                data.response += $"库{ConnID}-Repository层生成：{FrameSeed.CreateRepository(_sqlSugarClient,RepositoryPath, ConnID, isMuti, tableNames)} || ";
                data.response += $"库{ConnID}-Services层生成：{FrameSeed.CreateServices(_sqlSugarClient,ServicesPath, ConnID, isMuti, tableNames)} || ";
                // 切回主库
                _sqlSugarClient.ChangeDatabase(MainDb.CurrentDbConnId.ToLower());
            }
            else
            {
                data.success = false;
                data.msg = "当前不处于开发模式，代码生成不可用！";
            }

            return data;
        }

        /// <summary>
        /// 获取当前数据库
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        public BaseResult GetDatabase()
        {
            return BaseResult.Ok(MainDb.CurrentDbConnId.ToLower());
        }

        /// <summary>
        /// 查询全部表
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task<BaseResult> GetTableNames()
        {
            return BaseResult.Ok(await _tableServices.FindTables());
        }


    }
}