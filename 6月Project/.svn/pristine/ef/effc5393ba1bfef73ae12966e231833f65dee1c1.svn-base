import axios from "../../../axios";

/*
 * 用户管理模块
 */

// 保存
export const save = data => {
  return axios({
    url: "/sales/save",
    method: "post",
    data
  });
};
// 分页查询
export const findPage = data => {
  return axios({
    url: "/sales/findPage",
    method: "post",
    data
  });
};
// 明细查询
export const findDetailsPage = data => {
  return axios({
    url: "/sales/GetOrderDetailId",
    method: "post",
    data
  });
};
//同步
export const synchronize = data => {
  return axios({
    url: "/sales/synchronize",
    //url: "/uapws/rest/NCWMSRestResource/NCWMService",
    //baseURL: "http://112.93.131.129:9080",
    method: "post",
    data
  });
};
// 查找用户的菜单权限标识集合
export const findPermissions = params => {
  return axios({
    url: "/sales/findPermissions",
    method: "get",
    params
  });
};
export const saveWhSoOut = (data) => {
  return axios({
    url: '/sales/saveWhSoOut',
    method: 'post',
    data
  })
}
export const saveDetials = (data) => {
  return axios({
    url: '/sales/saveDetials',
    method: 'post',
    data
  })
}
export const getDetials = (data) => {
  return axios({
    url: '/sales/getDetials',
    method: 'post',
    data
  })
}
export const updateDetials = (data) => {
  return axios({
    url: '/sales/updateDetials',
    method: 'post',
    data
  })
}

export const deleteDetial = (data) => {
  return axios({
    url: '/sales/deleteDetial',
    method: 'post',
    data
  })
}
