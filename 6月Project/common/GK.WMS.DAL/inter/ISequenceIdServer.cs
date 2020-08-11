﻿
using GK.DAL.inter;
using System;
using System.Data;

namespace GK.WMS.DAL
{
    public interface ISequenceIdServer : IBaseServer
    {
        long getId();
        DateTime GetTime();

        string GetSerial(string tableName, int businessType = 0, string description = "");

    }
}
