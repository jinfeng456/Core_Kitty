using System;
using System.Net.Sockets;
using System.Text;
using WCS.Common.task;

namespace GK.WCS.Scan {


    public class DateLogicReader1:DateLogicReader {//裸光纤入库扫码
        public override DateLogicConnectTask getConnectTask() {
            return TaskPool.get<DateLogicConnectTask1>();
        }
    }
    public class DateLogicReader2:DateLogicReader {//出库口扫码
        public override DateLogicConnectTask getConnectTask() {
            return TaskPool.get<DateLogicConnectTask2>();
        }
    }
    public class DateLogicReader3:DateLogicReader {
        public override DateLogicConnectTask getConnectTask() {
            return TaskPool.get<DateLogicConnectTask3>();
        }
    }
    public class DateLogicReader4:DateLogicReader {
        public override DateLogicConnectTask getConnectTask() {
            return TaskPool.get<DateLogicConnectTask4>();
        }
    }
    public class DateLogicReader5:DateLogicReader {
        public override DateLogicConnectTask getConnectTask() {
            return TaskPool.get<DateLogicConnectTask5>();
        }
    }

}
