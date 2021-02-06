//----------CoreItem开始----------



using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Blog.Core.IRepository;
using Blog.Core.IServices;
using Blog.Core.Model.Models;
using Blog.Core.Services.BASE;
using SqlSugar;

namespace Blog.Core.Services
{
    /// <summary>
    /// CoreItemServices
    /// </summary>	
    public class CoreItemServices : BaseServices<CoreItem>, ICoreItemServices
    {

        ICoreItemRepository dal;
        public CoreItemServices(ICoreItemRepository dal)
        {
            this.dal = dal;
            base.BaseDal = dal;
        }


        public async Task<bool> ImportList(List<CoreItem> coreItemList, RefAsync<string> message)
        {
            if (!Check(coreItemList, message))
            {
                return false;
            }
            foreach (var model in coreItemList)
            {
                var coreItem = await dal.Query(a => a.code == model.code);
                if (coreItem != null && coreItem.Count > 0)
                {
                    message = "该物料编码已存在";
                    return false;
                }
                model.id = await dal.GetId();
            }
            try
            {
                await dal.Add(coreItemList);
                return true;
            }
            catch
            {

                message = "Excel模板不对";
                return false;
            }
        }


        private bool Check(List<CoreItem> coreItemList, RefAsync<string> message)
        {
            int oldCount = coreItemList.Count;
            message = string.Empty;
            if (coreItemList.Count == 0)
            {
                message = "当前Excel不存在数据!";
                return false;
            }
            if (coreItemList.Exists(a => a.coreItemType == 0))
            {
                message = "Excel里面的物料类型不存在";
                return false;

            }
            if (coreItemList.Exists(a => a.classifyId == 0))
            {
                message = "Excel里面的物料类别不存在";
                return false;

            }
            int codeCount = coreItemList.Select(p => p.code).ToList().Distinct().ToList().Count;
            if (oldCount != codeCount)
            {
                message = "Excel里面编码存在重复";
                return false;
            }
            var newList = from m in coreItemList select new { m.name, m.modelSpecs };
            int nameCount = newList.ToList().Distinct().ToList().Count;
            if (oldCount != nameCount)
            {
                message = "Excel里面物料规格存在重复";
                return false;
            }
            return true;
        }
    }
}

//----------CoreItem结束----------
