
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.Data;

namespace GK.WCS.DAL
{
    public interface INoTaskControlServer {
         bool clearNoTaskControl(long id);
         bool RGVError(int value);
        bool RGVPackage(int value); bool RGVProduct(int value); bool craneCarrierMode(int value);
        bool RgvMode(int value);
        int getNoTaskControlValueById(long id);


    }
}
