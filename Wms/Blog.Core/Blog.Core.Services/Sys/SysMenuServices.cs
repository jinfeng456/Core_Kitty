//----------SysMenu开始----------



using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Blog.Core.Common.HttpContextUser;
using Blog.Core.IRepository;
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
        ISysRoleMenuRepository roleMenuDal;
        IUser _user;
        public SysMenuServices(ISysMenuRepository dal, ISysRoleMenuRepository roleMenuDal, IUser user)
        {
            this.dal = dal;
            base.BaseDal = dal;
            this.roleMenuDal = roleMenuDal;
            _user = user;
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

        public async Task<bool> AddPermission(string[] tableNames = null)
        {
            try
            {
                foreach (var name in tableNames)
                {
                    var sysMenu = await dal.Query(a => a.Name == name);
                    if (sysMenu.Count > 0)
                    {
                        continue;
                    }
                    string camelName = GetCamelName(name);
                    //菜单(默认生成在系统菜单下面)
                    SysMenu model = new SysMenu();
                    model.id = await dal.GetId();
                    model.Name = name;
                    model.ParentId = 1;
                    model.Url = "/Test/" + name;
                    model.Dtype = 1;
                    model.Icon = "el-icon-edit-outline";
                    model.OrderNum = 50;
                    model.CreateTime = DateTime.Now;
                    model.CreateBy = _user.Name;
                    model.LastUpdateBy = _user.Name;
                    model.LastUpdateTime = DateTime.Now;
                    await dal.Add(model);
                    SysRoleMenu roleMenu = new SysRoleMenu();
                    roleMenu.id = await roleMenuDal.GetId();
                    roleMenu.RoleId = 1;
                    roleMenu.MenuId = model.id;
                    roleMenu.CreateTime = DateTime.Now;
                    roleMenu.CreateBy = _user.Name;
                    roleMenu.LastUpdateBy = _user.Name;
                    roleMenu.LastUpdateTime = DateTime.Now;
                    await roleMenuDal.Add(roleMenu);
                    //按钮
                    for (int i = 0; i < 4; i++)
                    {
                        string buttonName = i == 0 ? "查看" : i == 1 ? "新增" : i == 2 ? "修改" : "删除";
                        string perms = i == 0 ? "sys:" + camelName + ":view" : i == 1 ? "sys:" + camelName + ":add" : i == 2 ? "sys:" + camelName + ":edit" : "sys:" + camelName + ":delete";
                        SysMenu button = new SysMenu();
                        button.id = await dal.GetId();
                        button.Name = buttonName;
                        button.ParentId = model.id;
                        button.Perms = perms;
                        button.Dtype = 2;
                        button.OrderNum = i + 1;
                        button.CreateTime = DateTime.Now;
                        button.CreateBy = _user.Name;
                        button.LastUpdateBy = _user.Name;
                        button.LastUpdateTime = DateTime.Now;
                        await dal.Add(button);
                        SysRoleMenu buttonRoleMenu = new SysRoleMenu();
                        buttonRoleMenu.id = await roleMenuDal.GetId();
                        buttonRoleMenu.RoleId = 1;
                        buttonRoleMenu.MenuId = button.id;
                        buttonRoleMenu.CreateTime = DateTime.Now;
                        buttonRoleMenu.CreateBy = _user.Name;
                        buttonRoleMenu.LastUpdateBy = _user.Name;
                        buttonRoleMenu.LastUpdateTime = DateTime.Now;
                        await roleMenuDal.Add(buttonRoleMenu);
                    }
                }
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }
        private static string GetCamelName(string name)
        {
            return name.First().ToString().ToLower() + name.Substring(1);
        }
    }
}

//----------SysMenu结束----------
