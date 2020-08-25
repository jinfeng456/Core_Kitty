using Common.dto;
using GK.WMS.DAL;
using GK.WMS.Entity;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.DAL;

namespace WebApi.util
{
    public static class MessageUtil
    {
        static ICoreStockServer coreStockServer = WMSDalFactray.getDal<ICoreStockServer>();
        static IBatchServer batchServer = WMSDalFactray.getDal<IBatchServer>();

        public static string GetNoOutMessage()
        {
            Page<CoreStockParam> info = coreStockServer.QueryCoreDetailPage(new CoreStockDto() { isWarning = true, pageNum=1, pageSize=10000 });
            string str = string.Empty;
            foreach (var item in info.content)
            {
                str += ("品名:"+item.itemName + ",批次号:" + item.wmsBanchNo) + "|";
            }
            return str.Trim('|');
        }

        public static string GetBatchMessage()
        {
            Page<WhBatch> info = batchServer.QueryBatchPage<WhBatch>(new BatchDto() { isWarning = true, pageNum = 1, pageSize = 10000 });
            string str = string.Empty;
            foreach (var item in info.content)
            {
                str += ("品名:" + item.itemName + ",批次号:" + item.batchNo) + "|";
            }
            return str.Trim('|');
        }

}
}
