﻿

namespace GK.WCS.Client.Device
{
    partial class FrmCraneCtrl
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing) {
            this.timerRefresh.Enabled = false;
            if(disposing && (components != null)) {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(FrmCraneCtrl));
            this.timerRefresh = new System.Windows.Forms.Timer(this.components);
            this.imageList1 = new System.Windows.Forms.ImageList(this.components);
            this.pnlMain = new System.Windows.Forms.Panel();
            this.button2 = new System.Windows.Forms.Button();
            this.autoButton1 = new System.Windows.Forms.Button();
            this.radioButton2 = new System.Windows.Forms.RadioButton();
            this.btnCrane2stop = new System.Windows.Forms.Button();
            this.btnSemiAuto = new System.Windows.Forms.Button();
            this.radioButton1 = new System.Windows.Forms.RadioButton();
            this.btnCrane1stop = new System.Windows.Forms.Button();
            this.button4 = new System.Windows.Forms.Button();
            this.button1 = new System.Windows.Forms.Button();
            this.panel1 = new System.Windows.Forms.Panel();
            this.lblCraneName = new System.Windows.Forms.Label();
            this.lblCurrentModeHead = new System.Windows.Forms.Label();
            this.lblCurrentMode = new System.Windows.Forms.Label();
            this.craneAuto1 = new GK.WCS.Client.Control.CraneAuto();
            this.TaskInfo2 = new GK.WCS.Client.Control.SingleTaskInfo();
            this.pnlMain.SuspendLayout();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // timerRefresh
            // 
            this.timerRefresh.Enabled = true;
            this.timerRefresh.Interval = 1000;
            this.timerRefresh.Tick += new System.EventHandler(this.timerRefresh_Tick);
            // 
            // imageList1
            // 
            this.imageList1.ImageStream = ((System.Windows.Forms.ImageListStreamer)(resources.GetObject("imageList1.ImageStream")));
            this.imageList1.TransparentColor = System.Drawing.Color.Transparent;
            this.imageList1.Images.SetKeyName(0, "Online.png");
            this.imageList1.Images.SetKeyName(1, "red.png");
            this.imageList1.Images.SetKeyName(2, "Unline.png");
            // 
            // pnlMain
            // 
            this.pnlMain.BackColor = System.Drawing.Color.Black;
            this.pnlMain.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.pnlMain.Controls.Add(this.craneAuto1);
            this.pnlMain.Controls.Add(this.button2);
            this.pnlMain.Controls.Add(this.TaskInfo2);
            this.pnlMain.Controls.Add(this.autoButton1);
            this.pnlMain.Controls.Add(this.radioButton2);
            this.pnlMain.Controls.Add(this.btnCrane2stop);
            this.pnlMain.Controls.Add(this.btnSemiAuto);
            this.pnlMain.Controls.Add(this.radioButton1);
            this.pnlMain.Controls.Add(this.btnCrane1stop);
            this.pnlMain.Controls.Add(this.button4);
            this.pnlMain.Controls.Add(this.button1);
            this.pnlMain.Controls.Add(this.panel1);
            this.pnlMain.Dock = System.Windows.Forms.DockStyle.Fill;
            this.pnlMain.Location = new System.Drawing.Point(0, 0);
            this.pnlMain.Margin = new System.Windows.Forms.Padding(4);
            this.pnlMain.Name = "pnlMain";
            this.pnlMain.Size = new System.Drawing.Size(1630, 734);
            this.pnlMain.TabIndex = 2;
            // 
            // button2
            // 
            this.button2.Location = new System.Drawing.Point(49, 634);
            this.button2.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(111, 36);
            this.button2.TabIndex = 44;
            this.button2.Text = "解警";
            this.button2.UseVisualStyleBackColor = true;
            this.button2.Click += new System.EventHandler(this.button2_Click_1);
            // 
            // autoButton1
            // 
            this.autoButton1.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.autoButton1.ForeColor = System.Drawing.Color.Red;
            this.autoButton1.Location = new System.Drawing.Point(1205, 171);
            this.autoButton1.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.autoButton1.Name = "autoButton1";
            this.autoButton1.Size = new System.Drawing.Size(85, 42);
            this.autoButton1.TabIndex = 32;
            this.autoButton1.Tag = "3";
            this.autoButton1.Text = "全自动";
            this.autoButton1.UseVisualStyleBackColor = true;
            this.autoButton1.Click += new System.EventHandler(this.ChangeMode_Click);
            // 
            // radioButton2
            // 
            this.radioButton2.AutoSize = true;
            this.radioButton2.ForeColor = System.Drawing.SystemColors.ButtonHighlight;
            this.radioButton2.Location = new System.Drawing.Point(364, 564);
            this.radioButton2.Margin = new System.Windows.Forms.Padding(4);
            this.radioButton2.Name = "radioButton2";
            this.radioButton2.Size = new System.Drawing.Size(66, 19);
            this.radioButton2.TabIndex = 34;
            this.radioButton2.Tag = "2";
            this.radioButton2.Text = "2垛机";
            this.radioButton2.UseVisualStyleBackColor = true;
            this.radioButton2.CheckedChanged += new System.EventHandler(this.radioButton1_CheckedChanged);
            // 
            // btnCrane2stop
            // 
            this.btnCrane2stop.BackColor = System.Drawing.SystemColors.Control;
            this.btnCrane2stop.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Bold);
            this.btnCrane2stop.ForeColor = System.Drawing.Color.Red;
            this.btnCrane2stop.Location = new System.Drawing.Point(40, 438);
            this.btnCrane2stop.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.btnCrane2stop.Name = "btnCrane2stop";
            this.btnCrane2stop.Size = new System.Drawing.Size(135, 42);
            this.btnCrane2stop.TabIndex = 42;
            this.btnCrane2stop.Text = "初始化";
            this.btnCrane2stop.UseVisualStyleBackColor = false;
            this.btnCrane2stop.Click += new System.EventHandler(this.btnCrane2stop_Click);
            // 
            // btnSemiAuto
            // 
            this.btnSemiAuto.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnSemiAuto.ForeColor = System.Drawing.Color.Red;
            this.btnSemiAuto.Location = new System.Drawing.Point(950, 171);
            this.btnSemiAuto.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.btnSemiAuto.Name = "btnSemiAuto";
            this.btnSemiAuto.Size = new System.Drawing.Size(99, 42);
            this.btnSemiAuto.TabIndex = 31;
            this.btnSemiAuto.Tag = "2";
            this.btnSemiAuto.Text = "手动";
            this.btnSemiAuto.UseVisualStyleBackColor = true;
            this.btnSemiAuto.Click += new System.EventHandler(this.ChangeMode_Click);
            // 
            // radioButton1
            // 
            this.radioButton1.AutoSize = true;
            this.radioButton1.Checked = true;
            this.radioButton1.ForeColor = System.Drawing.SystemColors.ButtonHighlight;
            this.radioButton1.Location = new System.Drawing.Point(364, 264);
            this.radioButton1.Margin = new System.Windows.Forms.Padding(4);
            this.radioButton1.Name = "radioButton1";
            this.radioButton1.Size = new System.Drawing.Size(66, 19);
            this.radioButton1.TabIndex = 33;
            this.radioButton1.TabStop = true;
            this.radioButton1.Tag = "1";
            this.radioButton1.Text = "1垛机";
            this.radioButton1.UseVisualStyleBackColor = true;
            this.radioButton1.CheckedChanged += new System.EventHandler(this.radioButton1_CheckedChanged);
            // 
            // btnCrane1stop
            // 
            this.btnCrane1stop.BackColor = System.Drawing.SystemColors.Control;
            this.btnCrane1stop.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Bold);
            this.btnCrane1stop.ForeColor = System.Drawing.Color.Red;
            this.btnCrane1stop.Location = new System.Drawing.Point(40, 129);
            this.btnCrane1stop.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.btnCrane1stop.Name = "btnCrane1stop";
            this.btnCrane1stop.Size = new System.Drawing.Size(135, 42);
            this.btnCrane1stop.TabIndex = 41;
            this.btnCrane1stop.Text = "初始化";
            this.btnCrane1stop.UseVisualStyleBackColor = false;
            this.btnCrane1stop.Click += new System.EventHandler(this.btnCrane1stop_Click);
            // 
            // button4
            // 
            this.button4.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.button4.ForeColor = System.Drawing.Color.Red;
            this.button4.Location = new System.Drawing.Point(35, 364);
            this.button4.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.button4.Name = "button4";
            this.button4.Size = new System.Drawing.Size(147, 42);
            this.button4.TabIndex = 40;
            this.button4.Tag = "3";
            this.button4.Text = "急停垛机2";
            this.button4.UseVisualStyleBackColor = true;
            this.button4.Click += new System.EventHandler(this.button4_Click);
            // 
            // button1
            // 
            this.button1.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.button1.ForeColor = System.Drawing.Color.Red;
            this.button1.Location = new System.Drawing.Point(35, 54);
            this.button1.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(147, 42);
            this.button1.TabIndex = 36;
            this.button1.Tag = "3";
            this.button1.Text = "急停垛机1";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.lblCraneName);
            this.panel1.Controls.Add(this.lblCurrentModeHead);
            this.panel1.Controls.Add(this.lblCurrentMode);
            this.panel1.Location = new System.Drawing.Point(436, 40);
            this.panel1.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(389, 131);
            this.panel1.TabIndex = 28;
            // 
            // lblCraneName
            // 
            this.lblCraneName.AutoSize = true;
            this.lblCraneName.BackColor = System.Drawing.Color.Black;
            this.lblCraneName.Font = new System.Drawing.Font("宋体", 26.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lblCraneName.ForeColor = System.Drawing.Color.Red;
            this.lblCraneName.Location = new System.Drawing.Point(57, 16);
            this.lblCraneName.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblCraneName.Name = "lblCraneName";
            this.lblCraneName.Size = new System.Drawing.Size(155, 44);
            this.lblCraneName.TabIndex = 21;
            this.lblCraneName.Text = "堆垛机";
            // 
            // lblCurrentModeHead
            // 
            this.lblCurrentModeHead.AutoSize = true;
            this.lblCurrentModeHead.ForeColor = System.Drawing.Color.White;
            this.lblCurrentModeHead.Location = new System.Drawing.Point(71, 81);
            this.lblCurrentModeHead.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblCurrentModeHead.Name = "lblCurrentModeHead";
            this.lblCurrentModeHead.Size = new System.Drawing.Size(75, 15);
            this.lblCurrentModeHead.TabIndex = 1;
            this.lblCurrentModeHead.Text = "当前模式:";
            // 
            // lblCurrentMode
            // 
            this.lblCurrentMode.AutoSize = true;
            this.lblCurrentMode.ForeColor = System.Drawing.Color.GreenYellow;
            this.lblCurrentMode.Location = new System.Drawing.Point(160, 81);
            this.lblCurrentMode.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblCurrentMode.Name = "lblCurrentMode";
            this.lblCurrentMode.Size = new System.Drawing.Size(52, 15);
            this.lblCurrentMode.TabIndex = 5;
            this.lblCurrentMode.Text = "初始化";
            // 
            // craneAuto1
            // 
            this.craneAuto1.Location = new System.Drawing.Point(886, 255);
            this.craneAuto1.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.craneAuto1.Name = "craneAuto1";
            this.craneAuto1.Size = new System.Drawing.Size(594, 349);
            this.craneAuto1.SourceShelve = null;
            this.craneAuto1.TabIndex = 45;
            this.craneAuto1.Load += new System.EventHandler(this.craneAuto1_Load);
            // 
            // TaskInfo2
            // 
            this.TaskInfo2.Location = new System.Drawing.Point(859, 40);
            this.TaskInfo2.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.TaskInfo2.Name = "TaskInfo2";
            this.TaskInfo2.Size = new System.Drawing.Size(621, 106);
            this.TaskInfo2.TabIndex = 43;
            // 
            // FrmCraneCtrl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1630, 734);
            this.Controls.Add(this.pnlMain);
            this.Margin = new System.Windows.Forms.Padding(4);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "FrmCraneCtrl";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "堆垛机控制台";
            this.Load += new System.EventHandler(this.FrmCraneCtrl_Load);
            this.Paint += new System.Windows.Forms.PaintEventHandler(this.FrmCraneCtrl_Paint);
            this.pnlMain.ResumeLayout(false);
            this.pnlMain.PerformLayout();
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Timer timerRefresh;
        private System.Windows.Forms.Panel pnlMain;
        private System.Windows.Forms.Label lblCraneName;
        private System.Windows.Forms.Label lblCurrentMode;
        private System.Windows.Forms.Label lblCurrentModeHead;
        private System.Windows.Forms.ImageList imageList1;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Button btnSemiAuto;
        private System.Windows.Forms.Button autoButton1;
        private System.Windows.Forms.RadioButton radioButton2;
        private System.Windows.Forms.RadioButton radioButton1;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Button button4;
        private System.Windows.Forms.Button btnCrane1stop;
        private System.Windows.Forms.Button btnCrane2stop;
        private Control.SingleTaskInfo TaskInfo2;
        private System.Windows.Forms.Button button2;
        private Control.CraneAuto craneAuto1;
    }
}