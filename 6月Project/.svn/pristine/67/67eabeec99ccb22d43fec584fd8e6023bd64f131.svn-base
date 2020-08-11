using GK.Common.dto;
using GK.DAL.inter;
using GK.WMS.Entity;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security.AccessControl;
using System.Text;

namespace GK.WMS.DAL
{
    public interface ICoreTaskServer : IBaseServer
    {
        Page<CoreTask> QueryCoreTaskPage<CoreTask>(CoreTaskDto dto);

        List<CoreTaskParam> GetListByTaskId(long taskId);

        bool UpdateStatusById(long id);

    }
}
