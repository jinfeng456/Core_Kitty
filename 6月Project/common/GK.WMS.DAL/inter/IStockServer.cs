﻿using Common.DAL.inter;
using GK.WMS.Entity;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace GK.WMS.DAL
{
    public interface IStockServer : IBaseServer
    {
        //WCS完成任务反馈WMS
        bool completeFeedback();

        List<DapingDto>  getDapingDto(int id);
    }
}
