using System;
using System.Windows.Forms;
using GK.WCS.Client.Station;
using CMFrameWork.Common;
using GK.WCS.Open.http.server;
using GK.WCS.DAL;
using GK.WCS.Entity;
using GK.WCS.Client;
using GK.WCS.Client.Frm;
using GK.WCS.Client.Control;
using GK.WCS.Carrier.dto;

namespace GK.WCS.Client.Frm {
    public partial class p:CarrierBase {
        int plcId = 2;

        public p() {
       
            InitializeComponent();
          
            legend1.dict = CU.getMachineErrCode();
         
            legend1.title = "输送线异常原因图例";
            legend2.dict = CU.getMachineStatus();
            legend2.title = "输送线状态图例(箭头)";

            lines.Add(line1);
            lines.Add(line2);
            lines.Add(line3);
            lines.Add(line4);
            lines.Add(line5);
            lines.Add(line6);
            lines.Add(line7);
            lines.Add(line8);
            lines.Add(line9);
            lines.Add(line10);
            lines.Add(line11);
            lines.Add(line12);
            lines.Add(line13);
            lines.Add(line14);
            lines.Add(line15);
            lines.Add(line16);
            lines.Add(line17);
            lines.Add(line18);
            lines.Add(line19);
            lines.Add(line20);
            lines.Add(line21);
            lines.Add(line22);
            lines.Add(line23);
            lines.Add(line24);
            lines.Add(line25);
            lines.Add(line26);
            lines.Add(line27);
            lines.Add(line28);
            lines.Add(line29);
            lines.Add(line30);
            lines.Add(line31);
            lines.Add(line32);
            lines.Add(line33);
            lines.Add(line34);
            lines.Add(line35);
            lines.Add(line36);
            lines.Add(line37);
            lines.Add(line38);
            lines.Add(line39);
            lines.Add(line40);
            lines.Add(line41);
            lines.Add(line42);
            lines.Add(line43);
            lines.Add(line44);
            lines.Add(line45);
            lines.Add(line46);
            lines.Add(line47);
            lines.Add(line48);
            lines.Add(line49);
            lines.Add(line50);
            lines.Add(line51);
            lines.Add(line52);
            lines.Add(line53);
            lines.Add(line54);
            lines.Add(line55);
            lines.Add(line56);
            lines.Add(line57);
            lines.Add(line58);
            lines.Add(line59);
            lines.Add(line60);
            lines.Add(line61);
            lines.Add(line62);
            lines.Add(line63);
            lines.Add(line64);
            lines.Add(line65);
            lines.Add(line66);
            lines.Add(line67);
            lines.Add(line68);
            lines.Add(line69);
            lines.Add(line70);
            lines.Add(line71);
            lines.Add(line72);
            lines.Add(line73);
            lines.Add(line74);
            lines.Add(line75);
            lines.Add(line76);
            lines.Add(line77);
            lines.Add(line78);
            lines.Add(line79);
            lines.Add(line80);
            lines.Add(line81);
            lines.Add(line82);
            lines.Add(line83);
            lines.Add(line84);
            lines.Add(line85);
            lines.Add(line86);
            lines.Add(line87);
            lines.Add(line88);
            lines.Add(line89);
            lines.Add(line90);
            lines.Add(line91);
            lines.Add(line92);
            lines.Add(line93);
            lines.Add(line94);
            buttonAtt.Add(bt11);
            buttonAtt.Add(bt21);
            buttonAtt.Add(bt31);
            buttonAtt.Add(bt41);
            buttonAtt.Add(bt51);
            buttonAtt.Add(bt61);
            buttonAtt.Add(bt71);
            buttonAtt.Add(bt81);
            buttonAtt.Add(bt91);
            buttonAtt.Add(bt101);
            buttonAtt.Add(bt111);
            buttonAtt.Add(bt121);
            buttonAtt.Add(bt131);
            buttonAtt.Add(bt132);
            buttonAtt.Add(bt141);
            buttonAtt.Add(bt142);
            buttonAtt.Add(bt151);
            buttonAtt.Add(bt152);
            buttonAtt.Add(bt161);
            buttonAtt.Add(bt162);
            buttonAtt.Add(bt171);
            buttonAtt.Add(bt172);
            buttonAtt.Add(bt181);
            buttonAtt.Add(bt182);
            buttonAtt.Add(bt191);
            buttonAtt.Add(bt192);
            buttonAtt.Add(bt201);
            buttonAtt.Add(bt202);
            buttonAtt.Add(bt211);
            buttonAtt.Add(bt212);
            buttonAtt.Add(bt221);
            buttonAtt.Add(bt222);
            buttonAtt.Add(bt231);
            buttonAtt.Add(bt232);
            buttonAtt.Add(bt241);
            buttonAtt.Add(bt242);
            buttonAtt.Add(bt251);
            buttonAtt.Add(bt252);
            buttonAtt.Add(bt261);
            buttonAtt.Add(bt262);
            buttonAtt.Add(bt271);
            buttonAtt.Add(bt272);
            buttonAtt.Add(bt281);
            buttonAtt.Add(bt282);
            buttonAtt.Add(bt291);
            buttonAtt.Add(bt292);
            buttonAtt.Add(bt301);
            buttonAtt.Add(bt302);
            buttonAtt.Add(bt311);
            buttonAtt.Add(bt312);
            buttonAtt.Add(bt321);
            buttonAtt.Add(bt322);
            buttonAtt.Add(bt331);
            buttonAtt.Add(bt332);
            buttonAtt.Add(bt341);
            buttonAtt.Add(bt342);
            buttonAtt.Add(bt351);
            buttonAtt.Add(bt352);
            buttonAtt.Add(bt361);
            buttonAtt.Add(bt362);
            buttonAtt.Add(bt371);
            buttonAtt.Add(bt381);
            buttonAtt.Add(bt391);
            buttonAtt.Add(bt401);
            buttonAtt.Add(bt411);
            buttonAtt.Add(bt421);
            buttonAtt.Add(bt431);
            buttonAtt.Add(bt441);
            buttonAtt.Add(bt451);
            buttonAtt.Add(bt461);
            buttonAtt.Add(bt471);
            buttonAtt.Add(bt472);
            buttonAtt.Add(bt481);
            buttonAtt.Add(bt482);
            buttonAtt.Add(bt491);
            buttonAtt.Add(bt501);
            buttonAtt.Add(bt511);
            buttonAtt.Add(bt521);
            buttonAtt.Add(bt531);
            buttonAtt.Add(bt541);
            buttonAtt.Add(bt551);
            buttonAtt.Add(bt561);
            buttonAtt.Add(bt571);
            buttonAtt.Add(bt581);
            buttonAtt.Add(bt591);
            buttonAtt.Add(bt601);
            buttonAtt.Add(bt611);
            buttonAtt.Add(bt621);
            buttonAtt.Add(bt631);
            buttonAtt.Add(bt641);
            buttonAtt.Add(bt651);
            buttonAtt.Add(bt661);
            buttonAtt.Add(bt671);
            buttonAtt.Add(bt681);
            buttonAtt.Add(bt691);
            buttonAtt.Add(bt701);
            buttonAtt.Add(bt711);
            buttonAtt.Add(bt721);
            buttonAtt.Add(bt731);
            buttonAtt.Add(bt741);
            buttonAtt.Add(bt751);
            buttonAtt.Add(bt761);
            buttonAtt.Add(bt771);
            buttonAtt.Add(bt781);
            buttonAtt.Add(bt791);
            buttonAtt.Add(bt801);
            buttonAtt.Add(bt811);
            buttonAtt.Add(bt821);
            buttonAtt.Add(bt831);
            buttonAtt.Add(bt841);
            buttonAtt.Add(bt851);
            buttonAtt.Add(bt861);
            buttonAtt.Add(bt871);
            buttonAtt.Add(bt881);
            buttonAtt.Add(bt891);
            buttonAtt.Add(bt901);
            buttonAtt.Add(bt911);
            buttonAtt.Add(bt921);
            buttonAtt.Add(bt931);
            buttonAtt.Add(bt941);
            foreach (Button b in buttonAtt) {
                b.BackColor = System.Drawing.Color.Black;
            }

        }

        private void FrmGlobal_Load(object sender, EventArgs e) {
           
            taskNoInupt = taskNoText;
        }
        public void b_Click(object sender,EventArgs e) {
            bClick(sender,e);
        }
        private void timer1_Tick(object sender,EventArgs e) {
            CarrierSignalStatus ss = null;
            if (dict!=null && dict.Count>0)
            {
                 ss= dict[selectsid];
            }            
            int taskNo = 0;
            if (ss != null)
            {
                taskNo = ss.taskNo;
            }
            CarrierData carrierData = HttpCarrierUtil.reflash(1, taskNo);
            if(carrierData == null) {
                return;
            }
            uploadSignalStates(carrierData);
        }

       
        void changeCraneButton(int crane1Stop,Button btnCrane) {
            this.Invoke(new Action(() => {
                if(crane1Stop == 1) {
                    btnCrane.Text = idle;
                } else {
                    btnCrane.Text = working;
                }
            }));
        }
        
        string idle = "点击恢复执行";
        string working = "点击循环停止";  
        

        private void btnTaskClear_Click(object sender, EventArgs e) {
            if (buttomName == String.Empty) {
                MessageBox.Show("请选择清除位置！");
                return;
            }
            string Carrier = buttomName.Substring(2);
            ushort CarrierID = (ushort)Carrier.ToInt(0);
            try {
               
                String info = HttpCarrierUtil.clearAction(plcId,CarrierID) ;
                if(String.IsNullOrEmpty(info)) {
                    MessageBox.Show("成功清除");
                } else {
                    MessageBox.Show(info);
                }


            } catch (Exception e1) {
                MessageBox.Show("输送线" + CarrierID + "任务清除失败: " + e1.Message);
            }

        }

        private void button1_Click(object sender,EventArgs e) {
            if(buttomName == String.Empty) {
                MessageBox.Show("请选择复位位置！");
                return;
            }
            string Carrier = buttomName.Substring(2);
            ushort CarrierID = (ushort)(Carrier.ToInt(0)/10);
            try {
                String info = HttpCarrierUtil.resetAction(plcId,CarrierID);
            
                if(String.IsNullOrEmpty(info)) {
                    MessageBox.Show("成功复位");
                } else {
                    MessageBox.Show(info);
                }

            } catch(Exception e1) {
                MessageBox.Show("输送线" + CarrierID + "任务复位失败: " + e1.Message);
            }
        }



        public override void setText(int path) {
            textBox2.Text = path + "";

        }

        private void button4_Click(object sender,EventArgs e) {
            int taskNo = textBox1.Text.ToInt32();
            if(taskNo < 10000000) {
                MessageBox.Show("任务号异常！");
            }

            int stn = textBox2.Text.ToInt32();
            ITaskCarrierServer carrierDAL = ServerFactray.getServer<ITaskCarrierServer>();
            TaskCarrier carrier = carrierDAL.getCarrarTasksByTaskNo(taskNo);
           // Send(carrier.TaskNo,carrier.StartPath,carrier.EndPath,stn);
        }
       
        private void Carrier2_Activated(object sender,EventArgs e) {
            this.timer1.Enabled = true;
        }

        private void Carrier2_Deactivate(object sender,EventArgs e) {
            this.timer1.Enabled = false;
        }

        private void line48_Load(object sender, EventArgs e)
        {

        }

        private void bt31_Click(object sender, EventArgs e)
        {

        }

        private void bt482_Click(object sender, EventArgs e)
        {

        }
    }
}
