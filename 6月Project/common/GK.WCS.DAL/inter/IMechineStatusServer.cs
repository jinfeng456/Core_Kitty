using Common.DAL.inter;
using System;
namespace GK.WCS.DAL
{
    public interface IMechineStatusServer : IBaseServer
    {
       
        int GetCraneOverStop(int craneId);

        int GetCraneRunStatus(int craneId);
        bool UpdateCraneOverStop(int craneId, int value);
        bool Update(int id, int runStatus);
    }
}
