﻿using Common.DAL.inter;
using GK.WMS.Entity;
using GK.WMS.Entity.wms;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using WMS.Entity;

namespace GK.WMS.DAL
{
    public interface ITaskServer : IBaseServer
    {
        List<CoreTask> getAllUnSyncTask();

        List<CoreTask> GetInTask(string code);
        List<CoreTaskParam> getTaskParam(long taskId);
        void updateTaskStatus(long id, int status);
        void updateTaskParamStatus(long paramId, int status);


        #region 入库完成
        //根据入库任务的id来获取入库任务信息(taskStatus=3)
        List<CoreTask> GetCoreTask(long taskId);
        //根据入库任务ID得到入库明细任务
        List<CoreTaskParam> GetCoreTaskParam(long taskId);
        //根据库存明细Id获取其他信息
        List<CoreStockDetail> GetCoreStockDetail(long id);
        //任务明细删除
        int DeleteTaskParam(List<CoreTaskParam> taskParamList);
        //任务删除
        int DeleteTask(List<CoreTask> taskList);
        //修改任务状态和完成时间
        bool UpdataTask(long id);
        //修改任务明细状态和完成时间
        bool UpdataTaskParam(long id);
        //修改库存状态
        bool UpdataStock(long id);
        //修改库存明细状态
        bool UpdataStockDetail(long id);
        //根据入库单明细查入库单
        List<WhReceiptInDetail> GetWhReceiptInDetail(long id);
        //修改入库单状态和完成时间
        bool UpdataWhReceiptIn(long id);
        //根据入库订单明细查入库订单
        List<WhSoInDetail> GetWhSoDetail(long id);
        //修改入库订单状态和完成时间
        bool UpdataWhSoIn(long id);
        //根据id修改批次数量
        bool UpdataBatchCount(long id,int count);
        #endregion

        #region 入库完成
        //修改库存状态
        bool UpdataStockOut(long id);
        //修改库存明细状态
        bool UpdataStockDetailOut(long id);


        //根据出库单明细查出库单
        List<WhReceiptOutDetail> GetWhReceiptOutDetail(long id);
        //修改出库单状态和完成时间
        bool UpdataWhReceiptOut(long id);
        //根据出库订单明细查出库订单
        List<WhSoOutDetail> GetWhSoOutDetail(long id);
        //修改出库订单状态和完成时间
        bool UpdataWhSoOut(long id);
        #endregion
    }
}
