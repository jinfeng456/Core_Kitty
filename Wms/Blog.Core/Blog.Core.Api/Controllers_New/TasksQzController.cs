using System;
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

namespace Blog.Core.Controllers
{
	 ///<summary>
	 ///TasksQz
	 ///</summary>
     [Route("TasksQz")]
     [ApiController]
     [Authorize]
	 public class TasksQzController : ControllerBase
	 {
		readonly ITasksQzServices _tasksQzServices;
        readonly IUser _user;
		public TasksQzController(ITasksQzServices tasksQzServices, IUser user)
        {
            _tasksQzServices = tasksQzServices;
            _user = user;
        }

		/// <summary>
        /// 查询
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        // GET: api/User
        [HttpPost, Route("FindPage")]
        public async Task<BaseResult> FindPage([FromBody]TasksQzDto dto)
        {
            Expression<Func<TasksQz, bool>> whereExpression = a => true;
            if (dto.name.IsNotEmptyOrNull())
            {
                whereExpression = ExpressionHelp.And(whereExpression, a => a.name.Contains(dto.name));
            }
            var data = await _tasksQzServices.QueryPage(whereExpression, dto.pageNum, dto.pageSize, " createTime desc ");
            return BaseResult.Ok(data);
        }

        /// <summary>
        /// 添加
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        // POST: api/User
        [HttpPost, Route("Save")]
        public async Task<BaseResult> Save([FromBody]TasksQz model)
        {
            if (model.Id == 0)
            {
                model.Id = await _tasksQzServices.GetId();
                model.CreateTime = DateTime.Now;
                model.CreateBy = _user.Name;
                model.LastUpdateBy = _user.Name;
                model.LastUpdateTime = DateTime.Now;
                return BaseResult.Ok(await _tasksQzServices.Add(model));
            }
            else
            {
                model.LastUpdateBy = _user.Name;
                model.LastUpdateTime = DateTime.Now;
                return BaseResult.Ok(await _tasksQzServices.Update(model));
            }
        }


        /// <summary>
        /// 删除
        /// </summary>
        /// <param name="modelList"></param>
        /// <returns></returns>
        [HttpPost, Route("Delete")]
        public async Task<BaseResult> Delete([FromBody]List<TasksQz> modelList)
        {
            foreach (var model in modelList)
            {
                await _tasksQzServices.Delete(model);
            }
            return BaseResult.Ok("ok");
        }

        /// <summary>
        /// 查询全部
        /// </summary>
        /// <returns></returns>
        [HttpPost, Route("GetAllList")]
        public async Task<BaseResult> GetAllList()
        {
            return BaseResult.Ok(await _tasksQzServices.Query());
        }
	 }
}	 
