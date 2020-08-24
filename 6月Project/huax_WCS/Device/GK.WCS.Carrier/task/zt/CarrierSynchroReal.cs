


using GK.WCS.Carrier;
using GK.WCS.Carrier.dto;
using GK.WCS.Common.task;
using System.Collections.Generic;

namespace GK.WCS.Carrier
{
    public class CarrierSynchro1 : DYGCarrierSynchro
    {
        //一楼左
        protected CarrierConnect connect1 = null;
        public CarrierSynchro1()
        {
            connect1 = TaskPool.get<CarrierConnect>(1);
            time = 300;
        }

        public override void readerSign(Dictionary<int, CarrierSignalStatus> carrierMessage)
        {
            byte[] rsTaskNo1 = connect1.getData(52, 0, 444);
            byte[] rsSign1 = connect1.getData(54, 0, 222);
            byte[] carrierState1 = connect1.getCarrierStatus(0, 782);//关键点
            CarrierStatusDB(carrierMessage, rsTaskNo1, rsSign1, carrierState1, 1000, 1111);
        }

        public override void ClearTask(int plcId, int wOffset)
        {
            connect1.clearCarrierTask(wOffset);

        }
    }

    public class CarrierSynchro2 : DYGCarrierSynchro
    {
        //一楼左
        protected CarrierConnect connect2 = null;
        protected CarrierConnect connect3 = null;

        public CarrierSynchro2(int plcId)
        {

            connect2 = TaskPool.get<CarrierConnect>(plcId);
            connect3 = TaskPool.get<CarrierConnect>(plcId);
            time = 300;
        }

        public override void readerSign(Dictionary<int, CarrierSignalStatus> carrierMessage)
        {
            byte[] rsTaskNo2 = connect2.getData(52, 0, 140);
            byte[] rsSign2 = connect2.getData(54, 0, 70);
            byte[] carrierState2 = connect2.getCarrierStatus(0, 202);
            CarrierStatusDB(carrierMessage, rsTaskNo2, rsSign2, carrierState2, 1200, 1235);

            byte[] rsTaskNo3 = connect3.getData(52, 0, 304);
            byte[] rsSign3 = connect3.getData(54, 0, 152);
            byte[] carrierState3 = connect3.getCarrierStatus(0, 422);
            CarrierStatusDB(carrierMessage, rsTaskNo3, rsSign3, carrierState3, 1300, 1376);
        }

        public override void ClearTask(int plcId, int wOffset)
        {
            if (plcId==2)
            {
                connect2.clearCarrierTask(wOffset);
            }
            else if (plcId==3)
            {
                connect3.clearCarrierTask(wOffset);
            }
        }
    }


    public class CarrierSynchro4 : DYGCarrierSynchro
    {
        protected CarrierConnect connect4 = null;
        public CarrierSynchro4()
        {
            connect4 = TaskPool.get<CarrierConnect>(4);
            time = 300;
        }

        public override void readerSign(Dictionary<int, CarrierSignalStatus> carrierMessage)
        {
            byte[] rsTaskNo4 = connect4.getData(52, 0, 144);
            byte[] rsSign4 = connect4.getData(54, 0, 72);
            byte[] carrierState4 = connect4.getCarrierStatus(0, 246);
            CarrierStatusDB(carrierMessage, rsTaskNo4, rsSign4, carrierState4, 2001, 2037);
        }

        public override void ClearTask(int plcId, int wOffset)
        {
            connect4.clearCarrierTask(wOffset);
        }
    }


    public class CarrierSynchro5 : DYGCarrierSynchro
    {
        protected CarrierConnect connect5 = null;

        public CarrierSynchro5()
        {
            connect5 = TaskPool.get<CarrierConnect>(5);
            time = 300;
        }

        public override void readerSign(Dictionary<int, CarrierSignalStatus> carrierMessage)
        {
            byte[] rsTaskNo5 = connect5.getData(52, 0, 144);
            byte[] rsSign5 = connect5.getData(54, 0, 72);
            byte[] carrierState5 = connect5.getCarrierStatus(0, 246);
            CarrierStatusDB(carrierMessage, rsTaskNo5, rsSign5, carrierState5, 2201, 2212);
        }

        public override void ClearTask(int plcId, int wOffset)
        {
            connect5.clearCarrierTask(wOffset);
        }
    }




}
