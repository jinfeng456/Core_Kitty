
using ConsoleApplication2.HttpServer;
using System;

using System.Windows.Forms;


namespace GK.WCS.Server {
    public partial class FrmServer : Form {
        public FrmServer() {
            InitializeComponent();
            this.MaximizeBox = false;
        }
        private void FrmServer_Load(object sender, EventArgs e) {
            HttpProcess.pathDict.Add("/Print/code", "Print@code");
            new HttpServer(12138);
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
