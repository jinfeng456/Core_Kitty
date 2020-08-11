using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace GK.WCS.Entity
{
    [Serializable]
    public partial class RTConfig
    {
        public RTConfig()
        { }
        #region Model
        private int _id;
   
        private int _overstop;

        private int _cranestatus;
        private int _centerDistance1;
        private int _centerDistance2;
        public int CenterDistance1
        {
            set
            {
                _centerDistance1 = value;
            }
            get
            {
                return _centerDistance1;
            }

        }
        public int CenterDistance2
        {
            set
            {
                _centerDistance2 = value;
            }
            get
            {
                return _centerDistance2;
            }

        }

        public int Cranestatus
        {

            set
            {
                _cranestatus = value;
            }
            get
            {
                return _cranestatus;
            }

        }
       
        /// <summary>
        /// 
        /// </summary>
        public int ID
        {
            set { _id = value; }
            get { return _id; }
        }
      
      
        public int Overstop
        {
            set
            {
                _overstop = value;
            }
            get
            {
                return _overstop;
            }
        }

        
        #endregion Model
    }
}