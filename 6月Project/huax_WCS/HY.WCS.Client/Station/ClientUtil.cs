using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using CMNetLib.Robots.CarrierChain;

namespace GK.WCS.Client {
    public class CU {
        public static Dictionary<MachineErrCode,Color> beltDict = new Dictionary<MachineErrCode,Color>();
        public static Dictionary<MachineStatus,Color> machineDict = new Dictionary<MachineStatus,Color>();
        static CU(){
            beltDict.Add(MachineErrCode.正常运行,Color.Cyan);
            beltDict.Add(MachineErrCode.急停,Color.Red);
            beltDict.Add(MachineErrCode.水平电机热继,Color.DarkBlue);
            beltDict.Add(MachineErrCode.水平运行超时,Color.Azure);
            beltDict.Add(MachineErrCode.有货无任务,Color.Beige);
            beltDict.Add(MachineErrCode.站位超时,Color.Bisque);
            beltDict.Add(MachineErrCode.超长,Color.BlanchedAlmond);
            beltDict.Add(MachineErrCode.超宽,Color.BurlyWood);
            beltDict.Add(MachineErrCode.超高,Color.CadetBlue);
            beltDict.Add(MachineErrCode.原点保护报警,Color.Chartreuse);
            beltDict.Add(MachineErrCode.旋转位保护报警,Color.Chocolate);
            beltDict.Add(MachineErrCode.旋转超时,Color.Coral);
            beltDict.Add(MachineErrCode.顶升超时,Color.CornflowerBlue);
            beltDict.Add(MachineErrCode.顶升电机热继,Color.Cornsilk);
            beltDict.Add(MachineErrCode.转向电机热继,Color.Crimson);
            beltDict.Add(MachineErrCode.有任务无货,Color.AliceBlue);
            machineDict.Add(MachineStatus.运行,Color.Cyan);
            machineDict.Add(MachineStatus.手动,Color.Yellow);
            machineDict.Add(MachineStatus.报警,Color.Red);
            machineDict.Add(MachineStatus.自动状态下停止,Color.DarkBlue);
        }

      public static  Color change(MachineErrCode status) {          
           return beltDict[status];
      }
        public static Color change(MachineStatus status) {

            return machineDict[status];
        }


        public static Dictionary<String,Color> getMachineErrCode() {
            Dictionary<String,Color> dict = new Dictionary<String,Color>();
            foreach(var d in beltDict) {
                dict.Add(d.Key.ToString(),d.Value);
            }
            return dict;

        }

        public static Dictionary<String,Color> getMachineStatus() {
            Dictionary<String,Color> dict = new Dictionary<String,Color>();
            foreach(var d in machineDict) {
                dict.Add(d.Key.ToString(),d.Value);
            }
            return dict;

        }
       


        public static string getForkStatus_CN(string craneErrCode) {

            Dictionary<string,string> dic = new Dictionary<string,string>();
         
            dic.Add("1","正常");
            dic.Add("2","载货台左超差");
            dic.Add("3","载货台右超差");

            dic.Add("4","取货位无货");
            dic.Add("5","取货后无货");
            dic.Add("6","放货时载货台无货");
            dic.Add("7","放货货位有货");
            dic.Add("8","放货后货叉有货");
            dic.Add("9","货叉不在中");

            dic.Add("10","货叉电机故障");
            dic.Add("13","前超差");
            dic.Add("14","后超差");

            var temp = craneErrCode.Split(',').ToList();
            string _result = string.Empty;
            if(temp != null && temp.Count > 0) {
                foreach(var item in temp) {
                    String key = item.Trim();
                    if(dic.ContainsKey(key)) {
                        _result += dic[key];
                    } else {
                        _result += key;
                    }
                   
                   
                }
            } else {
                _result = craneErrCode;
            }
            return _result;
        }


        public static string getCraneErrCode_CN(string craneErrCode) {

            Dictionary<string,string> dic = new Dictionary<string,string>();
            #region --翻译
            dic.Add("254","急停状态");
            dic.Add("1","正常");
            dic.Add("2","命令错误");
            dic.Add("3","提升电机故障");
            dic.Add("4","行走电机故障");
            dic.Add("5","货叉故障");
            dic.Add("6","水平测距故障");

            dic.Add("7","提升测距故障");
          
            dic.Add("11","电柜门打开");
            dic.Add("13","行走前极限");
            dic.Add("14","行走后极限");

            dic.Add("15","提升上极限");
            dic.Add("16","提升下极限");
            dic.Add("17","断绳报警");
      

            dic.Add("20","提升失速");
            dic.Add("21","24v电源跳电");
            dic.Add("22","变频器跳电");
            dic.Add("23","水平超速");
            dic.Add("24","刹车电阻超温");
            dic.Add("25","提升超载");
            dic.Add("255","运行超时");

            #endregion
            var temp = craneErrCode.Split(',').ToList();
            string _result = string.Empty;
            if(temp != null && temp.Count > 0) {
                foreach(var item in temp) {
                    String key = item.Trim();
                    if(dic.ContainsKey(key)) {
                        _result += dic[key];
                    } else {
                        _result += key;
                    }


                }
            } else {
                _result = craneErrCode;
            }
            return _result;
        }

        public static List<Pare> getShelves(int craneId) {
            List<Pare> list = new List<Pare>();
            if(craneId == 1) {
              
                list.Add(new Pare("1","货架1"));
                list.Add(new Pare("2","货架2"));
            } else
            if(craneId == 2) {
               
                list.Add(new Pare("3","货架3"));
                list.Add(new Pare("4","货架4"));
            } else
            if(craneId == 3) {
               
                list.Add(new Pare("5","货架5"));
                list.Add(new Pare("6","货架6"));
            }else if(craneId == 4) {

                list.Add(new Pare("7","货架7"));
                list.Add(new Pare("8","货架8"));
            }
            return list;

        }

        public static String[] getRow(String key ,int begin,int len) {
            List<String> list = new List<string>();
            String[] row = new String[len];
            for(int i = begin;i < len;i++) {
                
                list.Add(i.ToString("D2"));


            }
            return list.ToArray();
        }


    }

    public enum SemiAuto {
        行走 = 4,
        取货 = 2,
        放货 = 3
       

    }

}
