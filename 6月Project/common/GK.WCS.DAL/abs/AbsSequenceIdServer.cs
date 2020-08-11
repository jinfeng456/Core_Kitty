﻿using System;
using System.Text;
using System.Linq;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
using Dapper;
using static Dapper.SqlMapper;
using GK.Common.dto;
using GK.Common;
using GK.DAL.inter;
using GK.DAL.dialect;


namespace GK.WCS.DAL.abs
{
    public abstract class AbsSequenceIdServer : AbsWCSBaseServer, ISequenceIdServer

    {
       static long SEQUENCES_ID = 0;
        static int index = 0;

        public long getId() {
            lock (this) {
                long id = 0;
                if (SEQUENCES_ID == 0 || index == 99) {
                    SEQUENCES_ID = querySequence();
                    index = 0;
                }
                index++;
                id = SEQUENCES_ID * 100 + index;
                return id;

            }

        }

        public abstract long querySequence();
    }
}
