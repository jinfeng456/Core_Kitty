/*
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
import * as classify from "./moudules/Basic/Matertial/classify";
import * as item from "./moudules/Basic/Matertial/item";
import * as exports from "./moudules/file/exports";
import * as sysCode from "./moudules/sys/sysCode";


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
  classify,
  item,
  exports,
  sysCode
};
