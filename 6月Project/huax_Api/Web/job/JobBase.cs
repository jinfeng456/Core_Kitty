using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Common.entity;
using Mongon.DAL;
using Quartz;
using Quartz.Impl;

namespace Web.job {
  
    public abstract class JobBase:IJob {
        
      
        private static int working = 0;

      private static  Dictionary<String,int> workingDict=new Dictionary<String,int>();

        Task IJob.Execute(IJobExecutionContext context) {
               String name = this.GetType().FullName;
            lock(this) {
             
                if (!workingDict.ContainsKey(name)) {
                    workingDict.Add(name,1);
                }else if(workingDict[name]==1) {
                      return Task.CompletedTask;
                } else {
                    workingDict[name]=1;
                }
            }
            try {
               excute();
             
            } catch(Exception e) {
                addLogger("upload Exception",e.Message);
            } finally {
                   workingDict[name]=0;
            }
            
            return Task.CompletedTask;
        }

       
        public abstract void excute();

       

        void addLogger(String param, String info) {

            HttpLog log = new HttpLog();
            log.urlName = this.GetType().Name;
            log.param = param;
            log.result = info;
            log.ip = "";
            HttpClientLogUtil.save(log);
        }
    }

}