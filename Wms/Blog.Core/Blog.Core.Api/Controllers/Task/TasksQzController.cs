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
using Blog.Core.Tasks;

namespace Blog.Core.Controllers
{
    ///<summary>
    ///TasksQz
    ///</summary>
    [Route("TasksQz")]
    [Authorize]
    public class TasksQzController1 : ControllerBase
    {
        readonly ITasksQzServices _tasksQzServices;
        private readonly ISchedulerCenter _schedulerCenter;
        readonly IUser _user;
        public TasksQzController1(ITasksQzServices tasksQzServices, IUser user, ISchedulerCenter schedulerCenter)
        {
            _tasksQzServices = tasksQzServices;
            _schedulerCenter = schedulerCenter;
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
            if (string.IsNullOrEmpty(dto.Name) || string.IsNullOrWhiteSpace(dto.Name))
            {
                dto.Name = "";
            }
            var data = await _tasksQzServices.QueryPage(a => (a.Name != null && a.Name.Contains(dto.Name)), dto.pageNum, dto.pageSize, " createTime desc ");
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
                return BaseResult.Ok(await _tasksQzServices.Add(model));
            }
            else
            {
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

        /// <summary>
        /// 启动计划任务
        /// </summary>
        /// <param name="jobId"></param>
        /// <returns></returns>
        [HttpGet, Route("StartJob")] ///{jobId?}
        public async Task<MessageModel<string>> StartJob(int jobId)
        {
            var data = new MessageModel<string>();

            var model = await _tasksQzServices.QueryById(jobId);
            if (model == null)
            {
                return data;
            }
            var ResuleModel = await _schedulerCenter.AddScheduleJobAsync(model);
            if (!ResuleModel.success)
            {
                return ResuleModel;
            }
            model.IsStart = true;
            data.success = await _tasksQzServices.Update(model);
            if (data.success)
            {
                data.msg = "启动成功";
                data.response = jobId.ObjToString();
            }
            return data;
        }
        /// <summary>
        /// 停止一个计划任务
        /// </summary>
        /// <param name="jobId"></param>
        /// <returns></returns>        
        [HttpGet, Route("StopJob")]
        public async Task<MessageModel<string>> StopJob(int jobId)
        {
            var data = new MessageModel<string>();

            var model = await _tasksQzServices.QueryById(jobId);
            if (model != null)
            {
                var ResuleModel = await _schedulerCenter.StopScheduleJobAsync(model);
                if (ResuleModel.success)
                {
                    model.IsStart = false;
                    data.success = await _tasksQzServices.Update(model);
                }
                if (data.success)
                {
                    data.msg = "暂停成功";
                    data.response = jobId.ObjToString();
                }
            }
            return data;

        }
        /// <summary>
        /// 重启一个计划任务
        /// </summary>
        /// <param name="jobId"></param>
        /// <returns></returns>
        [HttpGet, Route("ReCovery")]
        public async Task<MessageModel<string>> ReCovery(int jobId)
        {
            var data = new MessageModel<string>();

            var model = await _tasksQzServices.QueryById(jobId);
            if (model != null)
            {
                var ResuleModel = await _schedulerCenter.ResumeJob(model);
                if (ResuleModel.success)
                {
                    model.IsStart = true;
                    data.success = await _tasksQzServices.Update(model);
                }
                if (data.success)
                {
                    data.msg = "重启成功";
                    data.response = jobId.ObjToString();
                }
            }
            return data;

        }
    }
}
