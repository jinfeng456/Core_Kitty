using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Entity;

namespace GK.WMS.Entity
{

    public class SysUser : WmsEntity
    {
        public string name { get; set; }
        public string passwords { get; set; }
        public string salt { get; set; }
        public string email { get; set; }
        public string mobile { get; set; }
        public int? userstatus { get; set; }
        public string deptId { get; set; }
        public int? delFlag { get; set; }
        public string code { get; set; }

        public string auditPassword { get; set; }

        public List<SysUserRole> userRoles;

    }
}