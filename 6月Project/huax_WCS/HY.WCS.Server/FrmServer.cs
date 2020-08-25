using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;
using WCS.Common;

namespace GK.WCS.Server {
    public partial class FrmServer : Form {
        public FrmServer() {
            InitializeComponent();
            this.MaximizeBox = false;
        }
        private void FrmServer_Load(object sender, EventArgs e) {
 
            InitServer.start();
        }

        private void FrmServer_FormClosing(object sender,FormClosingEventArgs e) {
            if(MessageBox.Show("确定关闭 WCS 服务器？","提示",MessageBoxButtons.YesNoCancel,MessageBoxIcon.Question) == DialogResult.Yes) {
                e.Cancel = false;
            } else {
                e.Cancel = true;
            }
        }
    }
}
