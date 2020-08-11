using GK.Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WCS.Entity
{
    [Serializable]
    public  class TaskRely : BaseEntity
    {
   
        public TaskRely()
		{}
     

        public long taskId
        {
            get; set;
        }

        public String taskName
        {
            get; set;
        }
        public long relyId
        {
            get; set;
        }
        public String relyName
        {
            get; set;
        }
        public long completeId
        {
            get; set;
        }

    }
}
