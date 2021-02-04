using Blog.Core.Model.ViewModels.Base;
using SqlSugar;
using System;
namespace Blog.Core.Model.ViewModels
{
    ///<summary>
    ///
    ///</summary>
    public class OperateLogDto : PageDto
    {
                   //主键
           [SugarColumn(IsPrimaryKey=true)]
           public int Id { get; set; }
           //是否删除
           public bool? IsDeleted { get; set; }
           //区域名
           public string Area { get; set; }
           //区域控制器名
           public string Controller { get; set; }
           //Action名称
           public string Action { get; set; }
           //IP地址
           public string IPAddress { get; set; }
           //描述
           public string Description { get; set; }
           //登录时间
           public DateTime? LogTime { get; set; }
           //登录名称
           public string LoginName { get; set; }
           //用户ID
           public int UserId { get; set; }
    }
}