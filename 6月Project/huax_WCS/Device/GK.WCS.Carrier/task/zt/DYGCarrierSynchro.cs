using System;
using System.Collections.Generic;
using System.IO;
using GK.WCS.DAL;
using WCS.Carrier;
using WCS.Carrier.dto;
using WCS.Carrier.enumerate;

namespace GK.WCS.Carrier {
    public abstract class DYGCarrierSynchro : CarrierSynchro
    {

        static DYGCarrierSynchro()
        {
            //一楼左侧1号PLC
            int[] arrOne = new int[] { 1000, 1003, 1006, 1010, 1083, 1084, 1089, 1090, 1091, 1092, 1093, 1094, 1095, 1096, 1097, 1098, 1099, 1100, 1101, 1102, 1103, 1104, 1105, 1106, 1107, 1108, 1109, 1110 };
            for (int i = 0; i < arrOne.Length; i++)
            {
                CarrierPoint.carrierPoint.Add(arrOne[i], new PlcCarrierPoint(arrOne[i], i * 22 + 4, i * 24, 1));
            }

            //一楼右侧2号PLC
            int[] arrTwo = new int[] { 1200, 1203, 1206, 1210, 1216, 1219, 1222, 1233, 1234 };
            for (int i = 0; i < arrTwo.Length; i++)
            {
                CarrierPoint.carrierPoint.Add(arrTwo[i], new PlcCarrierPoint(arrTwo[i], i * 22 + 4, i * 24, 2));
            }

            //一楼右侧3号PLC
            int[] arrThree = new int[] { 1357, 1358, 1359, 1360, 1361, 1362, 1363, 1364, 1365, 1366, 1367, 1368, 1369, 1370, 1371, 1372, 1373, 1374, 1375 };
            for (int i = 0; i < arrThree.Length; i++)
            {
                CarrierPoint.carrierPoint.Add(arrThree[i], new PlcCarrierPoint(arrThree[i], i * 22 + 4, i * 24, 3));
            }

            //二楼左侧4号PLC
            int[] arrFour = new int[] { 2001, 2026, 2027, 2028, 2029, 2030, 2031, 2032, 2033, 2034, 2035, 2036 };
            for (int i = 0; i < arrFour.Length; i++)
            {
                CarrierPoint.carrierPoint.Add(arrFour[i], new PlcCarrierPoint(arrFour[i], i * 22 + 4, i * 24 + 6, 4));
            }

            //二楼右侧5号PLC
            int[] arrFive = new int[] { 2201, 2209, 2210, 2211, 2317, 2318, 2319, 2320, 2321, 2322, 2323, 2324 };
            for (int i = 0; i < arrFive.Length; i++)
            {
                CarrierPoint.carrierPoint.Add(arrFive[i], new PlcCarrierPoint(arrFive[i], i * 22 + 4, i * 24 + 6, 5));
            }

        }
        }
    }
