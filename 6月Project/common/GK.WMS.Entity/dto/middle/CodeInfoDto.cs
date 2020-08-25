using Common.dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.FMXT.DAL.dto
{
    public class CodeInfoDto : PageDto
    {
        public string barCode { get; set; }
        public string parentCode { get; set; }

        public CodeInfoDto() { }
    }
}
