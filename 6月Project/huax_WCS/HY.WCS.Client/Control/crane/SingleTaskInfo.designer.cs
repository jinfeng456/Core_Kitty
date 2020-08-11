namespace GK.WCS.Client.Control
{
    partial class SingleTaskInfo
    {
        /// <summary> 
        /// 必需的设计器变量。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary> 
        /// 清理所有正在使用的资源。
        /// </summary>
        /// <param name="disposing">如果应释放托管资源，为 true；否则为 false。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region 组件设计器生成的代码

        /// <summary> 
        /// 设计器支持所需的方法 - 不要
        /// 使用代码编辑器修改此方法的内容。
        /// </summary>
        private void InitializeComponent()
        {
            this.label1 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.taskNo = new System.Windows.Forms.TextBox();
            this.Status = new System.Windows.Forms.TextBox();
            this.btnTaskClear = new System.Windows.Forms.Button();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.ForeColor = System.Drawing.SystemColors.ControlLightLight;
            this.label1.Location = new System.Drawing.Point(12, 34);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(60, 15);
            this.label1.TabIndex = 0;
            this.label1.Text = "任务号:";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.ForeColor = System.Drawing.SystemColors.ControlLightLight;
            this.label6.Location = new System.Drawing.Point(238, 37);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(75, 15);
            this.label6.TabIndex = 5;
            this.label6.Text = "任务状态:";
            // 
            // taskNo
            // 
            this.taskNo.Location = new System.Drawing.Point(79, 32);
            this.taskNo.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.taskNo.Name = "taskNo";
            this.taskNo.ReadOnly = true;
            this.taskNo.Size = new System.Drawing.Size(144, 25);
            this.taskNo.TabIndex = 7;
            // 
            // Status
            // 
            this.Status.Location = new System.Drawing.Point(318, 34);
            this.Status.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.Status.Name = "Status";
            this.Status.ReadOnly = true;
            this.Status.Size = new System.Drawing.Size(81, 25);
            this.Status.TabIndex = 11;
            // 
            // btnTaskClear
            // 
            this.btnTaskClear.BackColor = System.Drawing.Color.Black;
            this.btnTaskClear.ForeColor = System.Drawing.SystemColors.ControlLightLight;
            this.btnTaskClear.Location = new System.Drawing.Point(433, 26);
            this.btnTaskClear.Margin = new System.Windows.Forms.Padding(4);
            this.btnTaskClear.Name = "btnTaskClear";
            this.btnTaskClear.Size = new System.Drawing.Size(100, 45);
            this.btnTaskClear.TabIndex = 12;
            this.btnTaskClear.Text = "任务删除";
            this.btnTaskClear.UseVisualStyleBackColor = false;
            this.btnTaskClear.Click += new System.EventHandler(this.btnTaskClear_Click);
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.label1);
            this.groupBox1.Controls.Add(this.btnTaskClear);
            this.groupBox1.Controls.Add(this.Status);
            this.groupBox1.Controls.Add(this.label6);
            this.groupBox1.Controls.Add(this.taskNo);
            this.groupBox1.ForeColor = System.Drawing.SystemColors.ControlLightLight;
            this.groupBox1.Location = new System.Drawing.Point(19, 15);
            this.groupBox1.Margin = new System.Windows.Forms.Padding(4);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Padding = new System.Windows.Forms.Padding(4);
            this.groupBox1.Size = new System.Drawing.Size(574, 85);
            this.groupBox1.TabIndex = 14;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "任务信息";
            // 
            // SingleTaskInfo
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.groupBox1);
            this.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.Name = "SingleTaskInfo";
            this.Size = new System.Drawing.Size(621, 106);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.TextBox taskNo;
        private System.Windows.Forms.TextBox Status;
        private System.Windows.Forms.Button btnTaskClear;
        private System.Windows.Forms.GroupBox groupBox1;
    }
}
