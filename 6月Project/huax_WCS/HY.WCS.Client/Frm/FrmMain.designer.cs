namespace GK.WCS.Client
{
    partial class FrmMain
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(FrmMain));
            this.msMain = new System.Windows.Forms.MenuStrip();
            this.全局监控csMain = new System.Windows.Forms.ToolStripMenuItem();
            this.传输线2ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.设备状态csMain = new System.Windows.Forms.ToolStripMenuItem();
            this.任务列表ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.日志ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.统计ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.mainPanel = new System.Windows.Forms.Panel();
            this.mainTab = new CMFrameWork.Windows.Controls.MainTab();
            this.statusStrip1 = new System.Windows.Forms.StatusStrip();
            this.toolStripStatusLabel1 = new System.Windows.Forms.ToolStripStatusLabel();
            this.timerRefresh = new System.Windows.Forms.Timer(this.components);
            this.msMain.SuspendLayout();
            this.mainPanel.SuspendLayout();
            this.statusStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // msMain
            // 
            this.msMain.BackColor = System.Drawing.Color.Azure;
            this.msMain.ImageScalingSize = new System.Drawing.Size(20, 20);
            this.msMain.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.全局监控csMain,
            this.传输线2ToolStripMenuItem,
            this.toolStripMenuItem1,
            this.设备状态csMain,
            this.任务列表ToolStripMenuItem,
            this.日志ToolStripMenuItem,
            this.统计ToolStripMenuItem});
            this.msMain.Location = new System.Drawing.Point(0, 0);
            this.msMain.Name = "msMain";
            this.msMain.Size = new System.Drawing.Size(922, 28);
            this.msMain.TabIndex = 2;
            this.msMain.Text = "MainMenuStrip";
            this.msMain.ItemClicked += new System.Windows.Forms.ToolStripItemClickedEventHandler(this.msMain_ItemClicked);
            // 
            // 全局监控csMain
            // 
            this.全局监控csMain.Name = "全局监控csMain";
            this.全局监控csMain.Size = new System.Drawing.Size(14, 24);
            // 
            // 传输线2ToolStripMenuItem
            // 
            this.传输线2ToolStripMenuItem.Name = "传输线2ToolStripMenuItem";
            this.传输线2ToolStripMenuItem.Size = new System.Drawing.Size(77, 24);
            this.传输线2ToolStripMenuItem.Text = "传输线2";
            this.传输线2ToolStripMenuItem.Click += new System.EventHandler(this.传输线2ToolStripMenuItem_Click);
            // 
            // toolStripMenuItem1
            // 
            this.toolStripMenuItem1.Name = "toolStripMenuItem1";
            this.toolStripMenuItem1.Size = new System.Drawing.Size(14, 24);
            // 
            // 设备状态csMain
            // 
            this.设备状态csMain.Name = "设备状态csMain";
            this.设备状态csMain.Size = new System.Drawing.Size(113, 24);
            this.设备状态csMain.Text = "堆垛机控制台";
            this.设备状态csMain.Click += new System.EventHandler(this.设备状态ToolStripMenuItem_Click);
            // 
            // 任务列表ToolStripMenuItem
            // 
            this.任务列表ToolStripMenuItem.Name = "任务列表ToolStripMenuItem";
            this.任务列表ToolStripMenuItem.Size = new System.Drawing.Size(83, 24);
            this.任务列表ToolStripMenuItem.Text = "任务列表";
            this.任务列表ToolStripMenuItem.Click += new System.EventHandler(this.任务列表ToolStripMenuItem_Click);
            // 
            // 日志ToolStripMenuItem
            // 
            this.日志ToolStripMenuItem.Name = "日志ToolStripMenuItem";
            this.日志ToolStripMenuItem.Size = new System.Drawing.Size(53, 24);
            this.日志ToolStripMenuItem.Text = "日志";
            this.日志ToolStripMenuItem.Click += new System.EventHandler(this.日志ToolStripMenuItem_Click);
            // 
            // 统计ToolStripMenuItem
            // 
            this.统计ToolStripMenuItem.Name = "统计ToolStripMenuItem";
            this.统计ToolStripMenuItem.Size = new System.Drawing.Size(53, 24);
            this.统计ToolStripMenuItem.Text = "统计";
            this.统计ToolStripMenuItem.Click += new System.EventHandler(this.统计ToolStripMenuItem_Click);
            // 
            // mainPanel
            // 
            this.mainPanel.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.mainPanel.Controls.Add(this.mainTab);
            this.mainPanel.Location = new System.Drawing.Point(0, 27);
            this.mainPanel.Name = "mainPanel";
            this.mainPanel.Size = new System.Drawing.Size(922, 348);
            this.mainPanel.TabIndex = 4;
            // 
            // mainTab
            // 
            this.mainTab.Dock = System.Windows.Forms.DockStyle.Fill;
            this.mainTab.DrawMode = System.Windows.Forms.TabDrawMode.OwnerDrawFixed;
            this.mainTab.Location = new System.Drawing.Point(0, 0);
            this.mainTab.Name = "mainTab";
            this.mainTab.Padding = new System.Drawing.Point(15, 3);
            this.mainTab.SelectedIndex = 0;
            this.mainTab.Size = new System.Drawing.Size(922, 348);
            this.mainTab.SizeMode = System.Windows.Forms.TabSizeMode.FillToRight;
            this.mainTab.TabIndex = 0;
            // 
            // statusStrip1
            // 
            this.statusStrip1.ImageScalingSize = new System.Drawing.Size(20, 20);
            this.statusStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripStatusLabel1});
            this.statusStrip1.Location = new System.Drawing.Point(0, 376);
            this.statusStrip1.Name = "statusStrip1";
            this.statusStrip1.Size = new System.Drawing.Size(922, 25);
            this.statusStrip1.TabIndex = 5;
            this.statusStrip1.Text = "statusStrip1";
            // 
            // toolStripStatusLabel1
            // 
            this.toolStripStatusLabel1.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
            this.toolStripStatusLabel1.Margin = new System.Windows.Forms.Padding(0, 3, 10, 2);
            this.toolStripStatusLabel1.Name = "toolStripStatusLabel1";
            this.toolStripStatusLabel1.Size = new System.Drawing.Size(33, 20);
            this.toolStripStatusLabel1.Text = "----";
            // 
            // timerRefresh
            // 
            this.timerRefresh.Enabled = true;
            this.timerRefresh.Interval = 10000;
            this.timerRefresh.Tick += new System.EventHandler(this.timerRefresh_Tick);
            // 
            // FrmMain
            // 
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.None;
            this.AutoSize = true;
            this.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.AutoValidate = System.Windows.Forms.AutoValidate.Disable;
            this.BackgroundImage = global::HY.WCS.Client.Properties.Resources.任务管理系统;
            this.ClientSize = new System.Drawing.Size(922, 401);
            this.Controls.Add(this.statusStrip1);
            this.Controls.Add(this.mainPanel);
            this.Controls.Add(this.msMain);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "FrmMain";
            this.Text = "华信藤仓通讯有限公司WCS管理系统";
            this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.FrmMain_FormClosed);
            this.Load += new System.EventHandler(this.FrmMain_Load);
            this.msMain.ResumeLayout(false);
            this.msMain.PerformLayout();
            this.mainPanel.ResumeLayout(false);
            this.statusStrip1.ResumeLayout(false);
            this.statusStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.MenuStrip msMain;


        private System.Windows.Forms.Panel mainPanel;
        private System.Windows.Forms.StatusStrip statusStrip1;
        public System.Windows.Forms.ToolStripStatusLabel toolStripStatusLabel1;
      
        private CMFrameWork.Windows.Controls.MainTab mainTab;
        private System.Windows.Forms.ToolStripMenuItem 全局监控csMain;
        private System.Windows.Forms.ToolStripMenuItem 设备状态csMain;
        private System.Windows.Forms.Timer timerRefresh;
        private System.Windows.Forms.ToolStripMenuItem 任务列表ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 日志ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 统计ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 传输线2ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem1;
    }
}