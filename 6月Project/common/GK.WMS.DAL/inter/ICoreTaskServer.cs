using Common.DAL.inter;
using Common.dto;
using GK.WMS.Entity;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security.AccessControl;
using System.Text;
using WMS.Entity;

namespace GK.WMS.DAL
{
    public interface ICoreTaskServer : IBaseServer
    {
        Page<CoreTask> QueryCoreTaskPage<CoreTask>(CoreTaskDto dto);

        List<CoreTaskParam> GetListByTaskId(long taskId);

        bool UpdateStatusById(long id);

    }
}
