//----------CoreItem开始----------


using Blog.Core.Controllers;
using Blog.Core.IServices.BASE;
using Blog.Core.Model;
using Blog.Core.Model.Models;
using SqlSugar;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Blog.Core.IServices
{
    /// <summary>
    /// CoreItemServices
    /// </summary>	
    public interface ICoreItemServices : IBaseServices<CoreItem>
    {
       Task<bool> ImportList(List<CoreItem> coreItemList, RefAsync<string> message);

    }
}

//----------CoreItem结束----------
