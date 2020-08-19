using Blog.Core.IRepository;
using Blog.Core.IServices;
using Blog.Core.Model.Models;
using Blog.Core.Services.BASE;

namespace Blog.Core.Services
{
    public partial class CoreClassifyServices : BaseServices<CoreClassify>, ICoreClassifyServices
    {
        private readonly ICoreClassifyRepository _dal;
        public CoreClassifyServices(ICoreClassifyRepository dal)
        {
            this._dal = dal;
            base.BaseDal = dal;
        }
    }
}