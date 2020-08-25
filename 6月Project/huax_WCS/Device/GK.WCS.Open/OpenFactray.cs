
using ConsoleApplication2.HttpServer;
using GK.Engine.WMS.wms;
using System.ServiceModel;
using WCS.Common;

namespace GK.WCS.Open  {

    public class OpenFactray:ZtFactray {
        public override ZtTask create() {
         

           //  WMSTransactionFacade.doStockInEngine( "213414");
           //  WMSTransactionFacade.syncWcsReult(151402,3);

            HttpProcess.pathDict.Add("/adasdf/asdf","Post_data");
            new HttpServer(12138);
            return null;

        }

        public override void setParam(string p) {
        
        }
    }
}
