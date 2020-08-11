using System;
using System.Windows.Forms;

namespace GK.WCS.Client
{
    public partial class LoginFrm : Form
    {
        public LoginFrm()
        {
            InitializeComponent();
        }

        private void btnLogin_Click(object sender, EventArgs e)
        {
            lblMsg.Text = "正在登录...";
            lblMsg.Refresh();
            btnLogin.Enabled = btnCancel.Enabled = false;
            var uname = txtUserName.Text.Trim();
            var pwd = txtPwd.Text.Trim();
            if (string.IsNullOrEmpty(uname) || string.IsNullOrEmpty(pwd))
                return;
            try{
                    var vMainFrm = new FrmMain();
                    vMainFrm.Show();
                    Hide();
                    lblMsg.Text = "未登录";
            } catch (Exception ex) {
                lblMsg.Text = "未登录";
                MessageBox.Show("登陆错误:" + ex.Message, "错误", MessageBoxButtons.OK, MessageBoxIcon.Error);
            } finally {
                btnLogin.Enabled = btnCancel.Enabled = btnReset.Enabled = true;
            }
        }

        private void btnReset_Click(object sender, EventArgs e)
        {
            txtPwd.Clear();
            txtUserName.Clear();
            txtUserName.Focus();
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }
    }
}
