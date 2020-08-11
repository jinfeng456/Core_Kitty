using GK.Common.dto;
using GK.DAL.inter;
using GK.WMS.Entity;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security.AccessControl;
using System.Text;

namespace GK.WMS.DAL
{
    public interface ISysAuthorityServer : IBaseServer
    {
        #region 角色
        Page<SysRole> QueryRolePage<SysRole>(RoleDto dto);
        long AddRole(SysRole model);

        bool UpdateRole(SysRole model);

        int DeleteRole(List<SysRole> modelList);

        SysRole FindRoleById(long id);

        List<SysRole> FindRoleByName(string name);

        List<SysRole> FindAllRole();

        List<SysMenu> FindRoleMenus(long roleId);
        List<SysRole> FindUserRole(long roluserIdeId);
        int SaveRoleMenus(List<SysRoleMenu> modelList);

        #endregion

        #region 菜单
        List<SysMenu> FindAllMenu();
        long AddMenu(SysMenu model);
        bool UpdateMenu(SysMenu model);
        int DeleteMenu(List<SysMenu> modelList);

        List<SysMenu> FindTree(string userName, int menuType);

        List<SysMenu> FindByUser(String userName);

        #endregion

        #region 用户

        Page<SysUserQuery> QueryUserPage<SysUserQuery>(UserDto dto);
        List<SysUser> GetUser(string loginName);
        List<SysUser> GetUser(string loginName, string password);
        long AddUser(SysUser user);
        bool UpdateUser(SysUser user);

        int DeleteUser(List<SysUser> userList);

        SysUser FindUserById(long id);
        object GetAllList();
        string UpdateUserPassWord(string passWord,string oldWorld);
        string UpdateCheckPassWord(string passWord, string oldWorld);

        string GetCodeByName(string name);
        #endregion

        #region 字典
        //字典
        Page<SysDictQuery> QueryDictsPage(DictsDto dto);

        List<DictRes> GetDicts();

        //字典分类
        Page<SysDictClass> QueryDictClassPage<SysDictClass>(DictClassDto dto);
        long AddDictClass(SysDictClass model);
        bool UpdateDictClass(SysDictClass model);
        int DeleteDictClass(List<SysDictClass> userList);
        #endregion
    }
}
