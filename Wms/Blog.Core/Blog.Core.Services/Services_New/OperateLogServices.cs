using Blog.Core.IRepository;
using Blog.Core.IServices;
using Blog.Core.Model.Models;
using Blog.Core.Services.BASE;

namespace Blog.Core.Services
{
    public partial class OperateLogServices : BaseServices<OperateLog>, IOperateLogServices
    {
        private readonly IOperateLogRepository _dal;
        public OperateLogServices(IOperateLogRepository dal)
        {
            this._dal = dal;
            base.BaseDal = dal;
        }
    }
}