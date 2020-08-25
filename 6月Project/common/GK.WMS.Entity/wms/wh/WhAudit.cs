using Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GK.WMS.Entity
{

    public class WhAudit : BaseEntity
    {
        public int auditType { get; set; }

        public long auditId { get; set; }

        public int status { get; set; }

        public string auditInfo { get; set; }

        public DateTime createDate { get; set; }

        public string auditer { get; set; }


    }
}