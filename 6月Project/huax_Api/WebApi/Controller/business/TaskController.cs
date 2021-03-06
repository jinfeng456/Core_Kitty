﻿
using GK.Adaper;
using GK.Engine.WMS;
using GK.WMS.DAL;
using GK.WMS.Entity;
using GK.WMS.Entity.wms;
using HY.WCS.DAL;
using HY.WCS.DAL.dto;
using HY.WCS.Entity.dto;
using Microsoft.AspNet.SignalR.Infrastructure;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Http.Cors;
using Web.Authorize;
using WMS.DAL;

namespace WebApi
{
    [FormAuthenticationFilter]

    [RoutePrefix("tasks")]
    public class TaskController : BaseApiController
    {
        static SyncWcsReultEngine sy = new SyncWcsReultEngine();
        static InEngine inEngine = new InEngine();
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();
        [HttpPost, Route("finshOutTask"), ControlName("入库出库完成")] //这里可能要区分
        public bool finshOutTask(ref string errorMsg)
        {
            sy.taskId = 157603;
            sy.taskStatus = 3;
            sy.doWork(ref errorMsg);
            return true;
            //string boxCode = "555";
            //lock (inEngine)
            //{
            //    inEngine.boxCode = boxCode;
            //    inEngine.doWork();
            //    return true;
            //}
        }
    }
}