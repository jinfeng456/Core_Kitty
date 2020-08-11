using GK.Common.entity;
using GK.WCS.Carrier.dto;
using System.Collections.Generic;

namespace GK.WCS.Carrier
{
    
    public  class GkCarrierStatus :EquipmentStatus
    {         public Dictionary<int, CarrierSignalStatus> curCarrierMessage;

         public GkCarrierStatus(  Dictionary<int, CarrierSignalStatus> curCarrierMessage):base(0) {
            this.curCarrierMessage=curCarrierMessage;
        }
       
    }
}
