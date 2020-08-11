using GK.Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
namespace GK.WMS.Entity
{
	 ///<summary>
	 ///StatMonth
	 ///</summary>
	 public class StatMonth : BaseEntity
	 {
	 
		 /// <summary>
        /// 主键
        /// </summary>
		public long id { get; set; }
	
		 /// <summary>
        /// 月份
        /// </summary>
		public int? month { get; set; }
	
		 /// <summary>
        /// 物料主键
        /// </summary>
		public long? itemId { get; set; }
	
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
        /// 单位
        /// </summary>
		public string unit { get; set; }
	
		 /// <summary>
        /// 期初数量
        /// </summary>
		public int? lastRemain { get; set; }
	
		 /// <summary>
        /// 出库数量
        /// </summary>
		public int? outCount { get; set; }
	
		 /// <summary>
        /// 入库数量
        /// </summary>
		public int? inCount { get; set; }
	
		 /// <summary>
        /// 结存数量
        /// </summary>
		public int? remain { get; set; }


		/// <summary>
		/// 物料类型
		/// </summary>
		public int? coreItemType { get; set; }

	}
} 

	