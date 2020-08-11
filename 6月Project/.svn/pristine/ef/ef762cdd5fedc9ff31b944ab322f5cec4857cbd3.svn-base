using GK.Common.dto;
using GK.WCS.Entity;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace GK.WCS.DAL.abs
{
    public abstract class AbsPhysicalLocationServer : AbsWCSBaseServer, IPhysicalLocationServer

    {
        public Page<PhysicalLocation> queryPhysicalLocationPage<PhysicalLocation>( int start, int end, PageDto param )
        {
           
           string sql = "physical_Location";
           string orderBy = "id";
           return  this.queryPage<PhysicalLocation>(sql, orderBy, param);
            
        }

    }
}
