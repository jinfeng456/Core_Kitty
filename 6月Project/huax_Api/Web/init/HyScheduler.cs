using System.Threading.Tasks;
using Quartz;
using Quartz.Impl;

namespace Web.job {
    public class HyScheduler {
        public async static Task Start() {
            // 1.创建scheduler的引用
            ISchedulerFactory schedFact = new StdSchedulerFactory();
            IScheduler sched = await schedFact.GetScheduler();
            //2.启动 scheduler
            await sched.Start();

            // 3.创建 job
            IJobDetail job = JobBuilder.Create<TimeJob>().WithIdentity("job1","group1").Build();
            // 4.创建 trigger
            ITrigger trigger = TriggerBuilder.Create().WithIdentity("trigger1","group1").WithSimpleSchedule(x => x.WithIntervalInSeconds(10).RepeatForever()).Build();

            // 5.使用trigger规划执行任务job
            await sched.ScheduleJob(job,trigger);

            // 3.创建 job
            IJobDetail job2 = JobBuilder.Create<SyncCodeJob>() .WithIdentity("job2","group2")  .Build();
            // 4.创建 trigger
            ITrigger trigger2 = TriggerBuilder.Create().WithIdentity("trigger2","group2").WithSimpleSchedule(x => x.WithIntervalInSeconds(10).RepeatForever()).Build();
            // 5.使用trigger规划执行任务job
            await sched.ScheduleJob(job2,trigger2);

        }

    }
}