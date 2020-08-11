using Dapper;
using GK.WCS.DAL.inter;
using GK.WCS.Entity.wcs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WCS.DAL.abs
{
    public class AbsDeviceInOrNotServer : AbsWCSBaseServer, IDeviceInOrOutServer
    {
    
        public int GetInOrNot(int plcId)
        {
            DeviceInOrOut deviceInOrOut;
            string sql = "select * from DeviceInOrNot where Id=@plcId";
            deviceInOrOut = Connection.Query<DeviceInOrOut>(sql, new { plcId = plcId }).FirstOrDefault();
            return deviceInOrOut.InOrOut;
        }

        public bool UpdateInOrNot(int plcId, int value)
        {
            string sql = "update DeviceInOrNot set InOrNot=@value where id=@plcId";
            int i = Connection.Execute(sql, new { value = value, plcId = plcId });
            if (i != 1)
            {
                return false;
            }
            else
            {
                return true;
            }
        }
    }
}
