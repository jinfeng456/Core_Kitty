	//----------CoreItem开始----------
    

using Blog.Core.IServices.BASE;
using Blog.Core.Model.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Blog.Core.IServices
{
    /// <summary>
    /// CoreItemServices
    /// </summary>	
    public interface ICoreItemServices : IBaseServices<CoreItem>
    {
        bool ImportList(List<CoreItem> coreItemList, out string message);
    }
}

	//----------CoreItem结束----------
	