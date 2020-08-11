using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace GK.WCS.Client.Station {
  public   class MessageUtil {

        public static bool warning(String info) {
            var res = MessageBox.Show(info,"警告",MessageBoxButtons.YesNo,
                     MessageBoxIcon.Warning);
            if(res == DialogResult.Yes) {
                return true;
            } else {
                return false;
            }
        }
    }
}
