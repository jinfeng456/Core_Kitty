using Blog.Core.Model.ViewModels.Base;

namespace Blog.Core.Model.ViewModels
{
    public class SysUserDto : PageDto
    {
        public string account { get; set; }

        public string password { get; set; }

        public string name { get; set; }

    }
}