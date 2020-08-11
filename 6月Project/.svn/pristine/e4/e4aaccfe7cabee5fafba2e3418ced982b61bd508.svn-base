using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Threading;
using System.Windows.Forms;

namespace GK.WCS.Client.Control
{
    public partial class Legend: UserControl
    {
        #region 属性


        private int beltID_in;
        private int beltID_out;
        public int BELTID_IN
        {
            get { return beltID_in; }
            set { beltID_in = value; }
        }
        public int BELTID_OUT
        {
            get { return beltID_out; }
            set { beltID_out = value; }
        }

   
        


        public Color _lineColor = Color.Yellow;
        public String  title ="";

        public Dictionary<String,Color> dict=new Dictionary<String,Color>();

        #endregion
        public Legend()
        {
            InitializeComponent();
          
            SetStyle(ControlStyles.SupportsTransparentBackColor | ControlStyles.UserPaint | ControlStyles.AllPaintingInWmPaint | ControlStyles.Opaque, true);
            this.BackColor = Color.AliceBlue;
        }

        protected override CreateParams CreateParams
        {
            get
            {
                var result = base.CreateParams;
                result.ExStyle |= 0x00000020;

                return result;
            }
        }

        int lineWidth = 20;
        protected override void OnPaint(PaintEventArgs e) {
           
            base.OnPaint(e);
         
            Graphics ghs = this.CreateGraphics();
            ghs.SmoothingMode = SmoothingMode.AntiAlias;
            Font f = new System.Drawing.Font("宋体",10F,System.Drawing.FontStyle.Regular,System.Drawing.GraphicsUnit.Point,((byte)(134)));

            Pen hasSignPoint = new Pen(_lineColor,lineWidth);
            try {
                if(!String.IsNullOrEmpty(title)) {
                    ghs.DrawString(title,f,new SolidBrush(Color.White),2,1);
                }
             
             
            } finally {
                hasSignPoint.Dispose();

            }

           int y = 30;
            foreach(var d in dict) {
                hasSignPoint = new Pen(d.Value,lineWidth);
                try {
                    ghs.DrawLine(hasSignPoint,5,y,85,y);
                    ghs.DrawString(d.Key,f,new SolidBrush(Color.White),90,y-7);
                    y += lineWidth;
                } finally {
                    hasSignPoint.Dispose();

                }
            }
            

        }

    
      
       
       

    }
}
