﻿using GK.FMXT.DAL;
using GK.FMXT.DAL.Entity;
using GK.WMS.DAL;
using GK.WMS.Entity.wms;
using GK.Xml.Msfx.upload;
using MongoDB.Driver;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Hosting;
using System.Web.Http;
using System.Web.Http.Results;
using System.Web.Security;
using System.Xml;
using System.Xml.Linq;
using Web.Authorize;
using WebApi.Controller.file;

namespace WebApi
{
    //[FormAuthenticationFilter]
    [RoutePrefix("api/file")]
    public class FileController : BaseApiController
    {
        [HttpGet, Route("download/{id}")]
        public IHttpActionResult Get(String type, String id)
        {
            var path = HostingEnvironment.MapPath("/bin/Web.dll");
            var f = new FileInfo(path);
            if (!f.Exists)
            {
                return new StatusCodeResult(HttpStatusCode.NotFound, this);
            }
            return new FileStreamResult(f.OpenRead(), "application/octet-stream", "web.dl");
        }

        /// <summary>
        /// 出库导出码上放心文档
        /// </summary>
        /// <param name="id"></param>
        /// <param name="receiptNo"></param>
        /// <param name="outType"></param>
        /// <returns></returns>
        [HttpGet, Route("exports/{id}/{receiptNo}/{outType}"), ControlName("导出文档")] ///{type}/{id}
        public IHttpActionResult exports(long id, string receiptNo, int outType)
        {
            //List<CoreCodeInfo> list = CodeInfoUtil.GetCodeList(authorityServer.GetByOutId(id));
            MsfxDocument document = new MsfxDocument();
            MsfxEvents Events = new MsfxEvents();
            List<MsfxEvent> Eventlist = new List<MsfxEvent>();
            MsfxEvent events = new MsfxEvent();
            events.MainAction = "WareHouseOut";
            events.Name = (MsfxEventType)outType;
            MsfxDataField dataField = new MsfxDataField();
            List<MsfxData> DataField = new List<MsfxData>();
            //foreach (var item in list)
            //{
            MsfxData data = new MsfxData();
            data.Code = "343443";  ///item.barCode
            //data.Actor = "";
            data.ActDate = DateTime.Now.ToString();
            if (!string.IsNullOrEmpty(receiptNo))
            {
                data.CorpOrderID = receiptNo;
            }

            //data.CorpProductID = "";
            //data.CorpBatchNo = "";
            //data.ProduceDate = "";
            //data.FromCorpID = "";
            //data.ToCorpID = "";
            //data.OwnerCorpID = "";
            DataField.Add(data);
            //}
            dataField.DataField = DataField;
            events.MsfxDataField = dataField;
            Eventlist.Add(events);
            Events.Events = Eventlist;
            document.Events = Events;
            StringBuilder builder = new StringBuilder();
            string str = document.toXml(document, builder);
            string xml = @"<?xml version=""1.0""?>" + str;
            byte[] b = System.Text.Encoding.Default.GetBytes(xml);
            MemoryStream ms = new MemoryStream(b);
            return new FileStreamResult(ms, "application/octet-stream", events.Name + @"_" + DateTime.Now.ToString("yyyyMMddHHmmss") + ".xml");
        }


        /// <summary>
        /// 盘库导出码上放心文档
        /// </summary>
        /// <param name="id"></param>
        /// <param name="receiptNo"></param>
        /// <param name="outType"></param>
        /// <returns></returns>
        [HttpGet, Route("exportsPk/{id}/{receiptNo}"), ControlName("导出文档")] ///{type}/{id}
        public IHttpActionResult exportsPk(long id, string receiptNo)
        {
            var codeList = CodeInfoUtil.GetCodeListByPkdetailId(id);
            if (codeList.Count == 0)
            {
                return null;
            }
            MsfxDocument document = new MsfxDocument();
            MsfxEvents Events = new MsfxEvents();
            List<MsfxEvent> Eventlist = new List<MsfxEvent>();
            //盘盈
            var codePyList = codeList.Where(a => a.uploadStatus == 2).ToList();
            if (codePyList.Count > 0)
            {
                MsfxEvent events = new MsfxEvent();
                events.MainAction = "WareHousePk";
                events.Name = (MsfxEventType)106;
                MsfxDataField dataField = new MsfxDataField();
                List<MsfxData> DataField = new List<MsfxData>();
                foreach (var item in codePyList)
                {
                    MsfxData data = new MsfxData();
                    data.Code = item.barCode;
                    data.ActDate = DateTime.Now.ToString();
                    data.CorpOrderID = receiptNo;
                    DataField.Add(data);
                }
                dataField.DataField = DataField;
                events.MsfxDataField = dataField;
                Eventlist.Add(events);
            }
            //盘亏
            var codePkList = codeList.Where(a => a.uploadStatus == 3).ToList();
            if (codePkList.Count > 0)
            {
                MsfxEvent events2 = new MsfxEvent();
                events2.MainAction = "WareHousePk";
                events2.Name = (MsfxEventType)209;
                MsfxDataField dataField2 = new MsfxDataField();
                List<MsfxData> DataField2 = new List<MsfxData>();
                foreach (var item in codePkList)
                {
                    MsfxData data = new MsfxData();
                    data.Code = item.barCode;
                    data.ActDate = DateTime.Now.ToString();
                    data.CorpOrderID = receiptNo;
                    DataField2.Add(data);
                }
                dataField2.DataField = DataField2;
                events2.MsfxDataField = dataField2;
                Eventlist.Add(events2);
            }           
            //-----
            Events.Events = Eventlist;
            document.Events = Events;
            StringBuilder builder = new StringBuilder();
            string str = document.toXml(document, builder);
            string xml = @"<?xml version=""1.0""?>" + str;
            byte[] b = System.Text.Encoding.Default.GetBytes(xml);
            MemoryStream ms = new MemoryStream(b);
            return new FileStreamResult(ms, "application/octet-stream", "WareHousePk" + @"_" + DateTime.Now.ToString("yyyyMMddHHmmss") + ".xml");
        }

        

        [HttpGet, Route("ExportBarCode/{outType}"), ControlName("导出条码文档")] ///{type}/{id}
        public IHttpActionResult ExportBarCode(int outType)
        {
            MongoCursor<CoreCodeInfo> list = CodeInfoUtil.GetAll();
            MsfxDocument document = new MsfxDocument();
            MsfxEvents Events = new MsfxEvents();
            List<MsfxEvent> Eventlist = new List<MsfxEvent>();
            MsfxEvent events = new MsfxEvent();
            events.MainAction = "WareHouseOut";//--------
            events.Name = (MsfxEventType)outType;
            MsfxDataField dataField = new MsfxDataField();
            List<MsfxData> DataField = new List<MsfxData>();
            foreach (var item in list)
            {
                MsfxData data = new MsfxData();
                data.Code = item.barCode;
                //data.Actor = "";
                data.ActDate = DateTime.Now.ToString();
                data.ReplaceCode = item.oldBarcode;
                //data.CorpProductID = "";
                //data.CorpBatchNo = "";
                //data.ProduceDate = "";
                //data.FromCorpID = "";
                //data.ToCorpID = "";
                //data.OwnerCorpID = "";
                DataField.Add(data);
            }
            dataField.DataField = DataField;
            events.MsfxDataField = dataField;
            Eventlist.Add(events);
            Events.Events = Eventlist;
            document.Events = Events;
            StringBuilder builder = new StringBuilder();
            string str = document.toXml(document, builder);
            string xml = @"<?xml version=""1.0""?>" + str;
            byte[] b = System.Text.Encoding.Default.GetBytes(xml);
            MemoryStream ms = new MemoryStream(b);
            return new FileStreamResult(ms, "application/octet-stream", events.Name + @"_" + DateTime.Now.ToString("yyyyMMddHHmmss") + ".xml");
        }

        [HttpPost, Route("upload")]
        public BaseResult Upload()
        {

            string id = HttpContext.Current.Request["id"];
            string name = HttpContext.Current.Request["name"];
            HttpFileCollection files = HttpContext.Current.Request.Files;

            foreach (string key in files.AllKeys)
            {
                HttpPostedFile file = files[key];//file.ContentLength文件长度
                if (string.IsNullOrEmpty(file.FileName) == false)
                    file.SaveAs(HttpContext.Current.Server.MapPath("~/App_Data/") + file.FileName);
            }

            return new BaseResult("");
        }

    }
}
