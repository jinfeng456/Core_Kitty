using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using GK.FMXT.DAL;
using GK.FMXT.DAL.Entity;
using GK.WMS.DAL;
using GK.WMS.Entity;
using Quartz;
using Quartz.Impl;
using WMS.DAL;

namespace Web.job
{

    public class SyncCodeJob : JobBase
    {
        ICoreStockServer authorityServer = WMSDalFactray.getDal<ICoreStockServer>();
        public override void excute()
        {
            //上面获取 List<CoreCodeInfo> list
            //List<CoreStockDetail> list = authorityServer.GetByBatchId();
            //CodeInfoUtil.SyncCodeInfo();
        }
    }



}