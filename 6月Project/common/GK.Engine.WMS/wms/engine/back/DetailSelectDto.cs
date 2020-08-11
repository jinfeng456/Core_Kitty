using GK.WMS.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.Engine.WMS.wms.stockOut {
   public class DetailSelectDto :IComparable<DetailSelectDto>{
        public  List<CoreStockDetail> selected;
        public DetailSelectDto() {
            selected = new List<CoreStockDetail>();
        }
        private DetailSelectDto(List<CoreStockDetail> list) {
            selected = list;
        }


        public void add(CoreStockDetail detail) {
            selected.Add(detail);
        }
        public DetailSelectDto Clone() {//浅克隆
            return new DetailSelectDto(new List<CoreStockDetail>(selected));
        }

        public int CompareTo(DetailSelectDto other) {
            return getCount() - other.getCount();
        }

        public int getCount() {
           return  selected.Count();
        }
    }
}
