using SqlSugar;

namespace Blog.Core.Model
{
    public class BaseEntity
    {
        /// <summary>
        /// ID
        /// </summary>
        [SugarColumn(IsNullable = false, IsPrimaryKey = true)] //, IsIdentity = true
        public int id { get; set; }


    }
}