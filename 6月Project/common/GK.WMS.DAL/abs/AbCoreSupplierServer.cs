using Common.dto;
using Dapper;
using GK.WMS.DAL.abs;
using GK.WMS.Entity;
using GK.WMS.Entity.wms;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using WMS.DAL;
using WMS.Entity;

namespace GK.WMS.DAL
{
    public abstract class AbCoreSupplierServer : AbsWMSBaseServer, ICoreSupplierServer
    {
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();
        #region 供应商信息
        //添加
        public long AddSupplier(CoreSupplierCorp model)
        {
            model.id = sequenceIdServer.getId();
            if (model.editable == "可编辑")
            {
                model.editable = "0";
            }
            else if (model.editable == "不可编辑")
            {
                model.editable = "1";
            }
            return Connection.Insert<CoreSupplierCorp>(model);
        }
        //修改
        public bool UpdateSupplier(CoreSupplierCorp model)
        {
            if (model.editable == "可编辑")
            {
                model.editable = "0";
            }
            else if (model.editable == "不可编辑")
            {
                model.editable = "1";
            }
            return Connection.Update<CoreSupplierCorp>(model);
        }
        //删除物料类别
        public int DeleteSupplier(List<CoreSupplierCorp> CoreSupplierCorpList)
        {
            foreach (var CoreSupplierCorp in CoreSupplierCorpList)
            {
                Connection.Delete<CoreSupplierCorp>("id=" + CoreSupplierCorp.id.ToString());
            }
            return 1;
        }
        //通过ID查找
        public CoreSupplierCorp FindSupplierById(long id)
        {
            return Connection.Get<CoreSupplierCorp>(id);
        }
        //分页显示
        public Page<CoreSupplierCorp> QuerySupplierPage(CoreSupplierCorpDto dto)
        {
            string sql = @"SELECT id,name,code,nc_id,address,
                           CASE editable
                           WHEN 0 THEN '可编辑'
                           ELSE '不可编辑'
                           END AS editable from
                           core_supplier_corp where 1=1";
            if (dto != null && !string.IsNullOrEmpty(dto.name))
            {
                dto.name = "%" + dto.name + "%";
                sql += " AND name like @name ";
            }
            if (dto != null && !string.IsNullOrEmpty(dto.editable))
            {
                if (dto.editable == "可编辑")
                {
                    dto.editable = "0";
                }
                else if (dto.editable == "不可编辑")
                {
                    dto.editable = "1";
                }
                sql += " AND editable = @editable ";
            }
            return this.queryPage<CoreSupplierCorp>(sql, "id", dto);
        }
        //批量设置物料类别库位信息
        public bool BatchSetItem(List<long> locList, long itemId)
        {
            CoreCorpItem coreCorpItem = new CoreCorpItem();
            for (int i = 0; i < locList.Count(); i++)
            {
                long iid = locList[i];
                coreCorpItem.id = sequenceIdServer.getId();
                coreCorpItem.supplierId = iid;
                coreCorpItem.itemId = itemId;
                insertNotNull(coreCorpItem);
            }
            return true;
        }

        //供应商导出
        public List<CoreSupplierCorp> GetExportList(CoreSupplierCorpDto dto)
        {
            string sql = @"select * from Core_Supplier_Corp where 1=1 ";
            if (dto != null && !string.IsNullOrEmpty(dto.name))
            {
                dto.name = "%" + dto.name + "%";
                sql += " AND name like @name ";
            }
            if (dto != null && !string.IsNullOrEmpty(dto.editable))
            {
                if (dto.editable == "可编辑")
                {
                    dto.editable = "0";
                }
                else if (dto.editable == "不可编辑")
                {
                    dto.editable = "1";
                }
                sql += " AND editable = @editable ";
            }
            return Connection.Query<CoreSupplierCorp>(sql, dto).ToList();
        }
        /// <summary>
        /// /供应商导入
        /// </summary>
        /// <param name="supplierList"></param>
        /// <returns></returns>
        public string ImportList(List<CoreSupplierCorp> supplierList)
        {
            string message = string.Empty;
            if (!Check(supplierList, out message))
            {
                return message;
            }
            foreach (var model in supplierList)
            {
                var supplier = Connection.Query("select * from Core_Supplier_Corp where code=@code", new { code = model.code }).FirstOrDefault();
                if (supplier != null)
                {
                    return "500,该供应商编码已存在";
                }
                model.id = sequenceIdServer.getId();
            }
            try
            {
                string sql = @"INSERT INTO dbo.Core_Supplier_Corp (id ,nc_Id ,code ,name ,editable ,address )
                            VALUES  ( @id ,@ncId , @code ,@name , @editable, @address)";
                if (Connection.Execute(sql, supplierList) > 0)
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

        private bool Check(List<CoreSupplierCorp> supplierList, out string message)
        {
            int oldCount = supplierList.Count;
            message = string.Empty;
            if (supplierList.Count == 0)
            {
                message ="500,当前Excel不存在数据!";
                return false;
            }
            int codeCount = supplierList.Select(p => p.code).ToList().Distinct().ToList().Count;
            if (oldCount != codeCount)
            {
                message = "500,Excel里面编码存在重复";
                return false;
            }
            var newlist = from m in supplierList select new { m.name, m.address };
            int nameCount = newlist.ToList().Distinct().ToList().Count;
            if (oldCount!=nameCount)
            {
                message = "500,Excel里面供应商名称和地址存在重复";
                return false;
            }
            return true;
        }
        //
        #endregion
        #region 供应商物料绑定
        //添加
        public long AddCorpItem(CoreCorpItem model)
        {
            model.id = sequenceIdServer.getId();
            return Connection.Insert<CoreCorpItem>(model);
        }
        //修改
        public bool UpdateCorpItem(CoreCorpItem model)
        {
            return Connection.Update<CoreCorpItem>(model);
        }
        //删除供应商物料绑定
        public int DeleteCorpItem(List<CoreCorpItem> coreCorpItemList)
        {
            foreach (var coreCorpItem in coreCorpItemList)
            {
                Connection.Delete<CoreCorpItem>("id=" + coreCorpItem.id.ToString());
            }
            return 1;
        }
        //分页显示
        public Page<CoreCorpItem> QueryCorpItemPage(CoreCorpItemDto dto)
        {
            string sql = @"select * from core_corp_item where 1=1";
            if (dto != null && dto.supplierId != 0)
            {
                sql += " AND supplier_Id=@supplierId ";
            }
            if (dto != null && dto.itemId != 0)
            {
                sql += " AND item_Id=@itemId ";
            }
            return this.queryPage<CoreCorpItem>(sql, "id", dto);
        }
        //根据供应商ID去查询是否绑定物料
        public List<CoreCorpItem> FindCorpItemById(long supplierId)
        {
            string sql = @"select * from core_Corp_Item where supplier_Id=@supplierId";
            List<CoreCorpItem> list = Connection.Query<CoreCorpItem>(sql, new { supplierId }).ToList();
            return list;
        }


        /// <summary>
        /// 供应商物料导出
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        public List<CoreCorpItemDto> GetExportGcList(CoreCorpItemDto dto)
        {
            string sql = @"SELECT B.name,C.name AS gysName FROM dbo.core_Corp_Item A
                            LEFT OUTER JOIN dbo.core_item B ON A.item_Id=B.id
                            LEFT OUTER JOIN dbo.Core_Supplier_Corp C ON A.supplier_Id=C.id WHERE 1=1 ";
            if (dto != null && dto.supplierId != 0)
            {
                sql += " AND supplier_Id=@supplierId ";
            }
            if (dto != null && dto.itemId != 0)
            {
                sql += " AND item_Id=@itemId ";
            }
            return Connection.Query<CoreCorpItemDto>(sql, dto).ToList();
        }



        /// <summary>
        /// 供应商物料导入
        /// </summary>
        /// <param name="coreCorpItemList"></param>
        /// <returns></returns>
        public string ImportGcList(List<CoreCorpItem> coreCorpItemList)
        {
            string message = string.Empty;
            if (!CheckGc(coreCorpItemList, out message))
            {
                return message;
            }
            foreach (var model in coreCorpItemList)
            {
                var coreItem = Connection.Query("select * from core_Corp_Item where supplier_Id=@supplierId and item_Id=@itemId", new { supplierId = model.supplierId, itemId = model.itemId }).FirstOrDefault();
                if (coreItem != null)
                {
                    return "500,该物料供应商已存在";
                }
                model.id = sequenceIdServer.getId();
            }
            try
            {
                string sql = @"INSERT INTO dbo.core_Corp_Item (id ,supplier_Id ,item_Id)
                            VALUES  ( @id ,@supplierId , @itemId )";
                if (Connection.Execute(sql, coreCorpItemList) > 0)
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

        private bool CheckGc(List<CoreCorpItem> coreCorpItemList, out string message)
        {
            int oldCount = coreCorpItemList.Count;
            message = string.Empty;
            if (coreCorpItemList.Exists(a => a.itemId == 0))
            {

                message = "500,Excel里面的物料不存在";
                return false;
            }
            if (coreCorpItemList.Exists(a => a.supplierId == 0))
            {
                message = "500,Excel里面的供应商不存在";
                return false;
            }
            var list = from m in coreCorpItemList select new { m.itemId, m.supplierId };
            int newCount = list.Distinct().ToList().Count;
            if (oldCount != newCount)
            {
                message = "500,Excel里面物料供应商存在重复";
                return false;
            }
            return true;
        }
        #endregion
    }
}
