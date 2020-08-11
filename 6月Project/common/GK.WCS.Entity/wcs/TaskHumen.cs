using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WCS.Entity
{
    [Serializable]
    public  class TaskHumen:BaseTask {
		public TaskHumen()
		{}
        override public List<String> getLableData() {
            List<String> list = base.getLableData();
      
            list.Add("类型：" + Type);
            list.Add("编码：" + boxCode);

            return list;
        }

        public ushort Type
        {
            get; set;
        }
       public String boxCode
        {
            get; set;
        }

    }
}
