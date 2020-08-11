import axios from "../../axios";

/* 
 * 条码查询
 */
// 分页查询
export const findPage = data => {
  return axios({
    url: "/CoreCodeInfo/FindPage",
    method: "post",
    data
  });
};
// 查找用户的菜单权限标识集合
// 分页查询
export const UpdateBarCode = (data) => {
  return axios({
      url: '/CoreCodeInfo/UpdateBarCode',
      method: 'post',
      data
  })
}

// 查找用户的菜单权限标识集合
// 分页查询
export const UpdateUpLoadStatus = (data) => {
  return axios({
      url: '/CoreCodeInfo/UpdateUpLoadStatus',
      method: 'post',
      data
  })
}
