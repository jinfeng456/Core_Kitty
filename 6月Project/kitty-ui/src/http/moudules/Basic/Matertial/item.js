import axios from "../../../axios";

/* 
 * 物料信息
 */

// 保存
export const save = (data) => {
  return axios({
    url: '/item/save',
    method: 'post',
    data
  })
}
// 恢复
export const restore = (data) => {
  return axios({
    url: '/item/restore',
    method: 'post',
    data
  })
}
// 禁用
export const disable = (data) => {
  return axios({
    url: '/item/disable',
    method: 'post',
    data
  })
}
// 分页查询
export const findPage = (data) => {
  return axios({
    url: '/item/findPage',
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
    url: "/item/delete",
    method: "post",
    data
  });
}

export const GetExportList = (data) => {
  return axios({
    url: '/item/GetExportList',
    method: 'post',
    data
  })
}

export const ImportList = (data) => {
  return axios({
    url: '/item/ImportList',
    method: 'post',
    data
  })
}


