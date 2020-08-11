import axios from "../../../axios";

/*
 * 用户管理模块
 */

// 保存
export const save = data => {
  return axios({
    url: "/produce/save",
    method: "post",
    data
  });
};
// 分页查询
export const findPage = data => {
  return axios({
    url: "/produce/findPage",
    method: "post",
    data
  });
};
// 明细查询
export const findDetailsPage = data => {
  return axios({
    url: "/produce/GetOrderDetailId",
    method: "post",
    data
  });
};
//同步
export const synchronize = data => {
  return axios({
    url: "/produce/synchronize",
    //url: "/uapws/rest/NCWMSRestResource/NCWMService",
    //baseURL: "http://112.93.131.129:9080",
    method: "post",
    data
  });
};
// 查找用户的菜单权限标识集合
export const findPermissions = params => {
  return axios({
    url: "/produce/findPermissions",
    method: "get",
    params
  });
};

export const saveProduce = (data) => {
  return axios({
    url: '/produce/saveProduce',
    method: 'post',
    data
  })
}
export const getDetials = (data) => {
  return axios({
    url: '/produce/getDetials',
    method: 'post',
    data
  })
}

export const saveDetials = (data) => {
  return axios({
    url: '/produce/saveDetials',
    method: 'post',
    data
  })
}

export const updateDetials = (data) => {
  return axios({
    url: '/produce/updateDetials',
    method: 'post',
    data
  })
}

export const deleteDetial = (data) => {
  return axios({
    url: '/produce/deleteDetial',
    method: 'post',
    data
  })
}
