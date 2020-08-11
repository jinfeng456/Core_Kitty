using System;
using System.Collections.Generic;
using System.Windows.Forms;

namespace GK.WCS.Client
{
    public partial class Form1 : Form
    {
        public int CraneId = 0;
        public Form1()
        {
            InitializeComponent();
            var values = Enum.GetValues(typeof(SemiAuto));
            List<String> list = new List<string>();
            list.Add("行走");
            list.Add("取货");
            list.Add("放货");
            cboxSEMI_AUTOActionType.DataSource = list;
   
        }

        public void ShowInfo(int craneId)
        {
            if (CraneId == craneId)
            {
                return;
            }

            this.Invoke(new Action(() => {
                this.CraneId = craneId;
             
           
                ;
            }));



        }

        public List<Pare> SourceShelve
        {
            get; set;
        }


        //private void btnExcuteSEMI_AUTO_Click(object sender, EventArgs e)
        //{
        //    RTConfig rt = new RTConfigDAL().GetRTConfig(CraneId);
        //    if (rt.Cranestatus != 2)
        //    {
        //        info("当前非自动状态，不可下达命令");
        //        return;
        //    }



        //    Pare sl = srcShelveList.SelectedItem as Pare;
        //    String src = sl.key;
        //    if (src.Length <= 3)
        //    {
        //        String she = (string)srcCol.Text;
        //        String sRow = (String)srcRow.Text;
        //        src += she + sRow;
        //    }

        //    if (CraneId != 4)
        //    {


        //    }

        //    String way = cboxSEMI_AUTOActionType.Text;
        //    int smatCodeField = 0;
        //    if (way == "取货")
        //    {
        //        smatCodeField = 2;
        //    }
        //    else if (way == "放货")
        //    {
        //        smatCodeField = 3;
        //    }
        //    else if (way == "行走")
        //    {
        //        smatCodeField = 4;
        //    }
        //    else
        //    {
        //        return;
        //    }

        //    String infod = DoSemiAutoTask(CraneId, src, smatCodeField);
        //    info(infod);
        //}
    }
}

