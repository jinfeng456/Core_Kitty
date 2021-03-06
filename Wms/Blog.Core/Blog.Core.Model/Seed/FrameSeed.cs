using Blog.Core.Common.Helper;
using SqlSugar;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace Blog.Core.Model.Seed
{
    public class FrameSeed
    {


        /// <summary>
        /// 生成ViewQueryS层
        /// </summary>
        /// <param name="sqlSugarClient">sqlsugar实例</param>
        /// <param name="ConnId">数据库链接ID</param>
        /// <param name="tableNames">数据库表名数组，默认空，生成所有表</param>
        /// <param name="isMuti"></param>
        /// <param name="templete"></param>
        /// <returns></returns>
        public static bool CreateView(SqlSugarClient sqlSugarClient, string path, string ConnId = null, bool isMuti = false, string[] tableNames = null, string templete = "")
        {
            try
            {
                if (string.IsNullOrEmpty(templete))
                {
                    return true;
                }
                Create_View_ClassFileByDBTalbe(sqlSugarClient, ConnId, path, "Blog.Core.Api.View", tableNames, "", isMuti, false, templete);
                return true;
            }
            catch (Exception)
            {
                return false;
            }

        }
        /// <summary>
        /// 生成JS层
        /// </summary>
        /// <param name="sqlSugarClient">sqlsugar实例</param>
        /// <param name="ConnId">数据库链接ID</param>
        /// <param name="tableNames">数据库表名数组，默认空，生成所有表</param>
        /// <param name="isMuti"></param>
        /// <returns></returns>
        public static bool CreateJS(SqlSugarClient sqlSugarClient, string path, string ConnId = null, bool isMuti = false, string[] tableNames = null)
        {
            try
            {
                Create_JS_ClassFileByDBTalbe(sqlSugarClient, ConnId, path, "Blog.Core.Api.JS", tableNames, "", isMuti);
                return true;
            }
            catch (Exception)
            {
                return false;
            }

        }

        /// <summary>
        /// 生成Controller层
        /// </summary>
        /// <param name="sqlSugarClient">sqlsugar实例</param>
        /// <param name="ConnId">数据库链接ID</param>
        /// <param name="tableNames">数据库表名数组，默认空，生成所有表</param>
        /// <param name="isMuti"></param>
        /// <returns></returns>
        public static bool CreateControllers(SqlSugarClient sqlSugarClient, string path, string ConnId = null, bool isMuti = false, string[] tableNames = null)
        {
            try
            {
                Create_Controller_ClassFileByDBTalbe(sqlSugarClient, ConnId, path, "Blog.Core.Api.Controllers", tableNames, "", isMuti);
                return true;
            }
            catch (Exception)
            {
                return false;
            }

        }

        /// <summary>
        /// 生成Dto层
        /// </summary>
        /// <param name="sqlSugarClient">sqlsugar实例</param>
        /// <param name="ConnId">数据库链接ID</param>
        /// <param name="tableNames">数据库表名数组，默认空，生成所有表</param>
        /// <param name="isMuti"></param>
        /// <returns></returns>
        public static bool CreateDto(SqlSugarClient sqlSugarClient, string path, string ConnId, bool isMuti = false, string[] tableNames = null)
        {

            try
            {
                Create_Dto_ClassFileByDBTalbe(sqlSugarClient, ConnId, path, "Blog.Core.Model.ViewModels", tableNames, "PageDto", isMuti);
                return true;
            }
            catch (Exception)
            {
                return false;
            }

        }

        /// <summary>
        /// 生成Model层
        /// </summary>
        /// <param name="sqlSugarClient">sqlsugar实例</param>
        /// <param name="ConnId">数据库链接ID</param>
        /// <param name="tableNames">数据库表名数组，默认空，生成所有表</param>
        /// <param name="isMuti"></param>
        /// <returns></returns>
        public static bool CreateModels(SqlSugarClient sqlSugarClient, string path, string ConnId, bool isMuti = false, string[] tableNames = null)
        {

            try
            {
                Create_Model_ClassFileByDBTalbe(sqlSugarClient, ConnId, path, "Blog.Core.Model.Models", tableNames, "BaseEntity", isMuti);
                return true;
            }
            catch (Exception)
            {
                return false;
            }

        }

        /// <summary>
        /// 生成IRepository层
        /// </summary>
        /// <param name="sqlSugarClient">sqlsugar实例</param>
        /// <param name="ConnId">数据库链接ID</param>
        /// <param name="isMuti"></param>
        /// <param name="tableNames">数据库表名数组，默认空，生成所有表</param>
        /// <returns></returns>
        public static bool CreateIRepositorys(SqlSugarClient sqlSugarClient, string path, string ConnId, bool isMuti = false, string[] tableNames = null)
        {

            try
            {
                Create_IRepository_ClassFileByDBTalbe(sqlSugarClient, ConnId, path, "Blog.Core.IRepository", tableNames, "", isMuti);
                return true;
            }
            catch (Exception)
            {
                return false;
            }

        }



        /// <summary>
        /// 生成 IService 层
        /// </summary>
        /// <param name="sqlSugarClient">sqlsugar实例</param>
        /// <param name="ConnId">数据库链接ID</param>
        /// <param name="isMuti"></param>
        /// <param name="tableNames">数据库表名数组，默认空，生成所有表</param>
        /// <returns></returns>
        public static bool CreateIServices(SqlSugarClient sqlSugarClient, string path, string ConnId, bool isMuti = false, string[] tableNames = null)
        {

            try
            {
                Create_IServices_ClassFileByDBTalbe(sqlSugarClient, ConnId, path, "Blog.Core.IServices", tableNames, "", isMuti);
                return true;
            }
            catch (Exception)
            {
                return false;
            }

        }



        /// <summary>
        /// 生成 Repository 层
        /// </summary>
        /// <param name="sqlSugarClient">sqlsugar实例</param>
        /// <param name="ConnId">数据库链接ID</param>
        /// <param name="isMuti"></param>
        /// <param name="tableNames">数据库表名数组，默认空，生成所有表</param>
        /// <returns></returns>
        public static bool CreateRepository(SqlSugarClient sqlSugarClient, string path, string ConnId, bool isMuti = false, string[] tableNames = null)
        {

            try
            {
                Create_Repository_ClassFileByDBTalbe(sqlSugarClient, ConnId, path, "Blog.Core.Repository", tableNames, "", isMuti);
                return true;
            }
            catch (Exception)
            {
                return false;
            }

        }



        /// <summary>
        /// 生成 Service 层
        /// </summary>
        /// <param name="sqlSugarClient">sqlsugar实例</param>
        /// <param name="ConnId">数据库链接ID</param>
        /// <param name="isMuti"></param>
        /// <param name="tableNames">数据库表名数组，默认空，生成所有表</param>
        /// <returns></returns>
        public static bool CreateServices(SqlSugarClient sqlSugarClient, string path, string ConnId, bool isMuti = false, string[] tableNames = null)
        {

            try
            {
                Create_Services_ClassFileByDBTalbe(sqlSugarClient, ConnId, path, "Blog.Core.Services", tableNames, "", isMuti);
                return true;
            }
            catch (Exception)
            {
                return false;
            }

        }



        #region 根据数据库生产ViewQuery
        /// <summary>
        /// 功能描述:根据数据库表生产ViewQuery
        /// 作　　者:Blog.Core
        /// </summary>
        /// <param name="sqlSugarClient"></param>
        /// <param name="ConnId">数据库链接ID</param>
        /// <param name="strPath">实体类存放路径</param>
        /// <param name="strNameSpace">命名空间</param>
        /// <param name="lstTableNames">生产指定的表</param>
        /// <param name="strInterface">实现接口</param>
        /// <param name="isMuti"></param>
        /// <param name="blnSerializable">是否序列化</param>
        /// <param name="templete">vue模板</param>
        private static void Create_View_ClassFileByDBTalbe(
          SqlSugarClient sqlSugarClient,
          string ConnId,
          string strPath,
          string strNameSpace,
          string[] lstTableNames,
          string strInterface,
          bool isMuti = false,
          bool blnSerializable = false,
          string templete = "")
        {
            var IDbFirst = sqlSugarClient.DbFirst;
            var currentPath = Path.GetDirectoryName(Path.GetDirectoryName(Path.GetDirectoryName(Path.GetDirectoryName(AppDomain.CurrentDomain.BaseDirectory + "..") + "..") + "..") + "..");
            string html = FileHelper.ReadFile(Path.Combine(currentPath, "Html", templete));
            if (lstTableNames != null && lstTableNames.Length > 0)
            {
                IDbFirst = IDbFirst.Where(lstTableNames);
            }
            var ls = IDbFirst.IsCreateDefaultValue().IsCreateAttribute()

                 .SettingClassTemplate(p => p = html)

                  .ToClassStringList(strNameSpace);

            Dictionary<string, string> newdic = new Dictionary<string, string>();
            //循环处理 首字母小写 并插入新的 Dictionary
            foreach (KeyValuePair<string, string> item in ls)
            {
                var columns = GetColumns(item.Key.ToString(), sqlSugarClient);
                var dataForm = GetDataForm(item.Key.ToString(), sqlSugarClient);
                var elform = GetElform(item.Key.ToString(), sqlSugarClient);
                string camelName = item.Key.First().ToString().ToLower() + item.Key.Substring(1);
                string newkey = "_" + camelName;
                string newvalue = item.Value.Replace("#LowerClassName", camelName).Replace("#columns", columns).Replace("#dataForm", dataForm).Replace("#elform", elform);
                newdic.Add(item.Key, newvalue);
            }
            CreateFilesByClassStringList(newdic, strPath, "{0}", ".vue");
        }
        #endregion

        #region 根据数据库生产JS
        /// <summary>
        /// 功能描述:根据数据库表生产JS
        /// 作　　者:Blog.Core
        /// </summary>
        /// <param name="sqlSugarClient"></param>
        /// <param name="ConnId">数据库链接ID</param>
        /// <param name="strPath">实体类存放路径</param>
        /// <param name="strNameSpace">命名空间</param>
        /// <param name="lstTableNames">生产指定的表</param>
        /// <param name="strInterface">实现接口</param>
        /// <param name="isMuti"></param>
        /// <param name="blnSerializable">是否序列化</param>
        private static void Create_JS_ClassFileByDBTalbe(
          SqlSugarClient sqlSugarClient,
          string ConnId,
          string strPath,
          string strNameSpace,
          string[] lstTableNames,
          string strInterface,
          bool isMuti = false,
          bool blnSerializable = false)
        {
            var IDbFirst = sqlSugarClient.DbFirst;
            if (lstTableNames != null && lstTableNames.Length > 0)
            {
                IDbFirst = IDbFirst.Where(lstTableNames);
            }
            var ls = IDbFirst.IsCreateDefaultValue().IsCreateAttribute()

                 .SettingClassTemplate(p => p =
@"import axios from '@/http/axios'
// 保存
export const save = (data) => {
    return axios({
        url: '/Lower{ClassName}/save',
        method: 'post',
        data
    })
}
// 删除
export const batchDelete = (data) => {
    return axios({
        url: '/Lower{ClassName}/delete',
        method: 'post',
        data
    })
}
// 分页查询
export const findPage = (data) => {
    return axios({
        url: '/Lower{ClassName}/findPage',
        method: 'post',
        data
    })
}

export const getAllList = () => {
    return axios({
        url: '/Lower{ClassName}/getAllList',
        method: 'post'
    })
}")

                  .ToClassStringList(strNameSpace);

            Dictionary<string, string> newdic = new Dictionary<string, string>();
            //循环处理 首字母小写 并插入新的 Dictionary
            foreach (KeyValuePair<string, string> item in ls)
            {
                string camelName = item.Key.First().ToString().ToLower() + item.Key.Substring(1);
                string newkey = "_" + camelName;
                string newvalue = item.Value.Replace("_" + item.Key, newkey).Replace("Lower" + item.Key, camelName);
                newdic.Add(item.Key, newvalue);
            }
            CreateFilesByClassStringList(newdic, strPath, "{0}", ".js");
        }
        #endregion

        #region 根据数据库表生产Controller层
        /// <summary>
        /// 功能描述:根据数据库表生产Controller层
        /// 作　　者:Blog.Core
        /// </summary>
        /// <param name="sqlSugarClient"></param>
        /// <param name="ConnId">数据库链接ID</param>
        /// <param name="strPath">实体类存放路径</param>
        /// <param name="strNameSpace">命名空间</param>
        /// <param name="lstTableNames">生产指定的表</param>
        /// <param name="strInterface">实现接口</param>
        /// <param name="isMuti"></param>
        /// <param name="blnSerializable">是否序列化</param>
        private static void Create_Controller_ClassFileByDBTalbe(
          SqlSugarClient sqlSugarClient,
          string ConnId,
          string strPath,
          string strNameSpace,
          string[] lstTableNames,
          string strInterface,
          bool isMuti = false,
          bool blnSerializable = false)
        {
            var IDbFirst = sqlSugarClient.DbFirst;
            if (lstTableNames != null && lstTableNames.Length > 0)
            {
                IDbFirst = IDbFirst.Where(lstTableNames);
            }
            var ls = IDbFirst.IsCreateDefaultValue().IsCreateAttribute()

                 .SettingClassTemplate(p => p =
@"using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Blog.Core.Common.HttpContextUser;
using Blog.Core.IServices;
using Blog.Core.Model;
using Blog.Core.Model.Models;
using Blog.Core.Model.ViewModels;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using System.Linq.Expressions;

namespace " + strNameSpace + @"
{
	[Route(""{ClassName}"")]
    [ApiController]
    [Authorize]
     public class {ClassName}Controller : ControllerBase
    {
         private readonly I{ClassName}Services _{ClassName}Services;
         readonly IUser _user;
         public {ClassName}Controller(I{ClassName}Services Lower{ClassName}Services, IUser user)
         {
            _{ClassName}Services = Lower{ClassName}Services;
            _user = user;
         }
            
         /// <summary>
         /// 查询
         /// </summary>
         /// <param name=""dto""></param>
         /// <returns></returns>
         ///  Post: {ClassName}
         [HttpPost, Route(""FindPage"")]  
         public async Task<BaseResult> FindPage([FromBody]{ClassName}Dto dto)
         {
            Expression<Func<{ClassName}, bool>> whereExpression = a => true;
            if (dto.name.IsNotEmptyOrNull())
            {
                whereExpression = ExpressionHelp.And(whereExpression, a => a.name.Contains(dto.name));
            }
            var data = await _{ClassName}Services.QueryPage(whereExpression, dto.pageNum, dto.pageSize, "" createTime desc "");
            return BaseResult.Ok(data);
         } 
        /// <summary>
        /// 添加
        /// </summary>
        /// <param name=""model""></param>
        /// <returns></returns>
        ///  POST: {ClassName}
        [HttpPost, Route(""Save"")]
        public async Task<BaseResult> Save([FromBody]{ClassName} model)
        {
            if (model.Id == 0)
            {
                model.Id = await _{ClassName}Services.GetId();
                model.CreateTime = DateTime.Now;
                model.CreateBy = _user.Name;
                model.LastUpdateBy = _user.Name;
                model.LastUpdateTime = DateTime.Now;
                return BaseResult.Ok(await _{ClassName}Services.Add(model));                   
            }
            else
            {
                model.LastUpdateBy = _user.Name;
                model.LastUpdateTime = DateTime.Now;
                return BaseResult.Ok(await _{ClassName}Services.Update(model));
            }
        }
        /// <summary>
        /// 删除
        /// </summary>
        /// <param name=""modelList""></param>
        /// <returns></returns>
        [HttpPost, Route(""Delete"")]
        public async Task<BaseResult> Delete([FromBody]List<{ClassName}> modelList)
        {
            foreach (var model in modelList)
            {
                await _{ClassName}Services.Delete(model);
            }
            return BaseResult.Ok(""ok"");
        }
        /// <summary>
        /// 查询全部
        /// </summary>
        /// <returns></returns>
        [HttpPost, Route(""GetAllList"")]
        public async Task<BaseResult> GetAllList()
        {
            return BaseResult.Ok(await _{ClassName}Services.Query());
        }
    }   
}")

                  .ToClassStringList(strNameSpace);

            Dictionary<string, string> newdic = new Dictionary<string, string>();
            //循环处理 首字母小写 并插入新的 Dictionary
            foreach (KeyValuePair<string, string> item in ls)
            {
                string camelName = item.Key.First().ToString().ToLower() + item.Key.Substring(1);
                string newkey = "_" + camelName;
                string newvalue = item.Value.Replace("_" + item.Key, newkey).Replace("Lower" + item.Key, camelName);
                newdic.Add(item.Key, newvalue);
            }
            CreateFilesByClassStringList(newdic, strPath, "{0}Controller");
        }
        #endregion

        #region 根据数据库表生产Dto层

        /// <summary>
        /// 功能描述:根据数据库表生产Model层
        /// 作　　者:Blog.Core
        /// </summary>
        /// <param name="sqlSugarClient"></param>
        /// <param name="ConnId">数据库链接ID</param>
        /// <param name="strPath">实体类存放路径</param>
        /// <param name="strNameSpace">命名空间</param>
        /// <param name="lstTableNames">生产指定的表</param>
        /// <param name="strInterface">实现接口</param>
        /// <param name="isMuti"></param>
        /// <param name="blnSerializable">是否序列化</param>
        private static void Create_Dto_ClassFileByDBTalbe(
          SqlSugarClient sqlSugarClient,
          string ConnId,
          string strPath,
          string strNameSpace,
          string[] lstTableNames,
          string strInterface,
          bool isMuti = false,
          bool blnSerializable = false)
        {
            //多库文件分离
            if (isMuti)
            {
                strPath = strPath + @"\ViewModels\" + ConnId;
                strNameSpace = strNameSpace + "." + ConnId;
            }

            var IDbFirst = sqlSugarClient.DbFirst;
            if (lstTableNames != null && lstTableNames.Length > 0)
            {
                IDbFirst = IDbFirst.Where(lstTableNames);
            }
            var ls = IDbFirst.IsCreateDefaultValue().IsCreateAttribute()

                  .SettingClassTemplate(p => p =
@"using Blog.Core.Model.ViewModels.Base;
using SqlSugar;
using System;
namespace " + strNameSpace + @"
{
{ClassDescription}
    public class {ClassName}Dto" + (string.IsNullOrEmpty(strInterface) ? "" : (" : " + strInterface)) + @"
    {
        #PropertyName
    }
}")
                   .ToClassStringList(strNameSpace);
            Dictionary<string, string> newdic = new Dictionary<string, string>();
            //循环处理 首字母小写 并插入新的 Dictionary
            foreach (KeyValuePair<string, string> item in ls)
            {
                string modelHtml = GetDto(item.Key.ToString(), sqlSugarClient);
                string newvalue = item.Value.Replace("#PropertyName", modelHtml);
                newdic.Add(item.Key, newvalue);
            }
            CreateFilesByClassStringList(newdic, strPath, "{0}Dto");
        }
        #endregion

        #region 根据数据库表生产Model层

        /// <summary>
        /// 功能描述:根据数据库表生产Model层
        /// 作　　者:Blog.Core
        /// </summary>
        /// <param name="sqlSugarClient"></param>
        /// <param name="ConnId">数据库链接ID</param>
        /// <param name="strPath">实体类存放路径</param>
        /// <param name="strNameSpace">命名空间</param>
        /// <param name="lstTableNames">生产指定的表</param>
        /// <param name="strInterface">实现接口</param>
        /// <param name="isMuti"></param>
        /// <param name="blnSerializable">是否序列化</param>
        private static void Create_Model_ClassFileByDBTalbe(
          SqlSugarClient sqlSugarClient,
          string ConnId,
          string strPath,
          string strNameSpace,
          string[] lstTableNames,
          string strInterface,
          bool isMuti = false,
          bool blnSerializable = false)
        {
            //多库文件分离
            if (isMuti)
            {
                strPath = strPath + @"\Models\" + ConnId;
                strNameSpace = strNameSpace + "." + ConnId;
            }

            var IDbFirst = sqlSugarClient.DbFirst;
            if (lstTableNames != null && lstTableNames.Length > 0)
            {
                IDbFirst = IDbFirst.Where(lstTableNames);
            }
            var ls = IDbFirst.IsCreateDefaultValue().IsCreateAttribute()

                  .SettingClassTemplate(p => p =
@"using SqlSugar;
using System;
namespace " + strNameSpace + @"
{
{ClassDescription}
    public class {ClassName}" + (string.IsNullOrEmpty(strInterface) ? "" : (" : " + strInterface)) + @"
    {
        #PropertyName
    }
}")
                   .ToClassStringList(strNameSpace);
            Dictionary<string, string> newdic = new Dictionary<string, string>();
            //循环处理 首字母小写 并插入新的 Dictionary
            foreach (KeyValuePair<string, string> item in ls)
            {
                string modelHtml = GetModel(item.Key.ToString(), sqlSugarClient);
                string newvalue = item.Value.Replace("#PropertyName", modelHtml);
                newdic.Add(item.Key, newvalue);
            }
            CreateFilesByClassStringList(newdic, strPath, "{0}");
        }
        #endregion

        #region 根据数据库表生产IRepository层

        /// <summary>
        /// 功能描述:根据数据库表生产IRepository层
        /// 作　　者:Blog.Core
        /// </summary>
        /// <param name="sqlSugarClient"></param>
        /// <param name="ConnId">数据库链接ID</param>
        /// <param name="strPath">实体类存放路径</param>
        /// <param name="strNameSpace">命名空间</param>
        /// <param name="lstTableNames">生产指定的表</param>
        /// <param name="strInterface">实现接口</param>
        /// <param name="isMuti"></param>
        private static void Create_IRepository_ClassFileByDBTalbe(
          SqlSugarClient sqlSugarClient,
          string ConnId,
          string strPath,
          string strNameSpace,
          string[] lstTableNames,
          string strInterface,
          bool isMuti = false
            )
        {
            //多库文件分离
            if (isMuti)
            {
                strPath = strPath + @"\" + ConnId;
                strNameSpace = strNameSpace + "." + ConnId;
            }

            var IDbFirst = sqlSugarClient.DbFirst;
            if (lstTableNames != null && lstTableNames.Length > 0)
            {
                IDbFirst = IDbFirst.Where(lstTableNames);
            }
            var ls = IDbFirst.IsCreateDefaultValue().IsCreateAttribute()

                 .SettingClassTemplate(p => p =
@"using Blog.Core.IRepository.Base;
using Blog.Core.Model.Models" + (isMuti ? "." + ConnId + "" : "") + @";

namespace " + strNameSpace + @"
{
	/// <summary>
	/// I{ClassName}Repository
	/// </summary>	
    public interface I{ClassName}Repository : IBaseRepository<{ClassName}>" + (string.IsNullOrEmpty(strInterface) ? "" : (" , " + strInterface)) + @"
    {
    }
}")

                  .ToClassStringList(strNameSpace);
            CreateFilesByClassStringList(ls, strPath, "I{0}Repository");
        }
        #endregion

        #region 根据数据库表生产IServices层

        /// <summary>
        /// 功能描述:根据数据库表生产IServices层
        /// 作　　者:Blog.Core
        /// </summary>
        /// <param name="sqlSugarClient"></param>
        /// <param name="ConnId">数据库链接ID</param>
        /// <param name="strPath">实体类存放路径</param>
        /// <param name="strNameSpace">命名空间</param>
        /// <param name="lstTableNames">生产指定的表</param>
        /// <param name="strInterface">实现接口</param>
        /// <param name="isMuti"></param>
        private static void Create_IServices_ClassFileByDBTalbe(
          SqlSugarClient sqlSugarClient,
          string ConnId,
          string strPath,
          string strNameSpace,
          string[] lstTableNames,
          string strInterface,
          bool isMuti = false)
        {
            //多库文件分离
            if (isMuti)
            {
                strPath = strPath + @"\" + ConnId;
                strNameSpace = strNameSpace + "." + ConnId;
            }

            var IDbFirst = sqlSugarClient.DbFirst;
            if (lstTableNames != null && lstTableNames.Length > 0)
            {
                IDbFirst = IDbFirst.Where(lstTableNames);
            }
            var ls = IDbFirst.IsCreateDefaultValue().IsCreateAttribute()

                  .SettingClassTemplate(p => p =
@"using Blog.Core.IServices.BASE;
using Blog.Core.Model.Models" + (isMuti ? "." + ConnId + "" : "") + @";

namespace " + strNameSpace + @"
{	
	/// <summary>
	/// I{ClassName}Services
	/// </summary>	
    public interface I{ClassName}Services :IBaseServices<{ClassName}>" + (string.IsNullOrEmpty(strInterface) ? "" : (" , " + strInterface)) + @"
	{
    }
}")

                   .ToClassStringList(strNameSpace);
            CreateFilesByClassStringList(ls, strPath, "I{0}Services");
        }
        #endregion

        #region 根据数据库表生产 Repository 层

        /// <summary>
        /// 功能描述:根据数据库表生产 Repository 层
        /// 作　　者:Blog.Core
        /// </summary>
        /// <param name="sqlSugarClient"></param>
        /// <param name="ConnId">数据库链接ID</param>
        /// <param name="strPath">实体类存放路径</param>
        /// <param name="strNameSpace">命名空间</param>
        /// <param name="lstTableNames">生产指定的表</param>
        /// <param name="strInterface">实现接口</param>
        /// <param name="isMuti"></param>
        private static void Create_Repository_ClassFileByDBTalbe(
          SqlSugarClient sqlSugarClient,
          string ConnId,
          string strPath,
          string strNameSpace,
          string[] lstTableNames,
          string strInterface,
          bool isMuti = false)
        {
            //多库文件分离
            if (isMuti)
            {
                strPath = strPath + @"\" + ConnId;
                strNameSpace = strNameSpace + "." + ConnId;
            }

            var IDbFirst = sqlSugarClient.DbFirst;
            if (lstTableNames != null && lstTableNames.Length > 0)
            {
                IDbFirst = IDbFirst.Where(lstTableNames);
            }
            var ls = IDbFirst.IsCreateDefaultValue().IsCreateAttribute()

                  .SettingClassTemplate(p => p =
@"using Blog.Core.IRepository" + (isMuti ? "." + ConnId + "" : "") + @";
using Blog.Core.IRepository.UnitOfWork;
using Blog.Core.Model.Models" + (isMuti ? "." + ConnId + "" : "") + @";
using Blog.Core.Repository.Base;

namespace " + strNameSpace + @"
{
	/// <summary>
	/// {ClassName}Repository
	/// </summary>
    public class {ClassName}Repository : BaseRepository<{ClassName}>, I{ClassName}Repository" + (string.IsNullOrEmpty(strInterface) ? "" : (" , " + strInterface)) + @"
    {
        public {ClassName}Repository(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }
    }
}")
                  .ToClassStringList(strNameSpace);


            CreateFilesByClassStringList(ls, strPath, "{0}Repository");
        }
        #endregion

        #region 根据数据库表生产 Services 层

        /// <summary>
        /// 功能描述:根据数据库表生产 Services 层
        /// 作　　者:Blog.Core
        /// </summary>
        /// <param name="sqlSugarClient"></param>
        /// <param name="ConnId">数据库链接ID</param>
        /// <param name="strPath">实体类存放路径</param>
        /// <param name="strNameSpace">命名空间</param>
        /// <param name="lstTableNames">生产指定的表</param>
        /// <param name="strInterface">实现接口</param>
        /// <param name="isMuti"></param>
        private static void Create_Services_ClassFileByDBTalbe(
          SqlSugarClient sqlSugarClient,
          string ConnId,
          string strPath,
          string strNameSpace,
          string[] lstTableNames,
          string strInterface,
          bool isMuti = false)
        {
            //多库文件分离
            if (isMuti)
            {
                strPath = strPath + @"\" + ConnId;
                strNameSpace = strNameSpace + "." + ConnId;
            }

            var IDbFirst = sqlSugarClient.DbFirst;
            if (lstTableNames != null && lstTableNames.Length > 0)
            {
                IDbFirst = IDbFirst.Where(lstTableNames);
            }
            var ls = IDbFirst.IsCreateDefaultValue().IsCreateAttribute()

                  .SettingClassTemplate(p => p =
@"using Blog.Core.IRepository" + (isMuti ? "." + ConnId + "" : "") + @";
using Blog.Core.IServices" + (isMuti ? "." + ConnId + "" : "") + @";
using Blog.Core.Model.Models" + (isMuti ? "." + ConnId + "" : "") + @";
using Blog.Core.Services.BASE;

namespace " + strNameSpace + @"
{
    public partial class {ClassName}Services : BaseServices<{ClassName}>, I{ClassName}Services" + (string.IsNullOrEmpty(strInterface) ? "" : (" , " + strInterface)) + @"
    {
        private readonly I{ClassName}Repository _dal;
        public {ClassName}Services(I{ClassName}Repository dal)
        {
            this._dal = dal;
            base.BaseDal = dal;
        }
    }
}")
                  .ToClassStringList(strNameSpace);

            CreateFilesByClassStringList(ls, strPath, "{0}Services");
        }
        #endregion

        #region 根据模板内容批量生成文件
        /// <summary>
        /// 根据模板内容批量生成文件
        /// </summary>
        /// <param name="ls">类文件字符串list</param>
        /// <param name="strPath">生成路径</param>
        /// <param name="fileNameTp">文件名格式模板</param>
        /// <param name="fileType">文件名类型</param>
        private static void CreateFilesByClassStringList(Dictionary<string, string> ls, string strPath, string fileNameTp, string fileType = ".cs")
        {
            if (fileType == ".js")
            {
                foreach (var item in ls)
                {
                    string camelName = item.Key.First().ToString().ToLower() + item.Key.Substring(1);
                    var fileName = $"{string.Format(fileNameTp, camelName)}" + fileType;
                    var fileFullPath = Path.Combine(strPath, fileName);
                    if (!Directory.Exists(strPath))
                    {
                        Directory.CreateDirectory(strPath);
                    }
                    if (!File.Exists(fileFullPath))
                    {
                        File.WriteAllText(fileFullPath, item.Value);
                    }
                }
            }
            else
            {
                foreach (var item in ls)
                {
                    var fileName = $"{string.Format(fileNameTp, item.Key)}" + fileType;
                    var fileFullPath = Path.Combine(strPath, fileName);
                    if (!Directory.Exists(strPath))
                    {
                        Directory.CreateDirectory(strPath);
                    }
                    if (!File.Exists(fileFullPath))
                    {
                        File.WriteAllText(fileFullPath, item.Value);
                    }
                }
            }
        }
        #endregion

        #region 公用属性

        /// <summary>
        /// 获取#PropertyName
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="sqlSugarClient"></param>
        /// <returns></returns>
        private static string GetModel(string tableName, SqlSugarClient sqlSugarClient)
        {
            StringBuilder sb = new StringBuilder();
            foreach (var col in sqlSugarClient.DbMaintenance.GetColumnInfosByTableName(tableName))
            {
                if (col.DbColumnName.ToLower()=="id")
                {
                    continue;
                }
                var dateType = SqlToCsharpHelper.SqlToCsharp(col.DataType);
                sb.Append("///<summary>\n\t\t///");
                sb.Append(col.ColumnDescription + "\n\t\t");
                sb.Append("///</summary>\n\t\t");
                sb.Append("[SugarColumn(ColumnDataType = \"" + col.DataType + "\", Length = " + col.Length + ", IsNullable = " + col.IsNullable.ToString().ToLower() + ")]\n\t\t");
                sb.Append("public " + dateType + (col.IsNullable && dateType != "string" ? "?" : string.Empty) + " " + col.DbColumnName + " {get;set;}\n\t\t");
            }
            return sb.ToString();
        }

        /// <summary>
        /// 获取#PropertyName
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="sqlSugarClient"></param>
        /// <returns></returns>
        private static string GetDto(string tableName, SqlSugarClient sqlSugarClient)
        {
            StringBuilder sb = new StringBuilder();
            foreach (var col in sqlSugarClient.DbMaintenance.GetColumnInfosByTableName(tableName))
            {
                if (col.DbColumnName.ToLower() == "id")
                {
                    continue;
                }
                var dateType = SqlToCsharpHelper.SqlToCsharp(col.DataType);
                sb.Append("///<summary>\n\t\t///");
                sb.Append(col.ColumnDescription + "\n\t\t");
                sb.Append("///<summary>\n\t\t");
                sb.Append("public " + dateType + (col.IsNullable && dateType != "string" ? "?" : string.Empty) + " " + col.DbColumnName + " {get;set;}\n\t\t");
            }
            return sb.ToString();
        }

        /// <summary>
        /// 获取#columns
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="sqlSugarClient"></param>
        /// <returns></returns>
        private static string GetColumns(string tableName, SqlSugarClient sqlSugarClient)
        {
            StringBuilder sb = new StringBuilder();
            foreach (var col in sqlSugarClient.DbMaintenance.GetColumnInfosByTableName(tableName))
            {
                var camelColumn = col.DbColumnName.First().ToString().ToLower() + col.DbColumnName.Substring(1);
                sb.Append("{ prop: \"" + camelColumn + "\", label: \"" + col.ColumnDescription + "\", minWidth: 100},\n\t\t\t\t");
            }
            return sb.ToString();
        }

        /// <summary>
        /// 获取#dataForm
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="sqlSugarClient"></param>
        /// <returns></returns>
        private static string GetDataForm(string tableName, SqlSugarClient sqlSugarClient)
        {
            StringBuilder sb = new StringBuilder();
            foreach (var col in sqlSugarClient.DbMaintenance.GetColumnInfosByTableName(tableName))
            {
                var camelColumn = col.DbColumnName.First().ToString().ToLower() + col.DbColumnName.Substring(1);
                if (camelColumn == "id")
                {
                    sb.Append(camelColumn + ":0, \n\t\t\t\t");
                }
                else
                {
                    sb.Append(camelColumn + ":null, \n\t\t\t\t");
                }
            }
            return sb.ToString();
        }


        /// <summary>
        /// 获取#elform
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="sqlSugarClient"></param>
        /// <returns></returns>
        private static string GetElform(string tableName, SqlSugarClient sqlSugarClient)
        {
            StringBuilder sb = new StringBuilder();
            foreach (var col in sqlSugarClient.DbMaintenance.GetColumnInfosByTableName(tableName))
            {
                var camelColumn = col.DbColumnName.First().ToString().ToLower() + col.DbColumnName.Substring(1);
                sb.Append("<el-form-item label=\"" + col.ColumnDescription + "\" prop=\"" + camelColumn + "\"> \n \t\t\t\t");
                sb.Append("<el-input v-model=\"dataForm." + camelColumn + "\" auto-complete=\"off\"></el-input> \n\t\t\t");
                sb.Append("</el-form-item> \n\t\t\t");
            }
            return sb.ToString();
        }
        #endregion
    }
}
