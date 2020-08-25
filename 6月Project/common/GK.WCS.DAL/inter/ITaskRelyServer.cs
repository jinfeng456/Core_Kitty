using Common.DAL.inter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using WCS.Entity;

namespace GK.WCS.DAL
{
    public interface ITaskRelyServer : IBaseServer
    {
        List<TaskRely> getByCompleteId(long completeId);
        void deleteByCompleteId(long completeId);
    }
}
