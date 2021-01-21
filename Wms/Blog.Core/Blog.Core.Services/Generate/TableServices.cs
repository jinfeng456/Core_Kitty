//----------SysMenu开始----------



using System.Collections.Generic;
using System.Threading.Tasks;
using Blog.Core.IRepository;
using Blog.Core.IServices;
using Blog.Core.Model.Models;
using Blog.Core.Model.Models.Generate;
using Blog.Core.Services.BASE;
using SqlSugar;

namespace Blog.Core.Services
{
    /// <summary>
    /// SysMenuServices
    /// </summary>	
    public class TableServices : BaseServices<TableName>, ITableServices
    {

        ITableRepository dal;
        public TableServices(ITableRepository dal)
        {
            this.dal = dal;
            base.BaseDal = dal;
        }




        public async Task<List<TableName>> FindTables()
        {
            string sql = @"select * from sysobjects where xtype='U'";
            return await dal.QuerySql(sql);
        }  
    }
}

//----------SysMenu结束----------
