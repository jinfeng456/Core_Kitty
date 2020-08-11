import axios from "../../../axios";

/* 
 * 用户管理模块
 */

// 保存
export const save = data => {
  return axios({
    url: "/corewhloc/save",
    method: "post",
    data
  });
};
//批量修改
export const batchedit = (data, areaId) => {
  return axios({
    url: "/corewhloc/BatchEdit/" + areaId,
    method: "post",
    data
  });
};
// 删除
// export const batchDelete = data => {
//   return axios({
//     url: "/corewhloc/delete",
//     method: "post",
//     data
//   });
// };
// 分页查询
export const findPage = data => {
  return axios({
    url: "/corewhloc/findPage",
    method: "post",
    data
  });
};
// 查找用户的菜单权限标识集合
export const findPermissions = params => {
  return axios({
    url: "/corewhloc/findPermissions",
    method: "get",
    params
  });
};
