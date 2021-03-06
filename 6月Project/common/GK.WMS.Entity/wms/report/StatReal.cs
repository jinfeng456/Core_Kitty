using Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
namespace GK.WMS.Entity
{
	 ///<summary>
	 ///StatReal
	 ///</summary>
	 public class StatReal : BaseEntity
	 {

		 /// <summary>
        /// 月份
        /// </summary>
		public int? month { get; set; }
	
		 /// <summary>
        /// 物料主键
        /// </summary>
		public long? itemId { get; set; }
	
		 /// <summary>
        /// 批次主键
        /// </summary>
		public long? batchId { get; set; }
	
		 /// <summary>
        /// 批次号
        /// </summary>
		public string wmsBanchNo { get; set; }
	
		/// <summary>
        /// 单据类型
        /// </summary>
		public int? forword { get; set; }
	
		 /// <summary>
        /// 数量
        /// </summary>
		public int? count { get; set; }
	
		 /// <summary>
        /// 结存
        /// </summary>
		public int? remain { get; set; }
	
		 /// <summary>
        /// 来源/去向
        /// </summary>
		public string sourceWhither { get; set; }
	
		 /// <summary>
        /// 单位
        /// </summary>
		public string unit { get; set; }
	
		 /// <summary>
        /// 明细主键
        /// </summary>
		public long? receiptDetailId { get; set; }
	
		 /// <summary>
        /// 物料名称
        /// </summary>
		public string itemName { get; set; }
	
		 /// <summary>
        /// 物料编码
        /// </summary>
		public string itemCode { get; set; }
	
		 /// <summary>
        /// 规格
        /// </summary>
		public string modelSpecs { get; set; }
	
		 /// <summary>
        /// 包装规格
        /// </summary>
		public string packageSpecs { get; set; }
	
		 /// <summary>
        /// 操作时间
        /// </summary>
		public DateTime? opTime { get; set; }
	 
	 }
} 

	