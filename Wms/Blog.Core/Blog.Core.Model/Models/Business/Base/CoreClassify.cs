using System;
using System.Linq;
using System.Text;
using SqlSugar;


namespace Blog.Core.Model.Models
{
    ///<summary>
    ///
    ///</summary>
    [SugarTable( "CoreClassify")]
    public class CoreClassify : BaseEntity
    {       

           public string name { get; set; }

           public string info { get; set; }

           public int? stockWidth { get; set; }

           public int? stockHigh { get; set; }

           public int? stockDeep { get; set; }
    }
}