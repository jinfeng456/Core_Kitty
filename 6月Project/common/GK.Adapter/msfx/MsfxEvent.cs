﻿using GK.Xml.Msfx.upload.eventData;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.Xml.Msfx.upload
{
    public class MsfxEvent
    {
        public MsfxEventType Name;
        public String PreAction;
        public String MainAction;
        public String AfterAction;
        public String Comment;
        public MsfxActionMapping MsfxActionMapping;
        public MsfxDataMaping MsfxDataMaping;
        public MsfxDataDesc MsfxDataDesc;
        public MsfxDataField MsfxDataField;
        public MsfxDataFieldEx MsfxDataFieldEx;

    }


    public enum MsfxEventType
    {

        PurchaseWareHouseIn = 101,//批发(物流)企业普通采购入库举例，该举例适用于采购入库、调拨入库、退货入库。生产企业生产入库按照上游企业出库单不存在处理,FromCorpID为空
        ReturnWareHouseIn = 102,//召回入库
        ProduceWareHouseIn = 103,// 生产入库
        AllocateWareHouseIn = 104,//调拨入库
        GiftHouseIn = 105, //<!--赠品入库-->
        IncomeHouseIn = 106,//<!--盘盈入库-->
        ScrapHouseIn = 107, //<!--报废入库-->
        OtherHouseIn = 199, //<!--其他入库-->

        SalesWareHouseOut = 201,//经营企业普通销售出库
        ReturnWareHouseOut = 202,// 退货出库,召回出库
        AllocateWareHouseOut = 203,//调拨出库
        ReworkWareHouseOut = 204,//返工出库
        DestoryWareHouseOut = 205,//销毁出库
        CheckWareHouseOut = 206,//抽检出库
        DirectAllocateWareHouseOut = 207,
        GiftHouseOut = 208, //<!--赠品出库-->
        LossHouseOut = 209, //<!--盘亏出库-->
        DamageHouseOut = 210, //<!--损坏出库-->
        ScrapHouseOut = 211,//<!--报废出库-->
        OtherHouseOut = 299, //<!--其他出库-->

        CodeReplace = 301,
        CodeDestory = 302,//<!--码注销-->
        PK = 401
   
    }
}
