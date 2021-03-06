﻿using Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;

namespace GK.BACK.DAL
{
   public static class FmxtDalFactray
    {

        //public const GKDBType prefixal = GKDBType.oracle;
        public const GKDBType prefixal = GKDBType.sqlserver;
        public static T getDal<T>() {
            Type type = typeof(T);
            String fullName = type.FullName;
            int index = fullName.LastIndexOf(".") + 1;
            String dllName = fullName.Substring(0, index) + prefixal + "." + fullName.Substring(index + 1);
            Type implType = Type.GetType(dllName);//加载类型
            T t = (T)Activator.CreateInstance(implType);
            return t;
        }
    }
}
