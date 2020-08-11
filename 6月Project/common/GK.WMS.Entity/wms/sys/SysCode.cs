using GK.Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GK.WMS.Entity
{

    public class SysCode : BaseEntity
    {
        public string tableName { get; set; }

        public string serialPrefix { get; set; }

        public string tableDescription { get; set; }

        public int? businessType { get; set; }

        public int? codeNumber { get; set; }

        public DateTime codeDate { get; set; }

    }
}