//----------SysRoleMenu开始----------



using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Blog.Core.Common;
using Blog.Core.Common.HttpContextUser;
using Blog.Core.IRepository;
using Blog.Core.IRepository.UnitOfWork;
using Blog.Core.IServices;
using Blog.Core.Model.Models;
using Blog.Core.Services.BASE;
namespace Blog.Core.Services
{
    /// <summary>
    /// SysRoleMenuServices
    /// </summary>	
    public class SysRoleMenuServices : BaseServices<SysRoleMenu>, ISysRoleMenuServices
    {

        ISysRoleMenuRepository dal;
        IUser userDal;
        public SysRoleMenuServices(ISysRoleMenuRepository dal, IUser userDal)
        {
            this.dal = dal;
            base.BaseDal = dal;
            this.userDal = userDal;
        }

        public async Task<int> SaveRoleMenus(List<SysRoleMenu> modelList)
        {
            if (modelList == null || modelList.Count == 0)
            {
                return 0;
            }
            int roleId = modelList[0].roleId;
            await dal.Delete(a => a.roleId == roleId);
            foreach (var model in modelList)
            {
                model.id = dal.GetId();
                model.createTime = DateTime.Now;
                model.createBy = userDal.Name;
                model.lastUpdateBy = userDal.Name;
                model.lastUpdateTime = DateTime.Now;
            }
            return await dal.Add(modelList);

        }

    }
}

//----------SysRoleMenu结束----------
