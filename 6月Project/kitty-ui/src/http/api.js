﻿/*
 * 接口统一集成模块
 */
import * as login from "./moudules/sys/login";
import * as user from "./moudules/sys/user";
import * as dept from "./moudules/sys/dept";
import * as role from "./moudules/sys/role";
import * as menu from "./moudules/sys/menu";
import * as dict from "./moudules/sys/dict";
import * as wcslog from "./moudules/sys/wcslog";
import * as log from "./moudules/sys/log";
import * as dictClass from "./moudules/sys/dictClass";
import * as coreStock from "./moudules/wh/coreStock";
import * as coreTask from "./moudules/wh/coreTask";
import * as classify from "./moudules/Basic/Matertial/classify";
import * as receipt from "./moudules/Business/whReceipt/receiptOut";
import * as receiptIn from "./moudules/Business/whReceipt/receiptIn";
import * as item from "./moudules/Basic/Matertial/item";
import * as stat from "./moudules/stat/stat";
import * as batch from "./moudules/wh/batch";
import * as audit from "./moudules/wh/audit";
import * as corewh from "./moudules/Basic/CoreWh/corewh";
import * as corewharea from "./moudules/Basic/CoreWh/corewharea";
import * as corewhloc from "./moudules/Basic/CoreWh/corewhloc";
import * as whReceiptPk from "./moudules/Business/whReceipt/receiptPk";
import * as whSoOut from "./moudules/Business/Purchase/whSoOut";
import * as warehousein from "./moudules/Business/Purchase/warehousein";
import * as sales from "./moudules/Business/Purchase/sales";
import * as produce from "./moudules/Business/Purchase/produce";
import * as classifyarea from "./moudules/Basic/Matertial/classifyarea";
import * as exports from "./moudules/file/exports";
import * as corewhgro from "./moudules/Basic/CoreWh/corewhgro";
import * as corewhgroitem from "./moudules/Basic/CoreWh/corewhgroitem";
import * as coreCodeInfo from "./moudules/wh/coreCodeInfo";
import * as sysCode from "./moudules/sys/sysCode";
import * as whSoIn from "./moudules/wh/whSoIn"; 
import * as statReal from "./moudules/Business/report/statReal";
import * as statMonth from "./moudules/Business/report/statMonth";

// 默认全部导出
export default {
  login,
  user,
  dept,
  role,
  menu,
  dict,
  wcslog,
  log,
  dictClass,
  coreStock,
  coreTask,
  classify,
  receipt,
  receiptIn,
  item,
  stat,
  batch,
  audit,
  stat,
  corewh,
  corewharea,
  corewhloc,
  whReceiptPk,
  whSoOut,
  whReceiptPk,
  warehousein,
  sales,
  produce,
  classifyarea,
  exports,
  corewhgroitem,
  corewhgro,
  coreCodeInfo,
  sysCode,
  whSoIn,
  statReal,
  statMonth
};
