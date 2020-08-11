using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace GK.WCS.Entity
{
    [Serializable]
    public  class TaskCarrier:BaseTask {

       public TaskCarrier() { }
        public int startPath
        {
            get; set;
        }
      
        public int endPath
        {
            get; set;
        }

        public int itemType
        {
            get; set;
        }

    }
}
