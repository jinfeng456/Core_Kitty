using GK.WMS.Entity;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Dapper;
using System.Data.SqlClient;
using HY.WCS.DAL.dto;
using System.Configuration;
using System.ComponentModel;
using WebApi.util;
using WMS.DAL;
using Common.dto;
using Common;

namespace GK.WMS.DAL.abs
{
    public abstract class AbsSysAuthorityServer : AbsWMSBaseServer, ISysAuthorityServer
    {
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();

        #region 角色
        public Page<SysRole> QueryRolePage<SysRole>(RoleDto dto)
        {
            string sql = "select * from sys_Role where 1=1 ";
            if (!string.IsNullOrEmpty(dto.name))
            {
                sql += " AND name = @name ";
            }
            return this.queryPage<SysRole>(sql, "id", dto);
        }
        public long AddRole(SysRole model)
        {
            model.id = sequenceIdServer.getId();
            model.createTime = sequenceIdServer.GetTime();
            model.createBy = CookieHelper.LoginName();
            model.lastUpdateBy = CookieHelper.LoginName();
            model.lastUpdateTime = DateTime.Now;
            return Connection.Insert<SysRole>(model);
        }
        public bool UpdateRole(SysRole model)
        {
            model.lastUpdateBy = CookieHelper.LoginName();
            model.lastUpdateTime = sequenceIdServer.GetTime();
            return Connection.Update<SysRole>(model);
        }
        public int DeleteRole(List<SysRole> modelList)
        {
            foreach (var model in modelList)
            {
                Connection.Delete<SysRole>("id=" + model.id.ToString());
            }
            return 1;
        }

        public SysRole FindRoleById(long id)
        {
            return Connection.Get<SysRole>(id);
        }

        public List<SysRole> FindRoleByName(string name)
        {
            return Connection.Query<SysRole>("select * from sys_role where name=@name", new { name = name }).ToList();
        }
        public List<SysRole> FindAllRole()
        {
            return Connection.Query<SysRole>("select * from sys_role").ToList();

        }

        public List<SysMenu> FindRoleMenus(long roleId)
        {
            //限制了管理员的权限不允许修改，开发中先注释
            //SysRole sysRole = FindRoleById(roleId);
            //if (sysRole != null && sysRole.name.Equals("admin"))
            //{
            //    // 如果是超级管理员，返回全部
            //    return FindAllMenu();
            //}
            return Connection.Query<SysMenu>(@"select m.* from sys_menu m, sys_role_menu rm
                                                where rm.role_id = @role_id
                                                and m.id = rm.menu_id", new { role_id = roleId }).ToList();
        }
        public List<SysRole> FindUserRole(long userId)
        {
            return Connection.Query<SysRole>(@"SELECT r.* FROM dbo.sys_user_role ur,dbo.sys_role r 
                                                WHERE ur.role_id = r.id
                                                AND ur.user_ids = @user_ids", new { user_ids = userId }).ToList();
        }

        public int SaveRoleMenus(List<SysRoleMenu> modelList)
        {
            if (modelList == null || modelList.Count == 0)
            {
                return 1;
            }
            long roleId = modelList[0].roleId;
            DeleteByRoleId(roleId);
            foreach (var model in modelList)
            {
                model.id = sequenceIdServer.getId();
                model.createTime = sequenceIdServer.GetTime();
                model.createBy = CookieHelper.LoginName();
                model.lastUpdateBy = CookieHelper.LoginName();
                model.lastUpdateTime = DateTime.Now;
                Connection.Insert<SysRoleMenu>(model);             
            }
            //Connection.Execute("Insert into sys_role_menu(id, create_Time, create_By, last_Update_By,last_Update_Time,role_Id,menu_Id) values(@id, @createTime, @createBy, @lastUpdateBy,@lastUpdateTime,@roleId,@menuId)", modelList);
            return 1;
        }

        public bool DeleteByRoleId(long roleId)
        {
            return Connection.Delete<SysRoleMenu>("role_id=" + roleId);
        }
        #endregion

        #region 菜单
        public List<SysMenu> FindAllMenu()
        {
            return Connection.Query<SysMenu>("select * from sys_menu").ToList();

        }

        public long AddMenu(SysMenu model)
        {
            model.id = sequenceIdServer.getId();
            model.createTime = sequenceIdServer.GetTime();
            model.createBy = CookieHelper.LoginName();
            model.lastUpdateBy = CookieHelper.LoginName();
            model.lastUpdateTime = DateTime.Now;
            return Connection.InsertNoNull<SysMenu>(model);
        }
        public bool UpdateMenu(SysMenu model)
        {
            model.lastUpdateBy = model.name;
            model.lastUpdateTime = sequenceIdServer.GetTime();
            return Connection.Update<SysMenu>(model);
        }

        public int DeleteMenu(List<SysMenu> modelList)
        {
            foreach (var model in modelList)
            {
                Connection.Delete<SysMenu>("id=" + model.id.ToString());
            }
            return 1;
        }

        public List<SysMenu> FindTree(string userName, int menuType)
        {
            List<SysMenu> sysMenus = new List<SysMenu>();
            List<SysMenu> menus = FindByUser(userName);
            foreach (var menu in menus)
            {
                if (menu.parentId == 0)
                {
                    menu.level = 0;
                    if (!Exists(sysMenus, menu))
                    {
                        sysMenus.Add(menu);
                    }
                }
            }
            sysMenus.Sort((a, b) => a.orderNum.CompareTo(b.orderNum));
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
                    if (menuType == 1 && menu.dtype == 2)
                    {
                        // 如果是获取类型不需要按钮，且菜单类型是按钮的，直接过滤掉
                        continue;
                    }
                    if (sysMenu.id.Equals(menu.parentId))
                    {
                        menu.parentName = sysMenu.name;
                        menu.level = sysMenu.level + 1;
                        if (!Exists(children, menu))
                        {
                            children.Add(menu);
                        }
                    }
                }
                sysMenu.children = children;
                children.Sort((a, b) => a.orderNum.CompareTo(b.orderNum));
                FindChildren(children, menus, menuType);
            }
        }
        public List<SysMenu> FindByUser(String userName)
        {
            if (string.IsNullOrEmpty(userName))
            {
                return FindAll();
            }
            return FindByUserName(userName);
        }
        /// <summary>
        /// 根据用户名查询菜单
        /// </summary>
        /// <returns></returns>
        public List<SysMenu> FindByUserName(string userName)
        {
            String sql = @"select m.* from sys_menu m, sys_user u, sys_user_role ur, sys_role_menu rm
	                       where u.name = @name and u.id = ur.user_ids
  	                       and ur.role_id = rm.role_id and rm.menu_id = m.id";
            return Connection.Query<SysMenu>(sql, new { name = userName }).ToList();
        }
        /// <summary>
        /// 查询所有菜单信息
        /// </summary>
        public List<SysMenu> FindAll()
        {
            string sql = @"select * from sys_menu ";
            return Connection.Query<SysMenu>(sql).ToList();
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
        #endregion

        #region 用户
        public List<SysUser> GetUser(string name)
        {
            String sql = "select * from sys_user where name=@name";
            return Connection.Query<SysUser>(sql, new { name = name }).ToList();
        }

        public List<SysUser> GetUser(string name, string password)
        {
            String sql = "select * from sys_user where name=@name and passwords=@password";
            return Connection.Query<SysUser>(sql, new { name = name, password = password }).ToList();
        }

        public Page<SysUserQuery> QueryUserPage<SysUserQuery>(UserDto dto)
        {
            string sql = @"select u.*,a.remark as roleNames from sys_user u
                        left outer join 
                        (select ur.user_ids,r.remark from  sys_role r,sys_user_role ur
                        where r.id = ur.role_id) a 
                        on u.id=a.user_ids where 1=1";
            if (!string.IsNullOrEmpty(dto.name))
            {
                sql += " AND u.name = @name ";
            }
            return this.queryPage<SysUserQuery>(sql, "id", dto);
        }

        public long AddUser(SysUser model)
        {
            model.id = sequenceIdServer.getId();
            model.createTime = sequenceIdServer.GetTime();
            model.createBy = model.name;
            model.lastUpdateBy = model.name;
            model.lastUpdateTime = DateTime.Now;
            model.passwords = GKMD5.MD5Encrypt("123456");
            model.auditPassword = GKMD5.MD5Encrypt("123456");
            return Connection.Insert<SysUser>(model);
        }
        public bool UpdateUser(SysUser model)
        {
            model.lastUpdateBy = model.name;
            model.lastUpdateTime = sequenceIdServer.GetTime();
            model.passwords = null;
            model.auditPassword =null;
            Connection.updateNotNull<SysUser>(model);
            DeleteByUserId(model.id);
            foreach (var item in model.userRoles)
            {
                item.id = sequenceIdServer.getId();
                item.createTime = sequenceIdServer.GetTime();
                item.createBy = model.name;
                item.lastUpdateBy = model.name;
                item.lastUpdateTime = DateTime.Now;
                item.userIds = model.id;
                Connection.Insert<SysUserRole>(item);
            }
            return true;
        }
        public bool DeleteByUserId(long userId)
        {
            return Connection.Delete<SysUserRole>("user_ids=" + userId);
        }

        public int DeleteUser(List<SysUser> userList)
        {
            foreach (var user in userList)
            {
                Connection.Delete<SysUser>("id=" + user.id.ToString());
            }
            return 1;
        }

        public SysUser FindUserById(long id)
        {
            return Connection.Get<SysUser>(id);
        }
        public string UpdateUserPassWord(string passWord, string oldWorld)
        {
            string useName = CookieHelper.LoginName();
            string passwords = GKMD5.MD5Encrypt(passWord);
            string sql1 = "select * from sys_user where name=@useName";
            SysUser sysUser = Connection.Query<SysUser>(sql1, new { useName = useName }).FirstOrDefault();
            oldWorld = GKMD5.MD5Encrypt(oldWorld);
            if (oldWorld != sysUser.passwords)
            {
                return "与原始密码不一致";
            }
            string sql = "update sys_user set passwords=@passwords where name=@useName";
            Connection.Execute(sql, new { passwords = passwords, useName = useName });
            return "与原始密码一致";
        }
        public string UpdateCheckPassWord(string passWord, string oldWorld)
        {
            string useName = CookieHelper.LoginName();
            string passwords = GKMD5.MD5Encrypt(passWord);
            string sql1 = "select * from sys_user where name=@useName";
            SysUser sysUser = Connection.Query<SysUser>(sql1, new { useName = useName }).FirstOrDefault();
            oldWorld = GKMD5.MD5Encrypt(oldWorld);
            if (oldWorld != sysUser.auditPassword)
            {
                return "与原始密码不一致";
            }
            string sql = "update sys_user set audit_Password=@passwords where name=@useName";
            Connection.Execute(sql, new { passwords = passwords, useName = useName });
            return "与原始密码一致";
        }

        public string GetCodeByName(string name)
        {
            string sql = "select * from sys_user where name=@name";
            string code = Connection.Query<SysUser>(sql, new { name = name }).FirstOrDefault().code;         
            return code;
        }
        #endregion

        #region 字典
        //字典
        public Page<SysDictQuery> QueryDictsPage(DictsDto dto)
        {
            string sql = @"select A.*,B.dict_class_name from sys_dict A LEFT OUTER JOIN sys_dict_class B ON A.dict_class_id = B.id where 1=1";
            if (!string.IsNullOrEmpty(dto.label))
            {
                dto.label = "%" + dto.label + "%";
                sql += " AND label like @label ";
            }
            if (!string.IsNullOrEmpty(dto.dictClassId))
            {
                sql += " AND dict_Class_Id = @dictClassId ";
            }
            return this.queryPage<SysDictQuery>(sql, "id", dto);
        }

        public long AddDicts(SysDict model)
        {
            if (model.dictClassId != 0)
            {
                model.dtype = getById<SysDictClass>(model.dictClassId).dictClassName;
            }
            model.id = sequenceIdServer.getId();
            model.createTime = sequenceIdServer.GetTime();
            model.createBy = CookieHelper.LoginName();
            model.lastUpdateBy = CookieHelper.LoginName();
            model.lastUpdateTime = DateTime.Now;
            return Connection.Insert<SysDict>(model);
        }
        public bool UpdateDicts(SysDict model)
        {
            if (model.dictClassId != 0)
            {
                model.dtype = getById<SysDictClass>(model.dictClassId).dictClassName;
            }
            model.lastUpdateBy = CookieHelper.LoginName();
            model.lastUpdateTime = sequenceIdServer.GetTime();
            Connection.Update<SysDict>(model);
            return true;
        }
   

        //字典分类
        public Page<SysDictClass> QueryDictClassPage<SysDictClass>(DictClassDto dto)
        {
            string sql = @"select * from sys_dict_class where 1=1";
            if (dto != null && !string.IsNullOrEmpty(dto.dictClassName))
            {
                sql += " AND dict_class_name = @dictClassName ";
            }
            return this.queryPage<SysDictClass>(sql, "id", dto);
        }
        public List<DictRes> GetDicts()
        {
            string sql = @"select [value] ,[label]  ,[dtype] from sys_dict";

            return Connection.Query<DictRes>(sql).ToList();
        }
        public object GetAllList()
        {
            string sql = @"select * from sys_dict_class";

            return Connection.Query<SysDictClass>(sql).ToList();
        }

        public long AddDictClass(SysDictClass model)
        {
            model.id = sequenceIdServer.getId();
            model.createTime = sequenceIdServer.GetTime();
            model.createBy = CookieHelper.LoginName();
            model.lastUpdateBy = CookieHelper.LoginName();
            model.lastUpdateTime = DateTime.Now;
            return Connection.Insert<SysDictClass>(model);
        }
        public bool UpdateDictClass(SysDictClass model)
        {
            model.lastUpdateBy = CookieHelper.LoginName();
            model.lastUpdateTime = sequenceIdServer.GetTime();
            Connection.Update<SysDictClass>(model);
            return true;
        }

        public int DeleteDictClass(List<SysDictClass> modelList)
        {
            foreach (var item in modelList)
            {
                Connection.Delete<SysDict>("id=" + item.id.ToString());
            }
            return 1;
        }


        #endregion

    }
}
