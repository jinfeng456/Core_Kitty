using Blog.Core.IRepository;
using Blog.Core.IServices;
using Blog.Core.Model.Models;
using Blog.Core.Services.BASE;

namespace Blog.Core.Services
{
    public partial class CoreItemServices : BaseServices<CoreItem>, ICoreItemServices
    {
        private readonly ICoreItemRepository _dal;
        public CoreItemServices(ICoreItemRepository dal)
        {
            this._dal = dal;
            base.BaseDal = dal;
        }
    }
}