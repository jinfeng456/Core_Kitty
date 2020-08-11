using GK.Common.dto;
using GK.DAL.inter;
using GK.WCS.dto;
using GK.WCS.Entity;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace GK.WCS.DAL {
    public interface ITaskCraneServer : ITaskCraneServerBase {

     

        List<TaskCrane> getTaskCraneByCraneId(long id) ;

      
        TaskCrane getTaskCraneByTaskNo(int taskNo);

        TaskCrane getTaskCraneByCompleteId(long id);
        List<TaskCrane> getTaskCraneByStatus();
        List<TaskCrane> getTaskCraneBycompleteId(long completeId) ;
        /// <summary>
        /// 当前堆垛机货叉是否存在未执行完的任务
        /// 包括执行中和待执行的任务
        /// </summary>
        List<TaskCrane> getWorkingTask(int craneId, int dir1,int dir3) ; 
      
   
        //需要reset 货叉号
        bool resetTaskStatus(long id);
        //货叉号不动
        bool finshTaskStatus(long id);

        bool UpdateTaskPriorityById(long id, int Priority) ;
        bool UpdateTaskPriorityByCompleteId(long id, int Priority) ; 

        /// <summary>
        /// 判断任务完成状态是否已经更新到数据库了
        /// </summary>
        bool IsTaskFinished(int taskNo, int Status) ;

     
        
       

        bool DeleteCraneTask(long completeId);

        bool ResetCraneTaskById(long taskId);

        bool FinishCraneTaskById(long taskId);
        bool DeleteCraneAndCarrierTask(long completeId);
        List<TaskCrane> getAllOutCraneTask();
        List<TaskCrane> getAllInCraneTask();

        List<TaskCrane> GetCraneTaskByCode(string code, IDbTransaction transaction = null);

        List<TaskCrane> getWorkingCraneTask();
        List<TaskCrane> AllocateOutCraneTask(int point);
        List<TaskCrane> AllocateInCraneTask(int TaksNo);

    }
}
