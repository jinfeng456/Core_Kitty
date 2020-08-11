using GK.Common.dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HY.WCS.DAL.dto
{
    public class UserDto : PageDto
    {
        public string account { get; set; }

        public string password { get; set; }

        public string name { get; set; }

    }
}