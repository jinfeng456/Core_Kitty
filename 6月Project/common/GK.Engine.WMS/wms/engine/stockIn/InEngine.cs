
using System;
using System.Data;
using Dapper;
using System.Collections.Generic;
using GK.WMS.Entity;
using System.Linq;
using GK.WMS.DAL;
using GK.WMS.Entity.wms;
using GK.Engine.WMS.wms;
<<<<<<< .mine
using GK.Mongon;
||||||| .r1169
using GK.Mongon;
using GK.WMS.Entity.wms.Device;
using Engine.WMS;
=======
using Engine.WMS;
>>>>>>> .r1198
using WMS.DAL;
using WMS.Entity;

namespace GK.Engine.WMS {
    public class InEngine:WmsBaseEngine {
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();

        public WhReceiptIn whReceiptIn = null;
        long stockId = 0;
        long locId = 0;
        long areaId = 0;
        public string boxCode;

        AreaLocWeightDto getAreaLocWeightDto(IDbConnection Connection,IDbTransaction transaction,CoreClassifyArea dto) {
            List<CoreWhLoc> locList = GetCoreLocList(connection,transaction,dto.areaId);
            AreaLocWeightDto areaLocWeightDto = new AreaLocWeightDto();
            if (locList.Count > 0) {
                if (dto.priority == 1) {
                    areaLocWeightDto.weight = 100000000;
                    areaLocWeightDto.loc = locList[0];
                } else if (dto.priority == 2) {
                    areaLocWeightDto.weight = locList.Count();
                    areaLocWeightDto.loc = locList[0];
                } else if (dto.priority == 3) {
                    areaLocWeightDto.weight = 20000 - locList.Count();
                    areaLocWeightDto.loc = locList[0];
                }
                return areaLocWeightDto;
            } else {
                return null;
            }
        }
        protected override bool Execute(IDbConnection connection,IDbTransaction transaction,ref string errorMsg) {
           
            CoreStock cs = GetStockList(connection,transaction,boxCode);
       
            if (cs.status != 0) {
                errorMsg = boxCode + "状态不能入库!";
                MessagelogUtil.savelog(boxCode + "状态不能入库!");
                return false;
            }
            stockId=cs.id;

            List<CoreStockDetail> stockDetailsList = GetStockDetailList(connection,transaction,stockId);
            if (stockDetailsList.Count != 1) {
                errorMsg = boxCode + " 该托盘只能存放一个物料!";
                MessagelogUtil.savelog(boxCode + " 该托盘只能存放一个物料!");
                return false;
            }
            long itemId = long.Parse(stockDetailsList[0].itemId.ToString());
            List<CoreItem> coreItemList = GetItemList(connection,transaction,itemId);
            long itemClassifyId = coreItemList[0].classifyId;
            //一个物料类别对应多个区域
            AreaLocWeightDto dto = null;
            List<CoreClassifyArea> coreClassifyAreaList = GetCoreClsaaifyList(connection,transaction,itemClassifyId);
            for (int j = 0;j < coreClassifyAreaList.Count;j++) {
                AreaLocWeightDto tmp = getAreaLocWeightDto(connection,transaction,coreClassifyAreaList[j]);
                if (dto == null || tmp != null && tmp.weight > dto.weight) {
                    dto = tmp;
                }
            }
            if (dto == null|| dto.loc == null) {
                errorMsg = boxCode + "没有合适的库位!";
                MessagelogUtil.savelog(boxCode + "没有合适的库位!");
                return false;
            }
            CoreWhLoc loc = dto.loc;
              
            UpdataStock(connection,transaction,loc.id,loc.areaId,boxCode);
            UpdataStockDetail(connection,transaction,stockId);
            UpdataReceiptInDetail(connection,transaction,int.Parse(stockDetailsList[0].countDb.ToString()),long.Parse(stockDetailsList[0].receiptlnId.ToString()));
            WhReceiptIn inreceipt = getReceiptIn(connection,transaction,(long)stockDetailsList[0].receiptlnId);
            CommentFunction.InsertTask(connection,transaction,stockId,(int)loc.areaId,boxCode,inreceipt.inType,1,inreceipt.stn,(int)loc.id);
            CommentFunction.UpdataWhLoc(connection, transaction, loc.id);
            return true;

        }
        //根据托盘码查询corestock
        public  CoreStock GetStockList(IDbConnection Connection,IDbTransaction transaction,string boxCode) {
            string sql = @"select *from Core_stock where box_Code=@boxCode and status=0";
          List<CoreStock> stockList = Connection.Query<CoreStock>(sql,new { boxCode = boxCode
            },transaction).ToList();

                 if (stockList.Count != 1) {
               throw new Exception(boxCode + "数量异常!");
               
            }
            CoreStock cs = stockList[0];

            return cs;
        }
        //根据stockid查询明细
        public List<CoreStockDetail> GetStockDetailList(IDbConnection Connection,IDbTransaction transaction,long id) {
            string sql = @"select * from core_stock_detail where stock_Id=@id and stock_Status<>-1";
            return Connection.Query<CoreStockDetail>(sql,new {
                id = id
            },transaction).ToList();
        }
        //根据明细表里的物料编码查询物料信息(获取类别ID)
        public List<CoreItem> GetItemList(IDbConnection Connection,IDbTransaction transaction,long itemId) {
            string sql = @"select * from core_item where id=@itemId ";
            return Connection.Query<CoreItem>(sql,new {
                itemId = itemId
            },transaction).ToList();
        }
        //根据类别Id查询区域
        public List<CoreClassifyArea> GetCoreClsaaifyList(IDbConnection Connection,IDbTransaction transaction,long classifyId) {
            string sql = @"select * from core_classify_Area  where classify_Id=@classifyId order by Priority ";
            return Connection.Query<CoreClassifyArea>(sql,new {
                classifyId = classifyId
            },transaction).ToList();
        }
        //根据区域ID查询货位(可以入库，按orderNo排序)
        public List<CoreWhLoc> GetCoreLocList(IDbConnection Connection,IDbTransaction transaction,long areaId) {
            string sql = @"select * from Core_wh_Loc where area_Id=@areaId and Active_Status in (0,2) and stock_Count=0 order by order_No ";
            return Connection.Query<CoreWhLoc>(sql,new {
                areaId = areaId
            },transaction).ToList();
        }
        //修改库存库位信息
        public bool UpdataStock(IDbConnection Connection,IDbTransaction transaction,long locId,long areaId,string boxCode) {
            string sql = @"update Core_stock set loc_Id=@locId,area_Id=@areaId,status=1 where box_Code=@boxCode";
            Connection.Execute(sql,new {
                locId = locId,areaId = areaId,boxCode = boxCode
            },transaction);
            return true;
        }
        //修改库存库位信息
        public bool UpdataStockDetail(IDbConnection Connection,IDbTransaction transaction,long stockId) {
            string sql = @"update Core_stock_detail set stock_Status=1 where stock_Status=0 and stock_Id=@stockId";
            Connection.Execute(sql,new {
                stockId = stockId
            },transaction);
            return true;
        }
        //根据库存明细修改入库单明细
        public bool UpdataReceiptInDetail(IDbConnection Connection,IDbTransaction transaction,int activeCount,long receiptDetailId) {
            string sql = @"update Wh_Receipt_in_detail set active_Count=@activeCount where id=@receiptDetailId";
            Connection.Execute(sql,new {
                receiptDetailId = receiptDetailId,activeCount = activeCount
            },transaction);
            return true;
        }

        public WhReceiptIn getReceiptIn(IDbConnection Connection,IDbTransaction transaction,long receiptDetailId) {
            string sql = @"select a.* from  Wh_Receipt_in  a join Wh_Receipt_in_detail d on a.id=d.receipt_Id   where d.id=@receiptDetailId";
            List<WhReceiptIn> list = Connection.Query<WhReceiptIn>(sql,new {
                receiptDetailId = receiptDetailId
            },transaction).ToList();
            if (list.Count == 1) {
                return list[0];
            }

            return null;
        }
    }
    public class AreaLocWeightDto {
        public AreaLocWeightDto(long weight,CoreWhLoc loc) {
            this.loc = loc;
            this.weight = weight;

        }

        public AreaLocWeightDto() {
        }

        public long weight;
        public CoreWhLoc loc;

    }
}
