//----------SysMenu开始----------



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
    /// SysMenuServices
    /// </summary>	
    public class SysMenuServices : BaseServices<SysMenu>, ISysMenuServices
    {

        ISysMenuRepository dal;
        public SysMenuServices(ISysMenuRepository dal)
        {
            this.dal = dal;
            base.BaseDal = dal;
        }



        public async Task<List<SysMenu>> FindTree(string userName, int menuType)
        {
            List<SysMenu> sysMenus=new List<SysMenu>();
            List<SysMenu> menus = await FindByUser(userName);
            foreach (var menu in menus)
            {
                if (menu.ParentId == 0)
                {
                    menu.Level = 0;
                    if (!Exists(sysMenus, menu))
                    {
                        sysMenus.Add(menu);
                    }
                }
            }
            sysMenus.Sort((a, b) => a.OrderNum.CompareTo(b.OrderNum));
            FindChildren(sysMenus, menus, menuType);
            return sysMenus;
        }

        private void FindChildren(List<SysMenu> SysMenus, List<SysMenu> menus, int menuType)
        {
            foreach (var sysMenu in SysMenus)
            {
                List<SysMenu> children = new List<SysMenu>();
                foreach (var menu in menus)
                {
                    if (menuType == 1 && menu.Dtype == 2)
                    {
                        // 如果是获取类型不需要按钮，且菜单类型是按钮的，直接过滤掉
                        continue;
                    }
                    if (sysMenu.id.Equals(menu.ParentId))
                    {
                        menu.ParentName = sysMenu.Name;
                        menu.Level = sysMenu.Level + 1;
                        if (!Exists(children, menu))
                        {
                            children.Add(menu);
                        }
                    }
                }
                sysMenu.Children = children;
                children.Sort((a, b) => a.OrderNum.CompareTo(b.OrderNum));
                FindChildren(children, menus, menuType);
            }
        }

        private bool Exists(List<SysMenu> sysMenus, SysMenu sysMenu)
        {
            bool exist = false;
            foreach (var menu in sysMenus)
            {
                if (menu.id.Equals(sysMenu.id))
                {
                    exist = true;
                }
            }
            return exist;
        }

        public async Task<List<SysMenu>> FindByUser(string userName)
        {
            if (string.IsNullOrEmpty(userName))
            {
                return await dal.Query();
            }
            return await FindByUserName(userName);
        }

        public async Task<List<SysMenu>> FindByUserName(string userName)
        {
            string sql = @"select m.* from sysMenu m, sysUser u, sysUserRole ur, sysRoleMenu rm
	                       where u.name = @name and u.id = ur.userIds
  	                       and ur.roleId = rm.roleId and rm.menuId = m.id";
            return await dal.QuerySql(sql,new SugarParameter []{ new SugarParameter("@name", userName) });
        }

        public async Task<List<SysMenu>> FindRoleMenus(long roleId)
        {
            string sql = @"select m.* from sysMenu m, sysRoleMenu rm
                                                where rm.roleId = @roleId
                                                and m.id = rm.menuId";
            return await dal.QuerySql(sql, new SugarParameter[] { new SugarParameter("@roleId", roleId)});          
        }
    }
}

//----------SysMenu结束----------
