using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WCS.Carrier.enumerate
{
    public class CarrierPoint
    {
        public static Dictionary<int, PlcCarrierPoint> carrierPoint = new Dictionary<int, PlcCarrierPoint>();
         static CarrierPoint()
        {                
            carrierPoint.Add(1000, new PlcCarrierPoint(1000, 0, 6,1));
            carrierPoint.Add(1003, new PlcCarrierPoint(1003, 28, 30,1 ));
            carrierPoint.Add(1006, new PlcCarrierPoint(1006, 56, 54,1 ));
            carrierPoint.Add(1010, new PlcCarrierPoint(1010, 84, 78,1 ));
            carrierPoint.Add(1083, new PlcCarrierPoint(1083, 112, 102,1 ));
            carrierPoint.Add(1084, new PlcCarrierPoint(1084, 140, 126,1 ));
            carrierPoint.Add(1089, new PlcCarrierPoint(1089, 168, 150,1 ));
            carrierPoint.Add(1090, new PlcCarrierPoint(1090, 196, 174,1 ));
            carrierPoint.Add(1091, new PlcCarrierPoint(1091, 224, 198,1 ));
            carrierPoint.Add(1092, new PlcCarrierPoint(1092, 250, 222,1 ));
            carrierPoint.Add(1093, new PlcCarrierPoint(1093, 278, 246,1 ));
            carrierPoint.Add(1094, new PlcCarrierPoint(1094, 306, 270,1 ));
            carrierPoint.Add(1095, new PlcCarrierPoint(1095, 334, 294,1 ));
            carrierPoint.Add(1096, new PlcCarrierPoint(1096, 362, 318,1 ));
            carrierPoint.Add(1097, new PlcCarrierPoint(1097, 390, 342,1 ));
            carrierPoint.Add(1098, new PlcCarrierPoint(1098, 418, 366,1 ));
            carrierPoint.Add(1099, new PlcCarrierPoint(1099, 446, 390,1 ));
            carrierPoint.Add(1100, new PlcCarrierPoint(1100, 474, 414,1 ));
            carrierPoint.Add(1101, new PlcCarrierPoint(1101, 502, 438,1 ));
            carrierPoint.Add(1102, new PlcCarrierPoint(1102, 530, 462,1 ));
            carrierPoint.Add(1103, new PlcCarrierPoint(1103, 558, 486,1 ));
            carrierPoint.Add(1104, new PlcCarrierPoint(1104, 586, 510,1 ));
            carrierPoint.Add(1105, new PlcCarrierPoint(1105, 614, 534,1 ));
            carrierPoint.Add(1106, new PlcCarrierPoint(1106, 642, 558,1 ));
            carrierPoint.Add(1107, new PlcCarrierPoint(1107, 670, 582,1 ));
            carrierPoint.Add(1108, new PlcCarrierPoint(1108, 698, 606,1 ));
            carrierPoint.Add(1109, new PlcCarrierPoint(1109, 726, 630,1 ));
            carrierPoint.Add(1110, new PlcCarrierPoint(1110, 754, 654,1 ));

            carrierPoint.Add(1200, new PlcCarrierPoint(1200, 782, 678,2 ));
            carrierPoint.Add(1203, new PlcCarrierPoint(1203, 810, 702,2 ));
            carrierPoint.Add(1206, new PlcCarrierPoint(1206, 838, 726,2 ));
            carrierPoint.Add(1210, new PlcCarrierPoint(1210, 866, 750,2 ));
            carrierPoint.Add(1216, new PlcCarrierPoint(1216, 894, 774,2 ));
            carrierPoint.Add(1219, new PlcCarrierPoint(1219, 922, 798,2 ));
            carrierPoint.Add(1222, new PlcCarrierPoint(1222, 950, 822,2 ));
            carrierPoint.Add(1233, new PlcCarrierPoint(1233, 978, 846,2 ));
            carrierPoint.Add(1234, new PlcCarrierPoint(1234, 1006, 870,2 ));
                                                           
            carrierPoint.Add(1357, new PlcCarrierPoint(1357, 1034, 894,3 ));
            carrierPoint.Add(1358, new PlcCarrierPoint(1358, 1062, 918,3 ));
            carrierPoint.Add(1359, new PlcCarrierPoint(1359, 1090, 942,3 ));
            carrierPoint.Add(1360, new PlcCarrierPoint(1360, 1118, 966,3 ));
            carrierPoint.Add(1361, new PlcCarrierPoint(1361, 1146, 990,3 ));
            carrierPoint.Add(1362, new PlcCarrierPoint(1362, 1174, 1014,3 ));
            carrierPoint.Add(1363, new PlcCarrierPoint(1363, 1202, 1038,3 ));
            carrierPoint.Add(1364, new PlcCarrierPoint(1364, 1230, 1062,3 ));
            carrierPoint.Add(1365, new PlcCarrierPoint(1365, 1258, 1086,3 ));
            carrierPoint.Add(1366, new PlcCarrierPoint(1366, 1286, 1110,3 ));
            carrierPoint.Add(1367, new PlcCarrierPoint(1367, 1314, 1134,3 ));
            carrierPoint.Add(1368, new PlcCarrierPoint(1368, 1342, 1158,3 ));
            carrierPoint.Add(1369, new PlcCarrierPoint(1369, 1370, 1182,3 ));
            carrierPoint.Add(1370, new PlcCarrierPoint(1370, 1398, 1206,3 ));
            carrierPoint.Add(1371, new PlcCarrierPoint(1371, 1426, 1230,3 ));
            carrierPoint.Add(1372, new PlcCarrierPoint(1372, 1454, 1254,3 ));
            carrierPoint.Add(1373, new PlcCarrierPoint(1373, 1482, 1278,3 ));
            carrierPoint.Add(1374, new PlcCarrierPoint(1374, 1510, 1302,3 ));
            carrierPoint.Add(1375, new PlcCarrierPoint(1375, 1538, 1326,3 ));
                                                            
            carrierPoint.Add(2001, new PlcCarrierPoint(2001, 1566, 1350,4 ));
            carrierPoint.Add(2026, new PlcCarrierPoint(2026, 1594, 1374,4 ));
            carrierPoint.Add(2027, new PlcCarrierPoint(2027, 1622, 1398,4 ));
            carrierPoint.Add(2028, new PlcCarrierPoint(2028, 1650, 1422,4 ));
            carrierPoint.Add(2029, new PlcCarrierPoint(2029, 1678, 1446,4 ));
            carrierPoint.Add(2030, new PlcCarrierPoint(2030, 1706, 1470,4 ));
            carrierPoint.Add(2031, new PlcCarrierPoint(2031, 1734, 1494,4 ));
            carrierPoint.Add(2032, new PlcCarrierPoint(2032, 1762, 1518,4 ));
            carrierPoint.Add(2033, new PlcCarrierPoint(2033, 1790, 1542,4 ));
            carrierPoint.Add(2034, new PlcCarrierPoint(2034, 1818, 1566,4 ));
            carrierPoint.Add(2035, new PlcCarrierPoint(2035, 1846, 1590,4 ));
            carrierPoint.Add(2036, new PlcCarrierPoint(2036, 1874, 1614,4 ));
                                                            
            carrierPoint.Add(2201, new PlcCarrierPoint(2201, 1902, 1638,5 ));
            carrierPoint.Add(2209, new PlcCarrierPoint(2209, 1930, 1662,5 ));
            carrierPoint.Add(2210, new PlcCarrierPoint(2210, 1958, 1686,5 ));
            carrierPoint.Add(2211, new PlcCarrierPoint(2211, 1986, 1710,5 ));
                                                            
            carrierPoint.Add(2317, new PlcCarrierPoint(2317, 2014, 1734,6 ));
            carrierPoint.Add(2318, new PlcCarrierPoint(2318, 2042, 1758,6 ));
            carrierPoint.Add(2319, new PlcCarrierPoint(2319, 2070, 1782,6 ));
            carrierPoint.Add(2320, new PlcCarrierPoint(2320, 2098, 1806,6 ));
            carrierPoint.Add(2321, new PlcCarrierPoint(2321, 2126, 1830,6 ));
            carrierPoint.Add(2322, new PlcCarrierPoint(2322, 2154, 1854,6 ));
            carrierPoint.Add(2323, new PlcCarrierPoint(2323, 2182, 1878,6 ));
            carrierPoint.Add(2324, new PlcCarrierPoint(2324, 2210, 1902,6 ));                   
        }

        public class PlcCarrierPoint
        {

            public int pathNo;
            public int ROffset;
            public int WOffset;
            public int PlcId;

            public PlcCarrierPoint(int pathNo, int rOffset, int wOffset, int plcId)
            {
                this.pathNo = pathNo;
                this.ROffset = rOffset;
                this.WOffset = wOffset;
                this.PlcId = plcId;
            }
        }

    }
}
