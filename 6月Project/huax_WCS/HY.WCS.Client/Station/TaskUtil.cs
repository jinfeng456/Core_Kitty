using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using WCS.Entity;

namespace GK.WCS.Client {
    public class TaskUtil {
        public static List<BaseTask> margin<T1, T2>(List<T1> l1,List<T2> l2) where T1 : BaseTask
                                                           where T2 : BaseTask {
            List<BaseTask> resList = new List<BaseTask>();
            T1 t1 = null;
            T2 t2 = null;
            if (l1==null)
            {
                l1 = new List<T1>();
            }
            if (l2==null)
            {
                l2 = new List<T2>();
            }
            while(true) {

                if (l1.Count > 0 && t1 == null)
                {
                    t1 = l1[0];
                }
                if (l2.Count > 0 && t2 == null)
                {
                    t2 = l2[0];
                }

                if (t1 == null && t2 == null) {
                    break;
                } else if(t1 == null && t2 != null) {
                    resList.Add(t2);
                    l2.Remove(t2);
                    t2 = null;
                } else if(t1 != null && t2 == null) {
                    resList.Add(t1);
                    l1.Remove(t1);
                    t1 = null;
                } else {
                    if(t1.id > t2.id) {
                        resList.Add(t2);
                        l2.Remove(t2);
                        t2 = null;
                    } else {
                        resList.Add(t1);
                        l1.Remove(t1);
                        t1 = null;
                    }
                }
            }
            return resList;
        }


        private static Object lockObj = new Object();

    }
}
