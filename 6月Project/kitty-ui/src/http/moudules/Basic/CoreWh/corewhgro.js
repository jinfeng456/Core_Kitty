import axios from "../../../axios";

/* 
 * 用户管理模块
 */

// 保存
export const save = data => {
  return axios({
    url: "/supplier/save",
    method: "post",
    data
  });
};
// 设置物料
export const batchset = (data, itemId) => {
  return axios({
    url: "/supplier/Batchset/" + itemId,
    method: "post",
    data
  });
};
// 删除
export const batchDelete = data => {
  return axios({
    url: "/supplier/delete",
    method: "post",
    data
  });
};
// 分页查询
export const findPage = data => {
  return axios({
    url: "/supplier/findPage",
    method: "post",
    data
  });
};
// 查找用户的菜单权限标识集合
export const findPermissions = params => {
  return axios({
    url: "/supplier/findPermissions",
    method: "get",
    params
  });
};

//供应商导出
export const GetExportList = data => {
  return axios({
    url: "/supplier/GetExportList",
    method: "post",
    data
  });
};

//供应商导入
export const ImportList = data => {
  return axios({
    url: "/supplier/ImportList",
    method: "post",
    data
  });
};




