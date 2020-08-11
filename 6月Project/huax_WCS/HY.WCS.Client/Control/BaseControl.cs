using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace GK.WCS.Client.Control {

    public class BaseControl:UserControl {
        public BaseControl() {
        
        }

        public bool warning(String info) {
            var res = MessageBox.Show(info,"警告",MessageBoxButtons.YesNo,
                     MessageBoxIcon.Warning);
            if(res == DialogResult.Yes) {
                return true;
            } else {
                return false;
            }
        }



        public void error(String info) {
            MessageBox.Show(info,@"错误",MessageBoxButtons.OK,  MessageBoxIcon.Error);
        }
        public void info(String info) {
            MessageBox.Show(info,"提示",MessageBoxButtons.OK,MessageBoxIcon.Information);
        }



    }
}
