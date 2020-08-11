using Dapper;
using GK.WMS.DAL.abs;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace GK.WMS.DAL.sqlserver {
    public class SequenceIdServer : AbsSequenceIdServer, ISequenceIdServer {
        public override long querySequence() {
           return Connection.Query<long>("SELECT NEXT VALUE FOR sequence_id").Single();
        }
    }
}
