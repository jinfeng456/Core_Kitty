using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;

namespace GK.Xml.Msfx.upload
{
    public class MsfxDocument
    {

        public MsfxEvents Events = new MsfxEvents();






        private bool isbeaf(Object s)
        {
            Type type = s.GetType();
            if (type.Name == "String" || type.Name == "string" || type.IsEnum)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        private void addPropty(Object s, FieldInfo[] propertyInfos, StringBuilder builder)
        {
            foreach (FieldInfo inf in propertyInfos)
            {
                Object val = inf.GetValue(s);
                if (val == null)
                {
                    continue;
                }
                Type t = val.GetType();
                if (isbeaf(val))
                {//自定义类型
                    builder.Append(inf.Name);
                    builder.Append("= \"");
                    builder.Append(val);
                    builder.Append("\" ");
                }
            }
        }

        public string toXml(Object s, StringBuilder builder)
        {
            Type type = s.GetType();
            String name = type.Name;
            builder.Append("<").Append(name.Replace("Msfx","")).Append(" ");
            FieldInfo[] propertyInfos = type.GetFields();
            addPropty(s, propertyInfos, builder);//增加属性
            builder.Append(">");
            foreach (FieldInfo inf in propertyInfos)
            {//增加子类型
                Object val = inf.GetValue(s);
                if (val == null || isbeaf(val))
                {
                    continue;
                }
                if (val.GetType().FullName.IndexOf("List") > 0)
                {
                    IEnumerable<object> list = val as IEnumerable<object>;
                    foreach (Object obj in list)
                    {
                        if (isbeaf(val))
                        {
                            addBegin(builder, inf.Name);
                            builder.Append(val);
                            addEnd(builder, inf.Name);
                        }
                        else
                        {
                            toXml(obj, builder);
                        }
                    }
                }
                else
                {
                    toXml(val, builder);
                }
            }
            addEnd(builder, name.Replace("Msfx", ""));
            return builder.ToString();
        }
        void addBegin(StringBuilder builder, String Name)
        {
            builder.Append("<");
            builder.Append(Name);
            builder.Append(">");
        }

        void addEnd(StringBuilder builder, String Name)
        {
            builder.Append("</");
            builder.Append(Name);
            builder.Append(">");
        }



    }
}
