using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using CMFrameWork.Common;
using CMNetLib.Robots.CarrierChain;
using GK.WCS.Client;
using GK.WCS.Client.Control;
using GK.WCS.Client.Station;
using GK.WCS.Common.core.dto;
using GK.WCS.Client.Control;
using GK.WCS.Carrier;
using GK.WCS.Open.http.server;
using GK.WCS.Carrier.dto;

namespace GK.WCS.Client.Frm {
    public  class CarrierBase:Form {
        public List<System.Windows.Forms.Button> buttonAtt = new List<System.Windows.Forms.Button>();

        public List<Belt> lines = new List<Belt>();

        //public Dictionary<String,Belt> beltDict = new Dictionary<String,Belt>();

        public string buttomName = String.Empty;
        

        public void uploadSignalStates(CarrierData carrierData) {

          dict = carrierData.SignalStates;
            if (dict == null) {
                return;
            }
            foreach (Button b in buttonAtt) {
                if(null == b) {
                    continue;
                }
                var name = b.Name;
                int key = name.Substring(2).ToInt32(0);
                // key = getSid(key);
                if(!dict.ContainsKey(key)) {
                    continue;
                }
                CarrierSignalStatus ss = dict[key];
                if(ss.taskNo > 0) {
                    addColor(b,buttomName == name,true);
                } else {
                    addColor(b,buttomName == name,false);
                }
                int lineid = key / 10;
                int pos = key % 10;

                for(var i = 0;i < lines.Count;i++) {
                    Belt line = lines[i];
                    if(line == null) {
                        continue;
                    }
                    if(line.Name == "lin" + lineid) {
                      
                        if(pos == 1) {
                            line.setSign1(ss.taskNo!=0);
                        } else if(pos == 2) {
                            line.setSign2(ss.taskNo == 0);
                        }
                        break;
                    }

                }
                
            }

        }


        /*有数据 选中 黄色
         * 无数据 选中 白色
         * 有数据 没有选中 绿色
         * 无数据 没有选中 黑色
         * 
         * */


        public Dictionary<int, CarrierSignalStatus> dict = new Dictionary<int, CarrierSignalStatus>();
        public TextBox taskNoInupt;

        public void addColor(Button b,Boolean select,Boolean hasData) {
            try {
                var name = b.Name;
                if(select) { //select
                    if(hasData) {
                        this.Invoke(new Action(() => {
                            b.BackColor = System.Drawing.Color.Yellow;
                        }));
                    } else {
                        this.Invoke(new Action(() => {
                            b.BackColor = System.Drawing.Color.White;
                        }));
                    }
                } else {

                    if(hasData) {
                        this.Invoke(new Action(() => {
                            b.BackColor = System.Drawing.Color.Green;
                        }));
                    } else {
                        this.Invoke(new Action(() => {
                            b.BackColor = System.Drawing.Color.Black;
                        }));
                    }
                }
                if(buttomName != name) {
                    return;
                }

                int key = name.Substring(2).ToInt32(0);
                CarrierSignalStatus ss = dict[key];
                if(ss != null && ss.taskNo > 0) {
                    String value = ss.taskNo.ToString();
                    if(taskNoInupt.Text != value) {

                        this.Invoke(new Action(() => {
                            taskNoInupt.Text = value;
                        }));
                    }

                } else {
                    if(taskNoInupt.Text != "") {
                        this.Invoke(new Action(() => {
                            taskNoInupt.Text = "";
                        }));
                    }

                }
            } catch { }


        }
        protected int selectsid=0;
        public  void bClick(object sender,EventArgs e) {
            System.Windows.Forms.Button b = (System.Windows.Forms.Button)sender;
            selectsid= b.Text.ToString().ToInt32();
            setText(selectsid / 10);
            foreach(System.Windows.Forms.Button bt in buttonAtt) {
                if(bt == null) {
                    continue;
                }
                if(bt.Name == buttomName) {
                    int key = bt.Name.Substring(2).ToInt32(0);

                    key = getSid(key);
                    if(dict.ContainsKey(key)) {

                        CarrierSignalStatus ss = dict[key];
                        if(ss.taskNo > 0) {
                            addColor(bt,false,true);
                        } else {
                            addColor(bt,false,false);
                        }
                    } else {
                        addColor(bt,false,false);
                    }


                    break;
                }
            }
            if(buttomName == b.Name) {
                buttomName = String.Empty;
            } else {

                int key = b.Name.Substring(2).ToInt32(0);
                key = getSid(key);
                if (dict!=null && dict.Count>0)
                {
                    if (dict.ContainsKey(key))
                    {

                        CarrierSignalStatus ss = dict[key];
                        if (ss.taskNo > 0)
                        {
                            addColor(b, true, true);
                            taskNoInupt.Text = ss.taskNo + "";
                        }
                        else
                        {
                            addColor(b, true, false);
                            taskNoInupt.Text = "";
                        }
                    }
                    else
                    {
                        addColor(b, true, false);
                        taskNoInupt.Text = "";
                    }
                }
                buttomName = b.Name;
            }
        }
        public virtual  void setText(int path) { }

        int getSid(int lineId) {
            int key = 0;
            if(lineId == 15) {
                key = 151;
            } else {
                key = lineId * 10 + 2;
            }
            return key;
        }
        public void Send(int Taskno,ushort from,ushort end,int posin) {
            
            String info = HttpCarrierUtil.sendMiddle(Taskno, from, posin);
            MessageBox.Show(info);

        }

        private void InitializeComponent() {
            this.SuspendLayout();
            // 
            // CarrierBase
            // 
            this.ClientSize = new System.Drawing.Size(284, 261);
            this.Name = "CarrierBase";
           
            this.ResumeLayout(false);

        }

       
    }
}
