using System;
using System.Collections.Generic;
using System.Windows.Forms;
using CMNetLib.Robots.Crane;

namespace GK.WCS.Client.Control
{
    public partial class CranePointSign:BaseControl {
        public int CraneId=0;
        public CranePointSign()
        {
            InitializeComponent();
        }
      

        public void ShowInfo(List<DIO> DIOs) {
            this.Invoke(new Action(() => {
                SetUiDiDo("DI_",DIOs);
            }));

           
          //SetUiDiDo("Do_",status.DOk__BackingField);
        }
 

        private void SetUiDiDo(String key,List<DIO> DIOs) {
            foreach(var di in DIOs) {
                try {
                    var view = Controls.Find(key + (di.Address - 1),true)[0] as PictureBox;
                    if(view == null) {
                        continue;
                    }

                    view.Image = di.OnOff ? imageList1.Images[0] : imageList1.Images[2];
                } catch(Exception e) {
                    Console.WriteLine(e);
                }
            }

        }

    }
}
