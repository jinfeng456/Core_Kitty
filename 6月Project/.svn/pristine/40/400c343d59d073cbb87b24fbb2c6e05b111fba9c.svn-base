using System;
using System.Collections.Generic;
using System.Windows.Forms;

using GK.WCS.Client.Station;
using GK.WCS.Common.dto;

namespace GK.WCS.Client.Device {
    public partial class StatTaskFrm: Form
    {
       
        public StatTaskFrm()
        {
            InitializeComponent();
            dataGridView1.AutoGenerateColumns = false;
        }


        private void StockInfoFrm_Load(object sender, EventArgs e)
        {
          
        }
        private void dgvData_CellFormatting(object sender,DataGridViewCellFormattingEventArgs e) {
            DataGridView grid = (DataGridView)sender;
            int column = e.ColumnIndex;
            String name = grid.Columns[column].Name;
            
            if("avg" == name) {
                DataGridViewRow row = grid.Rows[e.RowIndex];
               TaskStat stat = (TaskStat)row.DataBoundItem;
                if(stat.workCount != 0) {
                    e.Value = stat.workAllTime / stat.workCount;
                }
            }
        }

        private void btnloadComplete_Click(object sender,EventArgs e) {
            
            dataGridView1.DataSource = HttpSysUtil.getStat();
            
        }

        private void timer1_Tick(object sender,EventArgs e) {
            btnloadComplete_Click(sender,e);
        }

        private void button1_Click(object sender, EventArgs e)
        {
            dataGridView1.DataSource = HttpSysUtil.getStat();
        }
    }
}