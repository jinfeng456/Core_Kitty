using System;
using System.Windows.Forms;
using GK.WCS.Client.Station;
namespace GK.WCS.Client.Device {
    public partial class LogFrm: Form
    {
       
        public LogFrm()
        {
            InitializeComponent();
           
        }


        private void StockInfoFrm_Load(object sender, EventArgs e)
        {
   
        }
        private void dgvData_CellFormatting(object sender,DataGridViewCellFormattingEventArgs e) {
            DataGridView grid = (DataGridView)sender;
            int column = e.ColumnIndex;
            String name = grid.Columns[column].DataPropertyName;
            if("timeTicks" == name) {
                long value = (long)e.Value;

                DateTime dt = new DateTime(value);
                e.Value = dt;
            }
           
        }
       
        private void btnloadComplete_Click(object sender,EventArgs e) {
            dataGridView1.DataSource = HttpSysUtil.showLog();
        
        }

        private void timer1_Tick(object sender,EventArgs e) {
            btnloadComplete_Click(sender,e);


        }
    }
}