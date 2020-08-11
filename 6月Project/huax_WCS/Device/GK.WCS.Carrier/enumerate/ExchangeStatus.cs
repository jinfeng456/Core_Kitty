﻿

namespace HY.WCS.Carrier {

    public enum ExchangeStatus {
        /// <summary>
        ///     初始化状态
        /// </summary>
        INIT = 0,
        /// <summary>
        ///     新任务，尚未执行
        /// </summary>
        NewTask = 1,

        /// <summary>
        ///     下位已接收，可以写新任务
        /// </summary>
        PLCReadFinish = 2,
        /// <summary>
        ///     上位通知下位动作，下位不收到3不可以动作。（目的：防止上位网络发送任务返回失败，但是PLC已经收到任务并直接执行的情况）
        /// </summary>
        PLCDoAction = 3
    }
}
