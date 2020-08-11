	//----------SysRole开始----------
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Blog.Core.Common;
using Blog.Core.IRepository;
using Blog.Core.IRepository.UnitOfWork;
using Blog.Core.IServices;
using Blog.Core.Model.Models;
using Blog.Core.Services.BASE;
using SqlSugar;

namespace Blog.Core.Services
{	
	/// <summary>
	/// SysRoleServices
	/// </summary>	
	public class SysRoleServices : BaseServices<SysRole>, ISysRoleServices
    {
	
        ISysRoleRepository dal;
        public SysRoleServices(ISysRoleRepository dal)
        {
            this.dal = dal;
            base.BaseDal = dal;
        }

        public async Task<List<SysRole>> FindUserRole(long userId)
        {
            string sql = @"SELECT r.* FROM dbo.sysUserRole ur,dbo.sysRole r 
                                                WHERE ur.roleId = r.id
                                                AND ur.userIds = @userIds";
            return await dal.QuerySql(sql, new SugarParameter[] { new SugarParameter("@userIds", userId) });
        }

        
    }
}

	//----------SysRole结束----------
	