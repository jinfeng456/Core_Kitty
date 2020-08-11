﻿using Dapper;
using GK.WCS.DAL;
using GK.WCS.DAL.abs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WCS.DAL.oracle {
    public class SequenceIdServer : AbsSequenceIdServer, ISequenceIdServer {
        public override long querySequence() {
           return Connection.Query<long>("SELECT  SEQUENCES_ID.NEXTVAL FROM dual").Single();
        }
    }
}
