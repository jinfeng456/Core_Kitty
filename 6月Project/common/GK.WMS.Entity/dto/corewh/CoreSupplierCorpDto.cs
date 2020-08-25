using Common.dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HY.WCS.DAL.dto
{
    public class CoreSupplierCorpDto : PageDto
    {
       // public long id { get; set; }
        public string name { get; set; }

        public string code { get; set; }

        public string editable { get; set; }
        public string ncId { get; set;}

    }
}