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
using System.Linq;
using System.Text;
using WMS.DAL;
using WMS.Entity;

namespace GK.WMS.DAL
{
    public class AbsReceiptPkServer : AbsWMSBaseServer, IReceiptPkServer
    {

        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();

        public Page<ReceiptPk> QueryReceiptPkPage<ReceiptPk>(ReceiptPkDto dto)
        {
            string sql = "select * from wh_Receipt_pk where 1=1 ";
            if (!string.IsNullOrEmpty(dto.banchNo))
            {
                dto.banchNo += "%" + dto.banchNo + "%";
                sql += " AND banch_No like @banchNo ";
            }
            if (dto.pkType != 0)
            {
                sql += " AND pk_Type = @pkType ";
            }
            if (dto.stn != 0)
            {
                sql += " AND stn = @stn ";
            }
            if (dto.status != 0)
            {
                sql += " AND status = @status ";
            }
            if (dto.itemId != 0)
            {
                sql += " AND item_Id = @itemId ";
            }
            return this.queryPage<ReceiptPk>(sql, "id", dto);
        }

        public int DeleteWhReceiptPk(List<WhReceiptPk> list)
        {
            foreach (var item in list)
            {
                Connection.Delete<WhReceiptPk>("id=" + item.id.ToString());
                DeleteDetailByReceptId(item.id);
            }
            return 1;
        }


        /// <summary>
        /// 生成任务
        /// </summary>
        /// <param name="model"></param>
        /// <param name="list"></param>
        /// <returns></returns>
        public long Generate(WhReceiptPk model, List<CoreStockParam> list)
        {
            using (var tran = Connection.BeginTransaction())
            {
                try
                {
                    CoreTask task = new CoreTask();
                    task.id = sequenceIdServer.getId();
                    task.stockId = list[0].id;
                    task.status = 1;//新建状态
                    task.createTime = sequenceIdServer.GetTime();
                    task.bussType = 1; //出库类型
                    task.taskType = 1; //任务类型
                    Connection.InsertNoNull<CoreTask>(task, tran);
                    foreach (var item in list)
                    {
                        //任务明细添加
                        CoreTaskParam param = new CoreTaskParam();
                        param.id = sequenceIdServer.getId();
                        param.detailId = item.stockDetailId;
                        param.wmsTaskId = param.id - 1; //task.id
                        param.status = 1;//新建状态
                        param.createTime = sequenceIdServer.GetTime();
                        Connection.InsertNoNull<CoreTaskParam>(param, tran);
                        //盘库明细的添加
                        WhReceiptPkDetail receiptPkdetail = new WhReceiptPkDetail();
                        receiptPkdetail.id = sequenceIdServer.getId();
                        receiptPkdetail.receptId = model.id;
                        receiptPkdetail.stockDetailId = item.stockDetailId;
                        Connection.InsertNoNull<WhReceiptPkDetail>(receiptPkdetail, tran);
                    }
                    tran.Commit();
                }
                catch (Exception ex)
                {
                    tran.Rollback();
                    return 0;
                }

            }
            return 1;
        }
        public void DeleteDetailByReceptId(long receptId)
        {
            string sql = @"DELETE FROM wh_Receipt_pk_detail where recept_Id=@receptId";
            Connection.Execute(sql, new { receptId = receptId });
        }

        //Pda盘库
        public List<WhReceiptPkDetail> getPkDetailsByBarCode(string barCode)
        {
            String sql = "select * from wh_Receipt_pk_detail where bar_Code=@barCode";
            return Connection.Query<WhReceiptPkDetail>(sql, new { barCode }).ToList();
        }

        public bool updatePkCountById(long id, int count)
        {
            string sql = @"update wh_Receipt_pk_detail set count=@count where id=@id";
            Connection.Execute(sql, new { id = id, count = count });
            return true;
        }

        public List<WhReceiptPkDetail> getPkDetailsByBoxCode(string boxCode)
        {
            String sql = "select * from wh_Receipt_pk_detail where box_Code=@boxCode and status=2";
            return Connection.Query<WhReceiptPkDetail>(sql, new { boxCode }).ToList();
        }
    }
}
