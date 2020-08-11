using GK.WCS.Carrier;
using GK.WCS.Common;
using GK.WCS.DAL;
using GK.WCS.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WCS.Controller
{
    public class CarrierDirection : ZtTask
    {
        ITaskCarrierServer taskCarrierServer = ServerFactray.getServer<ITaskCarrierServer>();
        ITaskCraneServer taskCraneServer = ServerFactray.getServer<ITaskCraneServer>();
        CarrierConnect connect;
        public override void excute()
        {
            changeDir();
        }
        public void changeDir()
        {
            List<TaskCrane> outTaskCranes=taskCraneServer.getAllOutCraneTask();
            List<TaskCarrier> outTaskCarriers = taskCarrierServer.getAllOutCarrirerTask();
            List<TaskCrane> inTaskCranes=taskCraneServer.getAllInCraneTask();
            List<TaskCarrier> inTaskCarriers=taskCarrierServer.getAllInCarrirerTask();
            if ((outTaskCranes.Count!=0 || outTaskCarriers.Count!=0)&&inTaskCarriers.Count==0&&inTaskCranes.Count==0)
            {
                int dir = connect.getCarrierDir(4);
                if (dir == 1)
                {
                     connect.changeCarrierDir( 4, 2);
                }

            }
            else
            {
                int dir = connect.getCarrierDir(4);
                if (dir == 2)
                {
                    connect.changeCarrierDir(4, 1);
                }
            }


        }
    }
}
