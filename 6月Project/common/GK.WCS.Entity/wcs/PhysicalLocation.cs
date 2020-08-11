﻿using GK.Common.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GK.WCS.Entity.wcs
{
    public class PhysicalLocation : BaseEntity
    {
        public int shelfId
        {
            get; set;
        }

        public int row
        {
            get; set;
        }

        public int col
        {
            get; set;
        }
        public int craneId
        {
            get; set;
        }

        //public int plcShelf
        //{
        //    get; set;
        //}

        //public int plcRow
        //{
        //    get; set;
        //}

        //public int plcCol
        //{
        //    get; set;
        //}

        public int x
        {
            get; set;
        }

        public int y
        {
            get; set;
        }

        public int z
        {
            get; set;
        }
        public short deep
        {
            get; set;
        }
        public short Direction
        {
            get; set;
        }
        public int signPoint
        {
            get; set;
        }
    }
}
