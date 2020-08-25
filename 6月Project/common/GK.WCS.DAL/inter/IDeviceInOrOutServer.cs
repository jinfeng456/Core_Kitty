using Common.DAL.inter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WCS.DAL.inter
{
    public interface IDeviceInOrOutServer : IBaseServer
    {
        int GetInOrNot(int plcId);

        bool UpdateInOrNot(int plcId , int value);
    }
}
