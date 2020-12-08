using Blog.Core.Model.ViewModels.Base;
using System;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///TasksQz
	 ///</summary>
	 public class TasksQzDto : PageDto
	 {
		/// <summary>
        /// 任务名称
        /// </summary>
		public string Name { get; set; }
		/// <summary>
        /// 任务分组
        /// </summary>
		public string JobGroup { get; set; }
		/// <summary>
        /// 时间表达式
        /// </summary>
		public string Cron { get; set; }
		/// <summary>
        /// 程序集名称
        /// </summary>
		public string AssemblyName { get; set; }
		/// <summary>
        /// 任务所在类
        /// </summary>
		public string ClassName { get; set; }
		/// <summary>
        /// 任务描述
        /// </summary>
		public string Remark { get; set; }
		/// <summary>
        /// 执行次数
        /// </summary>
		public int RunTimes { get; set; }
		/// <summary>
        /// 开始时间
        /// </summary>
		public DateTime BeginTime { get; set; }
		/// <summary>
        /// 结束时间
        /// </summary>
		public DateTime EndTime { get; set; }
		/// <summary>
        /// 触发器类型
        /// </summary>
		public int TriggerType { get; set; }
		/// <summary>
        /// 执行间隔时间
        /// </summary>
		public int IntervalSecond { get; set; }
		/// <summary>
        /// 是否启动
        /// </summary>
		public bool IsStart { get; set; }
		/// <summary>
        /// 执行传参
        /// </summary>
		public string JobParams { get; set; }
		/// <summary>
        /// IsDeleted
        /// </summary>
		public bool? IsDeleted { get; set; }
		/// <summary>
        /// 创建时间
        /// </summary>
		public DateTime? CreateTime { get; set; }
	 
	 }
}	 
