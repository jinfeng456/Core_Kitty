using Common.DAL.inter;
using Common.dto;
using GK.WMS.Entity;
using GK.WMS.Entity.dto;
using GK.WMS.Entity.wms;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace GK.WMS.DAL
{
    public interface IReceiptPkServer : IBaseServer
    {
        Page<ReceiptPk> QueryReceiptPkPage<ReceiptPk>(ReceiptPkDto dto);
        int DeleteWhReceiptPk(List<WhReceiptPk> userList);


        long Generate(WhReceiptPk model, List<CoreStockParam> list);

        List<WhReceiptPkDetail> getPkDetailsByBarCode(string barCode);

        List<WhReceiptPkDetail> getPkDetailsByBoxCode(string boxCode);

        //根据id修改盘库明细数量
        bool updatePkCountById(long id,int count);
    }
}
