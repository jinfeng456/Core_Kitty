using GK.Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WMS.Entity
{
    public class CoreSupplierCorp : BaseEntity
    {
        public string name
        {
            get; set;
        }
        public string editable
        {
            get; set;
        }
        public string code
        {
            get; set;
        }
        public string ncId
        {
            get; set;
        }

        public string address
        {
            get; set;
        }

    }
}
