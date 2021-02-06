using SqlSugar;


namespace Blog.Core.Model.Models
{
    ///<summary>
    ///
    ///</summary>
    [SugarTable( "CoreClassify")]
    public class CoreClassify : BaseEntity
    {

        [SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
        public string name { get; set; }

        [SugarColumn(ColumnDataType = "nvarchar", Length = 255, IsNullable = true)]
        public string info { get; set; }

        [SugarColumn(ColumnDataType = "int", IsNullable = true)]
        public int? stockWidth { get; set; }

        [SugarColumn(ColumnDataType = "int", IsNullable = true)]
        public int? stockHigh { get; set; }

        [SugarColumn(ColumnDataType = "int", IsNullable = true)]
        public int? stockDeep { get; set; }
    }
}