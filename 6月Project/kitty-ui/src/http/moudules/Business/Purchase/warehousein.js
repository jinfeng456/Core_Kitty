import axios from "../../../axios";

/* 
 * 用户管理模块
 */

// 保存
export const save = data => {
  return axios({
    url: "/warehousein/save",
    method: "post",
    data
  });
};
// 分页查询
export const findPage = data => {
  return axios({
    url: "/warehousein/findPage",
    method: "post",
    data
  });
};
// 明细查询
export const findDetailsPage = data => {
  return axios({
    url: "/warehousein/GetOrderDetailId",
    method: "post",
    data
  });
};
//同步
export const synchronize = data => {
  return axios({
    url: "/warehousein/synchronize",
    //url: "/uapws/rest/NCWMSRestResource/NCWMService",
    //baseURL: "http://112.93.131.129:9080",
    method: "post",
    data
  });
};
// 查找用户的菜单权限标识集合
export const findPermissions = params => {
  return axios({
    url: "/warehousein/findPermissions",
    method: "get",
    params
  });
};
