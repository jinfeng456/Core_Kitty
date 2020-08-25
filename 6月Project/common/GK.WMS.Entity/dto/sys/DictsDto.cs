using Common.dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HY.WCS.DAL.dto
{
    public class DictsDto : PageDto
    {
        public string label { get; set; }

        public string dictClassId { get; set; }
    }
}