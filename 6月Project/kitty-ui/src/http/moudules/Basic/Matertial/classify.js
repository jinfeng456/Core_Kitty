import axios from "../../../axios";

/* 
 * 用户管理模块
 */

// 保存
export const save = data => {
  return axios({
    url: "/classify/save",
    method: "post",
    data
  });
};
// 删除
export const batchDelete = data => {
  return axios({
    url: "/classify/delete",
    method: "post",
    data
  });
};

// 批量设置库区
export const batchset = (data, areaId) => {
  return axios({
    url: "/classify/Batchset/" + areaId,
    method: "post",
    data
  });
};
// 分页查询
export const findPage = data => {
  return axios({
    url: "/classify/findPage",
    method: "post",
    data
  });
};
// 查找用户的菜单权限标识集合
export const findPermissions = params => {
  return axios({
    url: "/classify/findPermissions",
    method: "get",
    params
  });
};
