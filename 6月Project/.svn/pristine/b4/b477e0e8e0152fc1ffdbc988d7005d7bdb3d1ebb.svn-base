using GK.WMS.DAL;
using GK.WMS.Entity;
using HY.WCS.DAL.dto;
using System.Collections.Generic;
using System.Web.Http;
using Web.Authorize;
namespace WebApi
{	
	/// <summary>
	/// SysCodeController
	/// </summary>	
	[FormAuthenticationFilter]
	[RoutePrefix("sysCode")]
	public class SysCodeController : BaseApiController
    {
	    ISysCodeServer sysCodeServer = WMSDalFactray.getDal<ISysCodeServer>();
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();

        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]SysCodeDto dto)
        {
            var info = sysCodeServer.QuerySysCodePage(dto);          
            return  BaseResult.Ok(info);
        }

        [HttpPost, Route("Save"), ControlName("字典删除")]
        public BaseResult Save([FromBody]SysCode model)
        {        
            if (model.id == 0)
            {             
                model.id = sequenceIdServer.getId();             
                return  BaseResult.Ok(sysCodeServer.insertNotNull(model));
            }
            else
            {                    
                return  BaseResult.Ok(sysCodeServer.updateNotNull(model));
            }
        }

        [HttpPost, Route("Delete"), ControlName("字典删除")]
        public BaseResult Delete([FromBody]List<SysCode> modelList)
        {
            foreach (var item in modelList)
            {
                sysCodeServer.delete<SysCode>(item.id);
            }
            return  BaseResult.Ok("1");
        }

        [HttpPost, Route("GetAllList")]
        public BaseResult GetAllList( )
        {         
            return  BaseResult.Ok(sysCodeServer.GetAllList());
        }
       
    }
}

	