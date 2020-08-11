using System;
using System.ComponentModel;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Threading;
using System.Windows.Forms;

namespace GK.WCS.Client.Control {
    public partial class Belt:UserControl {
        #region 属性


        private int beltID_in;
        private int beltID_out;
        public int BELTID_IN
        {
            get
            {
                return beltID_in;
            }
            set
            {
                beltID_in = value;
            }
        }
        public int BELTID_OUT
        {
            get
            {
                return beltID_out;
            }
            set
            {
                beltID_out = value;
            }
        }

        private bool _bIsError = false;

        public enum 输送方向 {
            左,
            右,
            上,
            下
        }
        public enum 绘图方向 {
            上下 = 1,
            左右 = 2
        }

        private 箭头样式 _ArrowCap = 箭头样式.单向;
        [Description("箭头样式.")]
        public 箭头样式 ArrowCap
        {
            get
            {
                return _ArrowCap;
            }
            set
            {
                _ArrowCap = value;
            }
        }

        public enum 箭头样式 {
            单向,
            双向
        }

        private 输送方向 _transDir = 输送方向.上;
        [Description("输送方向.")]
        public 输送方向 TransDir
        {
            get
            {
                return _transDir;
            }
            set
            {
                _transDir = value;
            }
        }

        //ghs.DrawEllipse(myPen, 0, 0, this.Width - _boldWidth, this.Height - _boldWidth);
        //float R = (this.Width - _boldWidth) / 2F;
        //ghs.DrawLine(pen1, R, 0, R, this.Height - _boldWidth);
        //ghs.DrawLine(pen1, 0, R, this.Width - _boldWidth, R);

        private 绘图方向 _direction = 绘图方向.上下;

        /// <summary>
        /// 绘图方向
        /// </summary>
        [Description("绘图方向.")]
        public 绘图方向 Direction
        {
            get
            {
                return _direction;
            }
            set
            {
                _direction = value;
            }
        }
        private Color _lineColor = Color.Blue;
        private Color ArrowColor = Color.Blue;
        private int _lineWidth = 1;

        [Description("线条宽度.")]
        public int LineWidth
        {
            get
            {
                return _lineWidth;
            }
            set
            {
                _lineWidth = value;
                base.Invalidate();
            }
        }

        private int _arrowWidth = 10;
        [Description("箭头宽度.")]
        public int ArrowWidth
        {
            get
            {
                return _arrowWidth;
            }
            set
            {
                base.Invalidate();
            }
        }




        #endregion
        public Belt() {
            InitializeComponent();
            SetStyle(ControlStyles.SupportsTransparentBackColor | ControlStyles.UserPaint | ControlStyles.AllPaintingInWmPaint | ControlStyles.Opaque,true);

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


        protected override void OnPaint(PaintEventArgs e) {
            base.OnPaint(e);

            Graphics ghs = this.CreateGraphics();
            ghs.SmoothingMode = SmoothingMode.AntiAlias;
            Pen myPen = new Pen(this._lineColor,_lineWidth);
            Pen pen1 = new Pen(this._lineColor,1);
            Pen pArrow = new Pen(ArrowColor,_arrowWidth);
            Pen hasSignPoint = new Pen(Color.Chartreuse,10);

            if(_ArrowCap.Equals(箭头样式.双向)) {
                pArrow.StartCap = LineCap.ArrowAnchor;
            } else {
                pArrow.StartCap = LineCap.Square;
            }

            pArrow.EndCap = LineCap.ArrowAnchor;
            try {
                int leftX1 = this.Width - _lineWidth;
                int leftX2 = this.Width - _lineWidth * 2 - 2;
                if(this._direction == 绘图方向.上下) {


                    ghs.DrawLine(myPen,new Point(_lineWidth,0),new Point(_lineWidth,this.Height));
                    //ghs.DrawLine(myPen, new Point(_lineWidth * 2 + 2, 0), new Point(_lineWidth * 2 + 2, this.Height));
                    ghs.DrawLine(myPen,new Point(this.Width - _lineWidth,0),new Point(this.Width - _lineWidth,this.Height));
                    //ghs.DrawLine(myPen, new Point(this.Width - _lineWidth * 2 - 2, 0), new Point(this.Width - _lineWidth * 2 - 2, this.Height));

                    int startX = _lineWidth * 2 + 2;
                    int EndX = this.Width - _lineWidth * 2 - 2;
                    int _c = this.Height / 3;
                    for(int i = 0;i < _c;i++) {
                        ghs.DrawRectangle(pen1,new Rectangle(startX,i * 3,this.Width - _lineWidth * 4 - 4,i * 3));
                    }
                    int ArrowLength = Math.Max((int)(this.Height * 0.3),20);
                    if(this._transDir == 输送方向.上) {
                        ghs.DrawLine(pArrow,this.Width / 2,this.Height - (this.Height - ArrowLength) / 2,this.Width / 2,(this.Height - ArrowLength) / 2);
                    }else if(this._transDir == 输送方向.下) {
                        ghs.DrawLine(pArrow,this.Width / 2,(this.Height - ArrowLength) / 2,this.Width / 2,this.Height - (this.Height - ArrowLength) / 2);
                    }

                    if(sign1) {
                        ghs.DrawLine(hasSignPoint,Width / 2,5,Width / 2,15);
                    }
                    if(sign2) {
                        ghs.DrawLine(hasSignPoint,Width / 2,Height - 5,Width / 2,Height - 15);
                    }

                } else {


                    ghs.DrawLine(myPen,new Point(0,_lineWidth),new Point(this.Width,_lineWidth));
                    //ghs.DrawLine(myPen, new Point(0, _lineWidth * 2 + 2), new Point(this.Width, _lineWidth * 2 + 2));
                    ghs.DrawLine(myPen,new Point(0,this.Height - _lineWidth),new Point(this.Width,this.Height - _lineWidth));
                    //ghs.DrawLine(myPen, new Point(0, this.Height - _lineWidth * 2 - 2), new Point(this.Width, this.Height - _lineWidth * 2 - 2));
                    int startY = _lineWidth * 2 + 2;
                    int EndY = this.Height - _lineWidth * 2 - 2;
                    int _c = this.Width / 3;
                    for(int i = 0;i < _c;i++) {
                        ghs.DrawRectangle(pen1,new Rectangle(i * 3,startY,i * 3,this.Height - _lineWidth * 4 - 4));
                        //ghs.DrawLine(pen1, new Point(i * 2, startY), new Point(i * 2, EndY));

                    }
                    int ArrowLength = Math.Max((int)(this.Width * 0.3),20);
                    if(this._transDir == 输送方向.左) {
                        ghs.DrawLine(pArrow,this.Width - (this.Width - ArrowLength) / 2,this.Height / 2,(this.Width - ArrowLength) / 2,this.Height / 2);
                    }else  if(this._transDir == 输送方向.右) {
                        ghs.DrawLine(pArrow,(this.Width - ArrowLength) / 2,this.Height / 2,this.Width - (this.Width - ArrowLength) / 2,this.Height / 2);
                    }
                    if(sign1) {
                        ghs.DrawLine(hasSignPoint,5,Height / 2,15,Height / 2);
                    }
                    if(sign2) {
                        ghs.DrawLine(hasSignPoint,Width - 5,Height / 2,Width - 15,Height / 2);
                    }
                }

            } catch(Exception) {

            } finally {
                ghs.Dispose();
                myPen.Dispose();
                pen1.Dispose();
                pArrow.Dispose();
            }

        }

        void DrawBelt() {

        }


        public void setSign1(bool s1) {
            if(sign1 != s1) {
                _bIsError = true;
                sign1 = s1;

            }

        }
        public void setSign2(bool s2) {
            if(sign2 != s2) {
                _bIsError = true;

                sign2 = s2;
            }

        }


        public void reflash() {
            if(_bIsError) {
                
                _bIsError = false;
                this.Invalidate(true);
            }

        }
        bool sign1 = false;
        bool sign2 = false;
        public void SetLineColor(Color line) {
            if(this._lineColor != line) {
                _bIsError = true;
                this._lineColor = line;

            }
        }

        public void SetArrowColor(Color arrowColor) {
            if(this.ArrowColor != arrowColor) {

                _bIsError = true;
                this.ArrowColor = arrowColor;
            }
        }





    }
}
