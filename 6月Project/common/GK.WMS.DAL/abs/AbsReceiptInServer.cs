using Common.dto;
using Dapper;
using GK.WMS.DAL.abs;
using GK.WMS.Entity;
using GK.WMS.Entity.dto;
using GK.WMS.Entity.wms;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using WebApi.util;
using WMS.DAL;
using WMS.Entity;

namespace GK.WMS.DAL
{
    public abstract class AbsReceiptInServer : AbsWMSBaseServer, IReceiptInServer
    {
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();
        IItemServer itemServer = WMSDalFactray.getDal<IItemServer>();
        #region 采购订单
        //根据采购订单ID获取明细
        public List<WhSoInDetail> GetOrderDetailId(WhSoIn warehouseIn)
        {
            WhSoInDetail warehouseInDetail = new WhSoInDetail();
            warehouseInDetail.soId = warehouseIn.id;
            long soId = warehouseIn.id;
            String sql = @"select * from wh_So_In_Detail where so_Id=@soId";
            List<WhSoInDetail> list1 = Connection.Query<WhSoInDetail>(sql, new { soId = soId }).ToList();
            return list1;
        }
        //采购订单分页
        public Page<WhSoIn> QueryOrderPage(WhSoInDto dto)
        {
            string sql = @"select *from wh_So_In where 1=1";
            if (!string.IsNullOrEmpty(dto.vbillcode))
            {
                dto.vbillcode = "%" + dto.vbillcode + "%";
                sql += " AND so_No like @vbillcode";
            }
            if (!string.IsNullOrEmpty(dto.gysName))
            {
                dto.gysName = "%" + dto.gysName + "%";
                sql += " AND gys_Name like @gysName";
            }
            if (!string.IsNullOrEmpty(dto.status))
            {
                if (dto.status == "执行中")
                {
                    sql += " AND status=1";
                }
                else
                {
                    sql += " AND status=2";

                }
            }
            return this.queryPage<WhSoIn>(sql, "id", dto);
        }
        //添加入库单
        public long AddReceiptIn(WhReceiptIn whReceiptIn, WhSoIn warehouseIn)
        {
            whReceiptIn.id = sequenceIdServer.getId();
            whReceiptIn.creater = CookieHelper.LoginName();
            whReceiptIn.beginTime = DateTime.Now;
            whReceiptIn.finshTime = DateTime.Now;
            whReceiptIn.status = 1;
            whReceiptIn.inType = 101; //采购入库101
            if (string.IsNullOrWhiteSpace(whReceiptIn.receiptNo))
            {
                whReceiptIn.receiptNo = sequenceIdServer.GetSerial("Wh_Receipt_in", whReceiptIn.inType);
            }
            WhReceiptInDetail whReceiptInDetail = new WhReceiptInDetail();
            List<WhSoInDetail> list = this.GetOrderDetailId(warehouseIn);
            for (int i = 0; i < list.Count(); i++)
            {
                whReceiptInDetail.id = sequenceIdServer.getId();
                whReceiptInDetail.receiptId = whReceiptIn.id;
                whReceiptInDetail.FromCorpName = whReceiptIn.fromCorpName;
                whReceiptInDetail.stn = whReceiptIn.stn;
                //根据itemCode去查询itemId
                long itemId = itemServer.GetCoreItemByCode(list[i].itemCode)[0].id;
                whReceiptInDetail.itemId = itemId;
                //whReceiptInDetail.wmsBanchNo = whReceiptIn.wmsBanchNo;
                //whReceiptInDetail.FromCorpBatchNo = whReceiptIn.FromCorpBatchNo;
                whReceiptInDetail.packUnit = list[i].itemUnit;
                whReceiptInDetail.createTime = DateTime.Now;
                whReceiptInDetail.packageSpec = list[i].specification;
                whReceiptInDetail.planCount = list[i].count;
                whReceiptInDetail.activeCount = 0;
                whReceiptInDetail.finshCount = 0;
                whReceiptInDetail.itemName = list[i].itemName;
                whReceiptInDetail.soDetailId = list[i].id;
                whReceiptInDetail.soid = warehouseIn.id;
                Connection.InsertNoNull<WhReceiptInDetail>(whReceiptInDetail);
            }
            return Connection.InsertNoNull<WhReceiptIn>(whReceiptIn);
        }
        //根据订单主Id判断
        public List<WhSoInDetail> GetBillNo(string src_so_bill)
        {
            String sql = @"select * from wh_So_In where src_so_bill=@src_so_bill";
            List<WhSoInDetail> list1 = Connection.Query<WhSoInDetail>(sql, new { src_so_bill = src_so_bill }).ToList();
            return list1;
        }
        //根据订单子Id判断
        public List<WhSoInDetail> GetPkNo(string src_so_bill_detail)
        {
            String sql = @"select * from wh_So_In_Detail where src_so_bill_detail=@src_so_bill_detail";
            List<WhSoInDetail> list2 = Connection.Query<WhSoInDetail>(sql, new { src_so_bill_detail = src_so_bill_detail }).ToList();
            return list2;
        }
        #endregion

        #region 入库单
        public List<WhReceiptInDetail> getDetials(long receiptinId)
        {
            String sql = "select * from Wh_Receipt_in_Detail  where receipt_id=@receiptinId";

            return Connection.Query<WhReceiptInDetail>(sql, new { receiptinId }).ToList();
        }


        //入库单分页
        public Page<WhReceiptIn> QueryReceiptInPage(ReceiptinDto dto)
        {
            string sql = " select * from Wh_Receipt_in  where 1=1 ";

            if (dto != null && !string.IsNullOrEmpty(dto.receiptNo))
            {
                dto.receiptNo = "%" + dto.receiptNo + "%";
                sql += " and receipt_No like @receiptNo";
            }
            if (dto != null && !string.IsNullOrEmpty(dto.FromCorpName))
            {
                dto.FromCorpName = "%" + dto.FromCorpName + "%";
                sql += " and From_Corp_Name like @FromCorpName";
            }
            if (dto.inType != 0)
            {
                sql += " and in_Type = @inType";
            }
            if (dto.stn != 0)
            {
                sql += " and stn = @stn";
            }
            string orderBy = " begin_Time  desc";
            return this.queryPage<WhReceiptIn>(sql, orderBy, dto);
        }

        //获取入库单所有明细
        public List<WhReceiptInDetail> getAllWorkingReceiptInDetail()
        {
            String sql = @"SELECT de.id,de.[item_Id],de.[item_Name] ,de.[wms_Banch_No] ,de.[From_Corp_Batch_No],de.[From_Corp_Name]
                           FROM  [Wh_Receipt_in_detail] de join  [Wh_Receipt_in] in_de on de.receipt_Id= in_de.id where  in_de.status=2"
;
            List<WhReceiptInDetail> list = Connection.Query<WhReceiptInDetail>(sql).ToList();
            return list;
        }

        public bool updateBegin(long id)
        {
            string sql = @"update Wh_Receipt_in set status=2,begin_Time=GETDATE() where id=@id";
            Connection.Execute(sql, new { id = id });
            return true;
        }

        public bool updateFinsh(long id)
        {
            string sql = @"update Wh_Receipt_in set status=3 where id=@id";
            Connection.Execute(sql, new { id = id });
            return true;
        }

        //根据入库单ID去查询详细信息
        public List<WhReceiptIn> getReceiptIn(long id)
        {
            string sql = @"select * from wh_receipt_in where id=@id ";
            List<WhReceiptIn> list = Connection.Query<WhReceiptIn>(sql, new { id = id }).ToList();
            return list;
        }

        //通过入库单Id删除入库单明细
        public bool deleteInDetail(long receiptId)
        {
            string sql = @"select * from wh_receipt_in_detail where receipt_Id=@receiptId ";
            List<WhReceiptInDetail> list = Connection.Query<WhReceiptInDetail>(sql, new { receiptId = receiptId }).ToList();
            for (int i = 0; i < list.Count; i++)
            {
                delete<WhReceiptInDetail>(list[i].id);
            }
            return true;
        }

        public Page<CoreItem> QueryCoreItemPage(CoreCorpItemDto dto)
        {
            //string supplierName = dto.gysName;
            string sql = "select ci.id,ci.classify_Id,ci.code,ci.name,ci.core_Item_Type,ci.model_specs,ci.package_specs,ci.is_Sorting from core_item ci left join core_Corp_Item cci on ci.id=cci.item_Id " + "left join Core_Supplier_Corp csc on cci.supplier_Id = csc.id" + " where 1=1";
            if (dto != null && !string.IsNullOrEmpty(dto.gysName))
            {

                sql += "and csc.name = @gysName";
            }
            if (dto != null && !string.IsNullOrEmpty(dto.name)) //用于弹窗选择物料名称查询条件
            {
                dto.name = "%" + dto.name + "%";
                sql += " and ci.name like @name ";
            }
            if (dto != null && !string.IsNullOrEmpty(dto.code)) 
            {
                dto.code = "%" + dto.code + "%";
                sql += " and ci.code like @code ";
            }
            if (dto != null && !string.IsNullOrEmpty(dto.modelSpecs))
            {
                dto.modelSpecs = "%" + dto.modelSpecs + "%";
                sql += " and ci.model_specs like @modelSpecs ";
            }
            if (dto != null && !string.IsNullOrEmpty(dto.packageSpecs))
            {
                dto.packageSpecs = "%" + dto.packageSpecs + "%";
                sql += " and ci.package_specs like @packageSpecs ";
            }
            if (dto != null && dto.classifyId != 0)
            {
                sql += " AND ci.classify_Id = @classifyId ";
            }
            if (dto != null && dto.coreItemType > 0)
            {
                sql += " AND ci.core_Item_Type = @coreItemType ";
            }
            if (dto != null && dto.supplierId != 0)
            {

                sql += "and cci.supplier_Id = @supplierId";
            }
            return this.queryPage<CoreItem>(sql, "id", dto);
        }

        public List<WhReceiptIn> GetAllList(long receiptInId)
        {
            String sql = "select * from Wh_Receipt_in where id=@receiptInId ";
            return Connection.Query<WhReceiptIn>(sql, new { receiptInId = receiptInId }).ToList();
        }

        #endregion

        public List<WhReceiptIn> GetNotUploadList()
        {
            string sql = "select * from Wh_Receipt_in where Status=3 and upload=0";
            return Connection.Query<WhReceiptIn>(sql).ToList();
        }

        public bool UpdateUploadById(long id)
        {
            string sql = @"update Wh_Receipt_in set upload=1 where id=@id";
            Connection.Execute(sql, new { id = id });
            return true;
        }
        public List<WhReceiptInDetail> GetListByReceiptId(long receiptId)
        {
            string sql = "select * from wh_receipt_in_detail where receipt_Id=@receiptId";
            return Connection.Query<WhReceiptInDetail>(sql, new { receiptId = receiptId }).ToList();
        }

        public Page<ReceiptInReportDto> QueryFindReportPage(ReceiptinDto dto)
        {
            string sql = @"SELECT B.pack_Unit,B.package_Spec,B.From_Corp_Name,B.From_Corp_Batch_No,A.in_Type,A.stn, A.status, A.receipt_No,C.name AS itemName,a.begin_Time,a.finsh_Time,b.plan_Count,B.finsh_Count,B.active_Count,B.wms_Banch_No 
                            FROM dbo.Wh_Receipt_in A 
                            INNER JOIN dbo.Wh_Receipt_in_detail B ON A.id=B.receipt_id
                            LEFT JOIN dbo.core_item C ON B.item_Id =C.id WHERE 1=1 ";
            if (dto != null && !string.IsNullOrEmpty(dto.receiptNo))
            {
                dto.receiptNo = "%" + dto.receiptNo + "%";
                sql += " and receipt_No like @receiptNo";
            }
            if (dto != null && !string.IsNullOrEmpty(dto.FromCorpName))
            {
                dto.FromCorpName = "%" + dto.FromCorpName + "%";
                sql += " and B.From_Corp_Name like @FromCorpName";
            }
            if (dto.inType != 0)
            {
                sql += " and A.in_Type = @inType";
            }
            if (dto.stn != 0)
            {
                sql += " and A.stn = @stn";
            }
            if (dto.createBeginTime != DateTime.MinValue)
            {
                sql += " AND A.begin_Time >= @createBeginTime ";
            }
            if (dto.createEndTime != DateTime.MinValue)
            {
                sql += " AND A.begin_Time <= @createEndTime ";
            }
            if (dto.finishBeginTime != DateTime.MinValue)
            {
                sql += " AND A.finsh_Time >= @finishBeginTime ";
            }
            if (dto.finishEndTime != DateTime.MinValue)
            {
                sql += " AND A.finsh_Time <= @finishEndTime ";
            }
            string orderBy = " begin_Time  desc";
            return this.queryPage<ReceiptInReportDto>(sql, orderBy, dto);
        }

        public string GetpkBillHById(long id)
        {
            string sql = "select * from Wh_So_In where id=@id";
            return Connection.Query<WhSoIn>(sql, new { id = id }).FirstOrDefault().srcSoBill;
        }
        public string GetpkBillBById(long id)
        {
            string sql = "select * from Wh_So_In_Detail where id=@id";
            return Connection.Query<WhSoInDetail>(sql, new { id = id }).FirstOrDefault().srcSoBillDetail;
        }

        public List<ReceiptInReportDto> GetExportList(ReceiptinDto dto)
        {
            string sql = @"SELECT B.pack_Unit,B.package_Spec,B.From_Corp_Name,B.From_Corp_Batch_No,A.in_Type,A.stn, A.status, A.receipt_No,C.name AS itemName,a.begin_Time,a.finsh_Time,b.plan_Count,B.finsh_Count,B.active_Count,B.wms_Banch_No 
                            FROM dbo.Wh_Receipt_in A 
                            INNER JOIN dbo.Wh_Receipt_in_detail B ON A.id=B.receipt_id
                            LEFT JOIN dbo.core_item C ON B.item_Id =C.id WHERE 1=1 ";
            if (dto != null && !string.IsNullOrEmpty(dto.receiptNo))
            {
                dto.receiptNo = "%" + dto.receiptNo + "%";
                sql += " and receipt_No like @receiptNo";
            }
            if (dto != null && !string.IsNullOrEmpty(dto.FromCorpName))
            {
                dto.FromCorpName = "%" + dto.FromCorpName + "%";
                sql += " and B.From_Corp_Name like @FromCorpName";
            }
            if (dto.inType != 0)
            {
                sql += " and A.in_Type = @inType";
            }
            if (dto.stn != 0)
            {
                sql += " and A.stn = @stn";
            }
            if (dto.createBeginTime != DateTime.MinValue)
            {
                sql += " AND A.begin_Time >= @createBeginTime ";
            }
            if (dto.createEndTime != DateTime.MinValue)
            {
                sql += " AND A.begin_Time <= @createEndTime ";
            }
            if (dto.finishBeginTime != DateTime.MinValue)
            {
                sql += " AND A.finsh_Time >= @finishBeginTime ";
            }
            if (dto.finishEndTime != DateTime.MinValue)
            {
                sql += " AND A.finsh_Time <= @finishEndTime ";
            }
            string orderBy = " order by begin_Time  desc";
            return Connection.Query<ReceiptInReportDto>(sql + orderBy, dto).ToList();
        }

        public Page<ReceiptInFlatDto> QueryFindFlatPage(ReceiptinDto dto)
        {
            string sql = @"SELECT B.pack_Unit,B.package_Spec,B.id AS reDetailId,B.From_Corp_Name,B.From_Corp_Batch_No,A.in_Type,A.stn, A.status, A.receipt_No,C.name AS itemName,a.begin_Time,a.finsh_Time,b.plan_Count,B.finsh_Count,B.active_Count,B.wms_Banch_No ,D.id AS areaId
                            FROM dbo.Wh_Receipt_in A 
                            INNER JOIN dbo.Wh_Receipt_in_detail B ON A.id=B.receipt_id
                            LEFT JOIN dbo.core_item C ON B.item_Id =C.id
							LEFT JOIN dbo.Core_Wh_Area D ON B.wh_area_id=D.id WHERE 1=1 and A.stn=99 and A.status=2 ";
            if (dto != null && !string.IsNullOrEmpty(dto.receiptNo))
            {
                dto.receiptNo = "%" + dto.receiptNo + "%";
                sql += " and receipt_No like @receiptNo";
            }
            if (dto != null && !string.IsNullOrEmpty(dto.FromCorpName))
            {
                dto.FromCorpName = "%" + dto.FromCorpName + "%";
                sql += " and B.From_Corp_Name like @FromCorpName";
            }
            if (dto.inType != 0)
            {
                sql += " and A.in_Type = @inType";
            }
            if (dto.stn != 0)
            {
                sql += " and A.stn = @stn";
            }
            if (dto.createBeginTime != DateTime.MinValue)
            {
                sql += " AND A.begin_Time >= @createBeginTime ";
            }
            if (dto.createEndTime != DateTime.MinValue)
            {
                sql += " AND A.begin_Time <= @createEndTime ";
            }
            if (dto.finishBeginTime != DateTime.MinValue)
            {
                sql += " AND A.finsh_Time >= @finishBeginTime ";
            }
            if (dto.finishEndTime != DateTime.MinValue)
            {
                sql += " AND A.finsh_Time <= @finishEndTime ";
            }
            string orderBy = " begin_Time  desc";
            return this.queryPage<ReceiptInFlatDto>(sql, orderBy, dto);
        }

        public bool SubmitFlat(int finshCount, string areaName)
        {
            throw new NotImplementedException();
        }
    }
}
