import axios from "../../../axios";

/* 
 * 用户管理模块
 */

// 保存
export const save = (data) => {
  return axios({
    url: '/classifyarea/save',
    method: 'post',
    data
  })
}
// 恢复
export const restore = (data) => {
  return axios({
    url: '/classifyarea/update',
    method: 'post',
    data
  })
}
// 分页查询
export const findPage = (data) => {
  return axios({
    url: '/classifyarea/findPage',
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
    url: "/classifyarea/delete",
    method: "post",
    data
  });
};
