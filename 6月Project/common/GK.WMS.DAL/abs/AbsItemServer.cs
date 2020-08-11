using Dapper;
using GK.Common.dto;
using GK.DAL.inter;
using GK.WMS.DAL.abs;
using GK.WMS.Entity;
using GK.WMS.Entity.wms;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace GK.WMS.DAL
{
    public abstract class AbsItemServer : AbsWMSBaseServer, IItemServer
    {
        #region 物料
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();
        //物料添加
        public long AddMaterial(CoreItem coreItem)
        {
            coreItem.id = sequenceIdServer.getId();
            coreItem.classifyId = coreItem.classifyId;
            coreItem.code = coreItem.code;
            coreItem.name = coreItem.name;
            coreItem.active = coreItem.active;
            coreItem.modelSpecs = coreItem.modelSpecs;
            coreItem.packageSpecs = coreItem.packageSpecs;
            coreItem.isSorting = coreItem.isSorting;
            return Connection.Insert<CoreItem>(coreItem);
        }
        //分页查询
        public Page<CoreItem> QueryMaterialPage<CoreItem>(CoreItemDto dto)
        {
            string sql = @"SELECT ci.id,ci.classify_Id,
                           ci.code,ci.name,ci.core_Item_Type,ci.model_specs,ci.package_specs,ci.is_Sorting,
                           CASE ci.active
                           WHEN 0 THEN '正常'
                           ELSE '禁用'
                           END AS active
                           FROM dbo.core_item ci
                           LEFT JOIN dbo.Core_classify cc
                           ON ci.classify_Id=cc.id where 1=1";
            if (dto != null && !string.IsNullOrEmpty(dto.name))
            {
                dto.name = "%" + dto.name + "%";
                sql += " AND ci.name like @name ";
            }
            if (dto != null && dto.classifyId != 0)
            {
                sql += " AND ci.classify_Id = @classifyId ";
            }
            if (dto != null && dto.coreItemType > 0)
            {
                sql += " AND ci.core_Item_Type = @coreItemType ";
            }
            if (dto != null && !string.IsNullOrEmpty(dto.code))
            {
                dto.code = "%" + dto.code + "%";
                sql += " AND ci.code like @code ";
            }
            if (dto != null && !string.IsNullOrEmpty(dto.modelSpecs))
            {
                dto.modelSpecs = "%" + dto.modelSpecs + "%";
                sql += " AND ci.model_specs like @modelSpecs ";
            }
            return this.queryPage<CoreItem>(sql, "id", dto);
        }

        public List<CoreItem> getAllItem()
        {
            String sql = "select * from dbo.core_item  ";
            return Connection.Query<CoreItem>(sql).ToList();
        }
        //修改激活状态
        public bool UpdateActive(CoreItem model)
        {
            Connection.Update<CoreItem>(model);
            return true;
        }

        public bool UpdateInfo(CoreItem model)
        {
            string sql = @"UPDATE [dbo].[core_item] SET classify_Id =@classify_Id,core_Item_Type=@core_Item_Type,package_specs=@package_specs,is_Sorting=@isSorting 
                            WHERE id=@id";
            int a = Connection.Execute(sql, new { classify_Id = model.classifyId, core_Item_Type = model.coreItemType, package_specs = model.packageSpecs, isSorting = model.isSorting, id = model.id });
            if (a >= 1)
            {
                return true;
            }
            return false;
        }
        //通过物料类别ID查询信息
        public List<CoreItem> GetCoreItemByClassfiyId(long classifyId)
        {
            String sql = "select * from dbo.core_item where classify_Id=@classifyId";
            return Connection.Query<CoreItem>(sql, new { classifyId = classifyId }).ToList();
        }
        //物料删除
        public int DeleteCoreItem(List<CoreItem> coreItemList)
        {
            foreach (var coreItem in coreItemList)
            {
                Connection.Delete<CoreItem>("id=" + coreItem.id.ToString());
            }
            return 1;
        }
        //通过物料code查询信息
        public List<CoreItem> GetCoreItemByCode(string code)
        {
            String sql = "select * from dbo.core_item where code=@code";
            return Connection.Query<CoreItem>(sql, new { code = code }).ToList();
        }
        //通过Id找物料
        public CoreItem FindCoreItemById(long id)
        {
            return Connection.Get<CoreItem>(id);
        }

        public List<CoreItemDto> GetExportList(CoreItemDto dto)
        {
            string sql = @"SELECT A.*,B.name AS classifyName,C.label AS coreItemTypeName FROM dbo.core_item A 
                            LEFT OUTER JOIN dbo.Core_classify B
                            ON A.classify_Id=B.id
                            LEFT OUTER JOIN dbo.sys_dict C ON A.core_Item_Type=C.value AND C.dtype='coreItemType' where 1=1 ";
            if (dto != null && !string.IsNullOrEmpty(dto.name))
            {
                dto.name = "%" + dto.name + "%";
                sql += " AND A.name like @name ";
            }
            if (dto != null && dto.classifyId != 0)
            {
                sql += " AND A.classify_Id = @classifyId ";
            }
            if (dto != null && dto.coreItemType > 0)
            {
                sql += " AND A.core_Item_Type = @coreItemType ";
            }
            return Connection.Query<CoreItemDto>(sql, dto).ToList();
            //new { name = dto.name, classifyId = dto.classifyId, coreItemType = dto.coreItemType }
        }
        #endregion

        #region 物料类别
        //添加
        public long AddClassify(CoreClassify model)
        {
            model.id = sequenceIdServer.getId();
            model.name = model.name;
            model.info = model.info;
            model.stockWidth = model.stockWidth;
            model.stockHigh = model.stockHigh;
            model.stockDeep = model.stockDeep;
            return Connection.Insert<CoreClassify>(model);
        }
        //修改
        public bool UpdateClassify(CoreClassify model)
        {
            //model.lastUpdateBy = model.name;
            //model.lastUpdateTime = sequenceIdServer.GetTime();
            //UpdateClassifyId()
            return Connection.Update<CoreClassify>(model);
        }
        //删除
        public bool DeleteByClassifyId(long classifyId)
        {
            return Connection.Delete<CoreItem>("user_ids=" + classifyId);
        }
        //删除物料类别
        public int DeleteClassify(List<CoreClassify> classifyList)
        {
            foreach (var classify in classifyList)
            {
                Connection.Delete<CoreClassify>("id=" + classify.id.ToString());
            }
            return 1;
        }
        //通过ID查找
        public CoreClassify FindClassifyById(long id)
        {
            return Connection.Get<CoreClassify>(id);
        }
        //分页显示
        public Page<ClassQuery> QueryClassifyPage<ClassQuery>(ClassifyDto dto)
        {
            string sql = @"SELECT cc.* FROM dbo.Core_classify cc where 1=1";
            if (dto != null && !string.IsNullOrEmpty(dto.name))
            {
                dto.name = "%" + dto.name + "%";
                sql += " AND cc.name like @name ";
            }
            return this.queryPage<ClassQuery>(sql, "id", dto);
        }
        //根据名称查询
        public bool QueryClassifyPageByName(CoreClassify coreClassify)
        {
            string sql = @"SELECT * FROM dbo.Core_classify cc where cc.name='{0}'";
            sql = string.Format(sql, coreClassify.name);
            List<CoreClassify> list = Connection.Query<CoreClassify>(sql, coreClassify).ToList();
            if (list.Count == 0)
            {
                return false;
            }
            else
            {
                return true;
            }
            //return this.queryPage<ClassQuery>(sql, "id", dto);
        }

        //根据名称查询
        public CoreClassify QueryClassifyByName(string classifyName)
        {
            string sql = @"SELECT * FROM dbo.Core_classify cc where cc.name='{0}'";
            sql = string.Format(sql, classifyName);
            List<CoreClassify> list = Connection.Query<CoreClassify>(sql, classifyName).ToList();
            CoreClassify coreClassify = list[0];
            //return this.queryPage<ClassQuery>(sql, "id", dto);
            return coreClassify;
        }


        //批量设置物料类别库位信息
        public bool BatchSetLoc(List<long> locList, long areaid)
        {
            CoreClassifyArea coreClassifyArea = new CoreClassifyArea();
            for (int i = 0; i < locList.Count(); i++)
            {
                long iid = locList[i];
                coreClassifyArea.id = sequenceIdServer.getId();
                coreClassifyArea.classifyId = iid;
                coreClassifyArea.areaId = areaid;
                insertNotNull(coreClassifyArea);
            }
            return true;
        }

        public string ImportList(List<CoreItem> coreItemList)
        {
            string message = string.Empty;
            if (!Check(coreItemList, out message))
            {
                return message;
            }
            foreach (var model in coreItemList)
            {
                var coreItem = Connection.Query("select * from core_item where code=@code", new { code = model.code }).FirstOrDefault();
                if (coreItem != null)
                {
                    return message = "500,该物料编码已存在";
                }
                model.id = sequenceIdServer.getId();
            }
            try
            {
                string sql = @"INSERT INTO dbo.core_item (id ,classify_Id ,code ,name ,active ,core_Item_Type ,model_specs ,package_specs)
                            VALUES  ( @id ,@classifyId , @code ,@name , @active, @coreItemType,@modelSpecs ,@packageSpecs)";
                if (Connection.Execute(sql, coreItemList) > 0)
                {
                    return "200,操作成功";
                }
                else
                {
                    return "500,Excel数据异常";
                }
            }
            catch 
            {

                return "500,Excel模板不对";
            }
            
        }

        private bool Check(List<CoreItem> coreItemList, out string message)
        {
            int oldCount = coreItemList.Count;
            message = string.Empty;
            if (coreItemList.Count == 0)
            {
                message = "500,当前Excel不存在数据!";
                return false;
            }
            if (coreItemList.Exists(a => a.coreItemType == 0))
            {
                message = "500,Excel里面的物料类型不存在";
                return false;

            }
            if (coreItemList.Exists(a => a.classifyId == 0))
            {
                message = "500,Excel里面的物料类别不存在";
                return false;

            }
            int codeCount = coreItemList.Select(p => p.code).ToList().Distinct().ToList().Count;
            if (oldCount != codeCount)
            {
                message = "500,Excel里面编码存在重复";
                return false;
            }
            var newList = from m in coreItemList select new { m.name, m.modelSpecs };
            int nameCount = newList.ToList().Distinct().ToList().Count;
            if (oldCount != nameCount)
            {
                message = "500,Excel里面物料规格存在重复";
                return false;
            }      
            return true;
        }

        #endregion


        #region 物料类别分区
        //添加
        public long AddClassifyArea(CoreClassifyArea model)
        {
            model.id = sequenceIdServer.getId();
            return Connection.Insert<CoreClassifyArea>(model);
        }
        //修改
        public bool UpdateClassifyArea(CoreClassifyArea model)
        {
            return Connection.Update<CoreClassifyArea>(model);
        }

        //删除物料类别
        public int DeleteClassifyArea(List<CoreClassifyArea> classifyAreaList)
        {
            foreach (var classifyArea in classifyAreaList)
            {
                Connection.Delete<CoreClassifyArea>("id=" + classifyArea.id.ToString());
            }
            return 1;
        }

        //分页显示
        public Page<CoreClassifyArea> QueryClassifyAreaPage(CoreClassifyAreaDto dto)
        {
            string sql = @"select * from core_classify_Area where 1=1";
            if (dto.classifyId != 0)
            {
                sql += " AND classify_Id=@classifyId ";
            }
            if (dto.areaId != 0)
            {
                sql += " AND area_Id=@areaId ";
            }
            if (dto.priority != 0)
            {
                sql += " AND priority=@priority ";
            }
            return this.queryPage<CoreClassifyArea>(sql, "id", dto);
        }




        #endregion
    }
}
