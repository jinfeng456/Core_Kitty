import axios from "../../../axios";

/* 
 * 用户管理模块
 */

// 保存
export const save = (data) => {
  return axios({
    url: '/corpitem/save',
    method: 'post',
    data
  })
}
// 恢复
export const restore = (data) => {
  return axios({
    url: '/corpitem/update',
    method: 'post',
    data
  })
}
// 分页查询
export const findPage = (data) => {
  return axios({
    url: '/corpitem/findPage',
    method: 'post',
    data
  })
}

export const findAll = (data) => {
  return axios({
    url: '/item/findAll',
    method: 'post',
    data
  })
}
// 删除
export const batchDelete = data => {
  return axios({
    url: "/corpitem/delete",
    method: "post",
    data
  });
};

//供应商物料导出
export const GetExportGcList = data => {
  return axios({
    url: "/corpitem/GetExportGcList",
    method: "post",
    data
  });
};

//供应商物料导入
export const ImportGcList = data => {
  return axios({
    url: "/corpitem/ImportGcList",
    method: "post",
    data
  });
};
