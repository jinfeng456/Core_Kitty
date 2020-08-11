
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Data.Common;
using Dapper;
using System.Collections.Generic;

using GK.WMS.Entity;
using GK.WMS.DAL;
using GK.Common;
using GK.Common.trans;
using GK.WMS.Entity.wms;
using GK.Engine.WMS.wms.stockOut;
using System.Linq;

namespace GK.Engine.WMS
{
    public abstract class StockOutEngine : WmsBaseEngine
    {//原则总体出库数量最少
        public long whReceiptId;
        public int stn;
        IReceiptOutServer receiptOutServer = WMSDalFactray.getDal<IReceiptOutServer>();
        protected override bool Execute(IDbConnection connection, IDbTransaction transaction,ref string errorMsg)
        {

            List<WhReceiptOutDetail> details = receiptOutServer.getDetials(whReceiptId);//获取出库单明细
            List<List<CoreStockDetail>> stockDetail = getAllDetail(details);//获取可选项托盘
            List<List<DetailSelectDto>> all = getAllPossible(details, stockDetail);//获取所有的单托盘组合
            List<List<DetailSelectDto>> baseList = new List<List<DetailSelectDto>>();
            getLis(all, 0, new List<DetailSelectDto>(), baseList);//获取所有多托盘组合



            List<WhReceiptDetailDto> needList = new List<WhReceiptDetailDto>();//需要数量合并相同的物料与批次
            List<StockDto> stockDtoList = initDto(stockDetail);//可用货位
            StockDto sto = oneStock(stockDtoList, needList);
            return true;
        }
        /*
         *找出货位最少的组合 
         */

        void getLis(List<List<DetailSelectDto>> all, int receiptDetailid, List<DetailSelectDto> list, List<List<DetailSelectDto>> baseList)
        {
            if (all.Count == receiptDetailid)
            {
                List<long> stockList = new List<long>();
                foreach (DetailSelectDto dto in list)
                {
                    foreach (CoreStockDetail detail in dto.selected)
                    {
                        if (!stockList.Contains(detail.stockId ?? 0))
                        {
                            stockList.Add(detail.stockId ?? 0);
                        }
                    }
                }
                if (baseList.Count == 0)
                {
                    baseList.Add(new List<DetailSelectDto>(list));//
                }
                else
                {
                    if (baseList[0].Count == list.Count)
                    {
                        baseList.Add(new List<DetailSelectDto>(list));
                    }
                    else if (baseList[0].Count > list.Count)
                    {
                        baseList.Clear();
                        baseList.Add(new List<DetailSelectDto>(list));
                    }
                }
            }
            List<DetailSelectDto> oneDetail = all[receiptDetailid];
            for (int index = 0; index < oneDetail.Count; index++)
            {//第几个类别选一个
                list.Add(oneDetail[index]);
                if (all.Count < receiptDetailid)
                {
                    getLis(all, receiptDetailid + 1, list, baseList);
                }
            }
        }




        Dictionary<long, int> getWeight(List<DetailSelectDto> allSelect)
        {
            Dictionary<long, int> dict = new Dictionary<long, int>();
            foreach (DetailSelectDto dto in allSelect)
            {
                foreach (CoreStockDetail detail in dto.selected)
                {
                    if (dict.ContainsKey(detail.id))
                    {
                        dict[detail.id]++;
                    }
                    else
                    {
                        dict.Add(detail.id, 1);
                    }
                }
            }

            Dictionary<long, int> dic1_SortedByKey = dict.OrderBy(o => o.Value).ToDictionary(p => p.Key, o => o.Value);
            return dic1_SortedByKey;
        }

        List<List<DetailSelectDto>> getAllPossible(List<WhReceiptOutDetail> details, List<List<CoreStockDetail>> stockDetail)
        {


            List<List<DetailSelectDto>> all = new List<List<DetailSelectDto>>();//所有入库单的所有可能
            for (int i = 0; i < details.Count; i++)
            {
                List<DetailSelectDto> allSelect = new List<DetailSelectDto>();//单个类似的所有可选
                res(stockDetail[i], 0, (int)details[i].planCount, new DetailSelectDto(), allSelect);
                allSelect.Sort();
                all.Add(allSelect);
            }

            return all;
        }

        //获取可选项
        List<List<CoreStockDetail>> getAllDetail(List<WhReceiptOutDetail> details)
        {
            List<List<CoreStockDetail>> stockDetail = new List<List<CoreStockDetail>>();
            foreach (WhReceiptOutDetail outDetail in details)
            {
                stockDetail.Add(getStockDetail(outDetail)); //获取可选的明细
            }
            return stockDetail;
        }

        /**
         * optons  待选去
         * index 遍历第几个
         * count 剩余数量
         * selectList 选择数量
         * 
         * allSelect 所有的选择
         * */
        void res(List<CoreStockDetail> optons, int index, int? count, DetailSelectDto selectDto, List<DetailSelectDto> allSelect)
        {
            if (optons.Count == index)
            {//当前分支没有可选项
                return;
            }
            DetailSelectDto noSelectList = selectDto.Clone();
            res(optons, index + 1, count, noSelectList, allSelect);//不包含当前节点

            if (count <= 0)
            {//找到一种可能
                allSelect.Add(selectDto);
                return;
            }
            CoreStockDetail detail = optons[index];
            selectDto.add(detail);
            res(optons, index + 1, count - detail.countDb, selectDto, allSelect);//选中当前节点
        }

        StockDto oneStock(List<StockDto> stockDtoList, List<WhReceiptDetailDto> needList)
        {
            foreach (StockDto dto in stockDtoList)
            {//遍历货位
                bool select = true;
                foreach (WhReceiptDetailDto receiptDetail in needList)
                {//计划明细
                    int? remain = receiptDetail.count;
                    remain = dto.remain(receiptDetail, remain);
                    if (remain > 0)
                    {//还有剩余没有分配
                        select = false;
                        break;
                    }
                }
                if (select)
                {
                    return dto;
                }
            }
            return null;
        }


        List<StockDto> initDto(List<List<CoreStockDetail>> stockDetail)
        {
            List<StockDto> stockDtoList = new List<StockDto>();
            foreach (List<CoreStockDetail> detailList in stockDetail)
            {
                foreach (CoreStockDetail detail in detailList)
                {
                    bool add = false;
                    foreach (StockDto stockDto in stockDtoList)
                    {

                        if (stockDto.add(detail))
                        {
                            add = true;
                            break;
                        }
                    }
                    if (!add)
                    {
                        stockDtoList.Add(new StockDto(detail));
                    }

                }
            }

            return stockDtoList;
        }



        public abstract List<CoreStockDetail> getStockDetail(WhReceiptOutDetail detail);




    }
}
