using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Entity;

namespace GK.WMS.Entity
{

    public class SysMenu : WmsEntity
    {
        public long parentId { get; set; }

        public string name { get; set; }

        public string url { get; set; }

        public string perms { get; set; }

        public int dtype { get; set; }

        public string icon { get; set; }

        public int orderNum { get; set; }

        public int delFlag { get; set; }

        // 非数据库字段
        public string parentName;
        // 非数据库字段
        public int level;
        // 非数据库字段
        public List<SysMenu> children;


    }
}