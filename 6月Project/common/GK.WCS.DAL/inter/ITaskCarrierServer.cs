
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System;
using GK.WCS.Entity;
using System.Data;
using GK.DAL.inter;

namespace GK.WCS.DAL {
    public interface ITaskCarrierServer : IBaseServer
    {
        bool UpdateTaskCarrierStatus(int taskNo,int status, IDbTransaction transaction = null);
        bool finshTaskCarrier(long id, IDbTransaction transaction = null);
        TaskCarrier getCarrarTasksByTaskNo(int taskNo, IDbTransaction transaction = null);
        List<TaskCarrier> getOutCarrirerCodes(int start, IDbTransaction transaction = null);
        List<TaskCarrier> getCarrarTasksByStn(int from, int end, IDbTransaction transaction = null);        

        List<TaskCarrier> getCarrierTaskByComId(long completeId, IDbTransaction transaction = null);

        TaskCarrier getCarrierTaskByCompleteId(long id);
        TaskCarrier getCarrierTask(int startPoint);

        TaskCarrier getByCode(String code, IDbTransaction transaction = null);

        bool DeleteCarrierTask(long completeId, IDbTransaction transaction = null);

        bool ResetCarrierTaskById(long taskId, IDbTransaction transaction = null);

        bool FinishCarrierTaskById(long taskId, IDbTransaction transaction = null);
        TaskCarrier getInCarrirerTask(int boxcode, int status);
        List<TaskCarrier> getAllOutCarrirerTask();
        List<TaskCarrier> getAllInCarrirerTask();

        List<TaskCarrier> GetCarrierTaskByCode(string code, IDbTransaction transaction = null);


        List<TaskCarrier> getWorkingCarrierTask();
    }
}
