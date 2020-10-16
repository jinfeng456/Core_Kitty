using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Blog.Core.Model.Models
{
	 ///<summary>
	 ///TasksQz
	 ///</summary>
	 [Table("TasksQz")]	
	 public class TasksQz
	 {
	 
		 /// <summary>
        /// Id
        /// </summary>
		[Key]
		[Required]
		public int Id { get; set; }
	
		 /// <summary>
        /// Name
        /// </summary>
		public string Name { get; set; }
	
		 /// <summary>
        /// JobGroup
        /// </summary>
		public string JobGroup { get; set; }
	
		 /// <summary>
        /// Cron
        /// </summary>
		public string Cron { get; set; }
	
		 /// <summary>
        /// AssemblyName
        /// </summary>
		public string AssemblyName { get; set; }
	
		 /// <summary>
        /// ClassName
        /// </summary>
		public string ClassName { get; set; }
	
		 /// <summary>
        /// Remark
        /// </summary>
		public string Remark { get; set; }
	
		 /// <summary>
        /// RunTimes
        /// </summary>
		[Required]
		public int RunTimes { get; set; }
	
		 /// <summary>
        /// BeginTime
        /// </summary>
		[Required]
		public DateTime BeginTime { get; set; }
	
		 /// <summary>
        /// EndTime
        /// </summary>
		[Required]
		public DateTime EndTime { get; set; }
	
		 /// <summary>
        /// TriggerType
        /// </summary>
		[Required]
		public int TriggerType { get; set; }
	
		 /// <summary>
        /// IntervalSecond
        /// </summary>
		[Required]
		public int IntervalSecond { get; set; }
	
		 /// <summary>
        /// IsStart
        /// </summary>
		[Required]
		public bool IsStart { get; set; }
	
		 /// <summary>
        /// JobParams
        /// </summary>
		[Required]
		public string JobParams { get; set; }
	
		 /// <summary>
        /// IsDeleted
        /// </summary>
		public bool? IsDeleted { get; set; }
	
		 /// <summary>
        /// CreateTime
        /// </summary>
		public DateTime? CreateTime { get; set; }
	 
	 }
}	 
