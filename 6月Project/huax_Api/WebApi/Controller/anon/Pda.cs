using Common;
using GK.BACK.DAL;
using GK.Fmxt.DAL;
using GK.FMXT.DAL;
using GK.WMS.DAL;
using GK.WMS.Entity;
using GK.WMS.Entity.wms;
using HY.WCS.DAL.dto;
using MongoDB.Bson;
using MongoDB.Driver;
using Mongon.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.UI;
using System.Windows.Forms;
using WebApi.util;
using WMS.DAL;
using WMS.Entity;

namespace WebApi.Controller
{
    [RoutePrefix("api/pda")]
    public class PdaController : BaseApiController
    {

        IReceiptInServer receiptInServer = WMSDalFactray.getDal<IReceiptInServer>();
        IReceiptOutServer receiptOutServer = WMSDalFactray.getDal<IReceiptOutServer>();
        IReceiptPkServer receiptPkServer = WMSDalFactray.getDal<IReceiptPkServer>();
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();
        ICoreStockServer coreStockServer = WMSDalFactray.getDal<ICoreStockServer>();
        IItemServer itemServer = WMSDalFactray.getDal<IItemServer>();
        IMiddleServer middleServer = FmxtDalFactray.getDal<IMiddleServer>();
        IBatchServer batchServer = WMSDalFactray.getDal<IBatchServer>();
        private ISysAuthorityServer authorityServer = WMSDalFactray.getDal<ISysAuthorityServer>();

        //采购入库界面显示
        [HttpGet, Route("inDetail")]
        public BaseResult inDetail()
        {
            List<Pair> list = new List<Pair>();
            List<WhReceiptInDetail> detailList = receiptInServer.getAllWorkingReceiptInDetail();

            foreach (WhReceiptInDetail detail in detailList)
            {
                list.Add(new Pair(detail.id + "", detail.wmsBanchNo + "-" + detail.FromCorpBatchNo + "-" + detail.itemName));
            }
            return new BaseResult(list);
        }
        //原料分拣出库界面显示
        [HttpPost, Route("outDetail")]
        public BaseResult outDetail([FromBody]stockInfoDto dto)
        {
            List<Pair> list = new List<Pair>();
            List<CoreStock> list1 = receiptOutServer.GetCoreStockId(dto.boxCode);
            if (list1 == null || list1.Count == 0)
            {
                return new BaseResult("该托盘不存在!");
            }
            List<CoreStockDetail> detailList = receiptOutServer.getCoreStockDetials(list1[0].id);
            foreach (CoreStockDetail detail in detailList)
            {
                list.Add(new Pair(detail.id + "", detail.itemCode + "-" + detail.wmsBanchNo + "-" + detail.countDb));
            }
            return new BaseResult(list);
        }

        //原料盘库界面显示
        [HttpPost, Route("pkDetail")]
        public BaseResult pkDetail([FromBody]stockInfoDto dto)
        {
            List<Pair> list = new List<Pair>();
            List<WhReceiptPkDetail> detailList = receiptPkServer.getPkDetailsByBoxCode(dto.boxCode);
            //List<CoreStockDetail> detailList = receiptOutServer.getCoreStockDetials(list1[0].id);
            foreach (WhReceiptPkDetail detail in detailList)
            {
                list.Add(new Pair(detail.id + "", detail.boxCode + "-" + detail.barCode));
            }
            return new BaseResult(list);
        }

        //采购入库
        [HttpPost, Route("saveStock")]
        public BaseResult saveStock([FromBody]stockInfoDto dto)
        {

            List<CoreStock> list = coreStockServer.getCoreStockByCode(dto.boxCode);
            if (list.Count > 0)
            {
                return new BaseResult("条码已存在");
            }
            WhReceiptInDetail inDetial = receiptInServer.getById<WhReceiptInDetail>(dto.detailId);
            int actualNumber=coreStockServer.getSumStockCountDb(inDetial.id); 
            if (actualNumber> inDetial.planCount)
            {
                return new BaseResult("入库实际数量大于可计划数量");
            }
            CoreItem core = itemServer.FindCoreItemById((long)inDetial.itemId);
            WhReceiptIn whReceiptIn= receiptInServer.getById<WhReceiptIn>(long.Parse(inDetial.receiptId.ToString()));
            CoreStock cs = new CoreStock();
            cs.id = sequenceIdServer.getId();
            cs.boxCode = dto.boxCode;
            cs.changeTime = sequenceIdServer.GetTime();
            cs.createTime = cs.changeTime;
            cs.pkStatus = 0;
            cs.status = 0;
            cs.locked = 0;
            cs.statusTypes = 1;
            cs.isFull = dto.isZhentuo;
            cs.rItemId = core.id;
            cs.rItemCode = core.code;
            //根据itemId查询出itemCode

            CoreStockDetail csd = new CoreStockDetail();
            csd.id = sequenceIdServer.getId();
            csd.stockId = cs.id;
            csd.receiptlnId = dto.detailId;
            csd.itemId = inDetial.itemId;
            csd.itemCode = core.code;
            csd.inTime = cs.createTime;
            csd.countDb = dto.countInput;
            csd.wmsBanchNo = inDetial.wmsBanchNo;
            csd.stockStatus = 0;
            csd.pkStatus = 0;
            csd.bussStatus = dto.isCouyan;
            csd.remark= whReceiptIn.remark;
            receiptInServer.insertNotNull(cs);
            receiptInServer.insertNotNull(csd);

            return new BaseResult("ok");

        }
        //产成品入库
        [HttpPost, Route("saveStocks")]
        public BaseResult saveStocks([FromBody]stockInfosDto dto)
        {
            List<CoreStock> list = coreStockServer.getCoreStockByCode(dto.boxCode);
            CoreStock cs = new CoreStock();
            if (list.Count < 1)
            {
                cs.id = sequenceIdServer.getId();
                cs.boxCode = dto.boxCode;
                cs.status = 1;
                cs.createTime = DateTime.Now;
                cs.changeTime = DateTime.Now;
                cs.isFull = dto.isZhentuo;
                cs.statusTypes = 1;
                cs.locked = 0;
                cs.pkStatus = 0;
                long cid = cs.id;
                receiptInServer.insertNotNull(cs);
            }
            else
            {
                cs = list[0];
            }

            List<CoreStockDetail> cpList = coreStockServer.GetListByStockId(cs.id);
            CoreStockDetail csd = new CoreStockDetail();
            long stockDetailId = 0;
            if (cpList.Count < 1)
            {
                csd.id = sequenceIdServer.getId();
                csd.stockId = list[0].id;
                csd.countDb = 1;
                csd.itemId = 0;
                csd.receiptlOutId = 0;
                csd.pkStatus = 0;
                csd.stockStatus = 1;
                receiptInServer.insertNotNull(csd);
                stockDetailId = csd.id;
            }
            else
            {
                stockDetailId = cpList[0].id;
            }

            string[] sArray = Regex.Split(dto.barCode, ",", RegexOptions.IgnoreCase);
            for (int i = 0; i < sArray.Length - 1; i++)
            {
                var collection = MongonBaseDAL.database.GetCollection<BsonDocument>("CoreCodeInfo");
                //获取中间表的信息
                List<LogCodeDetail> logCodeDetailList = middleServer.GetByBarCode(sArray[i], "");
                if (logCodeDetailList == null || logCodeDetailList.Count == 0)
                {
                    continue;
                }
                LogCodeDetail logCodeDetail = logCodeDetailList[0];
                //同步条码
                if (!CodeInfoUtil.Exist(sArray[i]))
                {
                    CoreCodeInfo codeInfo = new CoreCodeInfo();
                    codeInfo.barCode = logCodeDetail.barCode;
                    codeInfo.parentCode = logCodeDetail.parentCode;
                    codeInfo.level = logCodeDetail.levels;
                    codeInfo.stockDetailId = stockDetailId;
                    collection.Insert(codeInfo);
                }
                //同步批次
                List<InfBatch> remoteBatchList = middleServer.GetBatchList().Where(a => a.taskNo == logCodeDetail.taskno).ToList();
                if (remoteBatchList == null || remoteBatchList.Count == 0)
                {
                    continue;
                }
                batchServer.AddBarch(remoteBatchList[0]);
            }
            return new BaseResult("ok");
        }
        //成品分拣
        [HttpPost, Route("saveFjStocks")]
        public BaseResult saveFjStocks([FromBody]stockInfosDto dto)
        {
            List<CoreStock> list = coreStockServer.getCoreStockByCode(dto.boxCode);
            if (list.Count == 0)
            {
                return new BaseResult("不存在该托盘!");
            }
            CoreStock cs = new CoreStock();
            CoreStockDetail csd = new CoreStockDetail();
            string[] sArray = Regex.Split(dto.barCode, ",", RegexOptions.IgnoreCase);
            for (int i = 0; i < sArray.Length - 1; i++)
            {
                //receiptOutServer.updateCoreStockDetails(sArray[i]);
                string parentCode = CodeInfoUtil.GetInfoByBarCode(sArray[i])[0].parentCode;
                if (!string.IsNullOrEmpty(parentCode))
                {
                    CodeInfoUtil.UpdateIsFull(parentCode, sArray);
                }
            }
            return new BaseResult("ok");
        }
        //原料分拣
        [HttpPost, Route("saveYlStock")]
        public BaseResult saveYlStock([FromBody]stockInfoDto dto)
        {
            receiptOutServer.updateCoreStockDetailsById(dto.detailId);
            return BaseResult.Ok("成功");
        }
        //成品盘库
        [HttpPost, Route("savePkStocks")]
        public BaseResult savePkStocks([FromBody]stockInfosDto dto)
        {

            List<CoreStock> list = coreStockServer.getCoreStockByCode(dto.boxCode).Where(a => a.status == 2).ToList();
            if (list.Count == 0)
            {
                return new BaseResult("不存在该托盘!");
            }
            //一个托盘只能用一个明细
            var listDetail = coreStockServer.GetListByStockId(list[0].id);
            if (listDetail.Count > 1)
            {
                return new BaseResult("数据异常!");
            }
            List<CoreCodeInfo> listCodeInfo = CodeInfoUtil.GetCodeList(listDetail);
            string[] sArray = Regex.Split(dto.barCode, ",", RegexOptions.IgnoreCase);
            //校验
            for (int i = 0; i < sArray.Length - 1; i++)
            {
                if (!listCodeInfo.Exists(a => a.barCode == sArray[i]))
                {
                    var listBarCode = CodeInfoUtil.GetInfoByBarCode(sArray[i]);
                    if (listBarCode.Count == 0)
                    {
                        return new BaseResult("该条码不存在!");
                    }
                }
            }
            for (int i = 0; i < sArray.Length - 1; i++)
            {
                if (listCodeInfo.Exists(a => a.barCode == sArray[i]))
                {
                    //正常
                    CodeInfoUtil.UpdateUploadStatus(sArray[i], 1);
                }
                else
                {
                    var listBarCode = CodeInfoUtil.GetInfoByBarCode(sArray[i]);
                    CodeInfoUtil.UpdateUploadStatus(sArray[i], 2, listDetail[0].id);
                }
            }
            //盘亏
            foreach (var codeInfo in listCodeInfo)
            {
                if (!sArray.Contains(codeInfo.barCode))
                {
                    if (codeInfo.isFull == 1)
                    {
                        CodeInfoUtil.UpdateUploadStatus(codeInfo.barCode, 3);
                    }
                }
            }
            return new BaseResult("ok");
        }
        //原料盘库
        [HttpPost, Route("saveYpStock")]
        public BaseResult saveYpStock([FromBody]stockInfoDto dto)
        {
            receiptPkServer.updatePkCountById(dto.detailId, dto.countInput);
            return new BaseResult("ok");
        }



        #region PDA用户登录
        /// <summary>
        /// PDA用户登录
        /// </summary>
        /// <returns></returns>
        [HttpPost, Route("login")]
        public BaseResult login([FromBody] UserDto user)
        {
            AuthenticatioToken token = new AuthenticatioToken();
            List<SysUser> listByName = authorityServer.GetUser(user.account);
            try
            {
                if (listByName == null || listByName.Count == 0)
                {
                    return BaseResult.Error("账号不存在！",500);
                }
                List<SysUser> listByNamePwd = authorityServer.GetUser(user.account, GKMD5.MD5Encrypt(user.password));
                if (listByNamePwd == null || listByNamePwd.Count == 0)
                {
                    return BaseResult.Error("密码不正确！",500);
                }
                if (listByName[0].userstatus == 0)
                {
                    return BaseResult.Error("账号已锁定！",500);
                }
                token.token = user.account;
                return BaseResult.Ok(token);
            }
            catch (Exception ex)
            {
                return BaseResult.Error("PDA用户登录ss," + ex.Message,500);
            }

        }


        /// <summary>
        /// PDA用户登出
        /// </summary>
        /// <returns></returns>
        [HttpPost, Route("logout")]
        public BaseResult logout([FromBody] UserDto user)
        {
            return BaseResult.Ok("");
        }
        #endregion                  
    }


    public class stockInfoDto
    {
        public long detailId;
        public int countInput;
        public string boxCode;
        public int isCouyan;
        public int isZhentuo;
        public string barCode;
    }
    public class stockInfosDto
    {
        public string boxCode;
        public string barCode;
        public int isZhentuo;
    }
}
