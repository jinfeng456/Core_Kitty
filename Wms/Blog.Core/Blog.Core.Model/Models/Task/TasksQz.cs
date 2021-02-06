using SqlSugar;
using System;

namespace Blog.Core.Model.Models
{
    /// <summary>
    /// 任务计划表
    /// </summary>
    public class TasksQz : RootEntity
    {
		///<summary>
		///任务名称
		///</summary>
		[SugarColumn(ColumnDataType = "nvarchar", Length = 400, IsNullable = true)]
		public string Name { get; set; }
		///<summary>
		///任务分组
		///</summary>
		[SugarColumn(ColumnDataType = "nvarchar", Length = 400, IsNullable = true)]
		public string JobGroup { get; set; }
		///<summary>
		///时间表达式
		///</summary>
		[SugarColumn(ColumnDataType = "nvarchar", Length = 400, IsNullable = true)]
		public string Cron { get; set; }
		///<summary>
		///程序集名称
		///</summary>
		[SugarColumn(ColumnDataType = "nvarchar", Length = 400, IsNullable = true)]
		public string AssemblyName { get; set; }
		///<summary>
		///任务所在类
		///</summary>
		[SugarColumn(ColumnDataType = "nvarchar", Length = 400, IsNullable = true)]
		public string ClassName { get; set; }
		///<summary>
		///任务描述
		///</summary>
		[SugarColumn(ColumnDataType = "nvarchar", Length = 2000, IsNullable = true)]
		public string Remark { get; set; }
		///<summary>
		///执行次数
		///</summary>
		[SugarColumn(ColumnDataType = "int", Length = 4, IsNullable = false)]
		public int RunTimes { get; set; }
		///<summary>
		///开始时间
		///</summary>
		[SugarColumn(ColumnDataType = "datetime", Length = 8, IsNullable = false)]
		public DateTime? BeginTime { get; set; }
		///<summary>
		///结束时间
		///</summary>
		[SugarColumn(ColumnDataType = "datetime", Length = 8, IsNullable = false)]
		public DateTime? EndTime { get; set; }
		///<summary>
		///触发器类型
		///</summary>
		[SugarColumn(ColumnDataType = "int", Length = 4, IsNullable = false)]
		public int TriggerType { get; set; }
		///<summary>
		///执行间隔时间
		///</summary>
		[SugarColumn(ColumnDataType = "int", Length = 4, IsNullable = false)]
		public int IntervalSecond { get; set; }
		///<summary>
		///是否启动
		///</summary>
		[SugarColumn(ColumnDataType = "bit", Length = 1, IsNullable = false)]
		public bool IsStart { get; set; }
		///<summary>
		///执行传参
		///</summary>
		[SugarColumn(ColumnDataType = "varchar", Length = 255, IsNullable = false)]
		public string JobParams { get; set; }
		///<summary>
		///IsDeleted
		///</summary>
		[SugarColumn(ColumnDataType = "bit", Length = 1, IsNullable = true)]
		public bool? IsDeleted { get; set; }
		///<summary>
		///创建时间
		///</summary>
		[SugarColumn(ColumnDataType = "datetime", Length = 8, IsNullable = true)]
		public DateTime? CreateTime { get; set; }
	}
}
