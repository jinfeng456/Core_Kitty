import axios from "../../../axios";




// 分页查询
// 分页查询
export const findReceiptInPage = (data) => {
  return axios({
    url: '/receiptIn/findPage',
    method: 'post',
    data
  })
}
// 分页查询
export const findItemPage = (data) => {
  return axios({
    url: '/receiptIn/findItemPage',
    method: 'post',
    data
  })
}
// 查找用户的菜单权限标识集合
// 分页查询
export const saveReceiptIn = (data) => {
  return axios({
    url: '/receiptIn/Save',
    method: 'post',
    data
  })
}
// 平库编辑
export const submitFlatIn = (params) => {
 
  var url = '/receiptIn/Submit/'+params.finshCount+"/"+params.areaId+"/"+params. reDetailId;
  return axios({
      url: url,
      method: 'get'
  })
 
}
// 查找用户的菜单权限标识集合
// 分页查询
export const getDetials = (data) => {
  return axios({
    url: '/receiptIn/getDetials',
    method: 'post',
    data
  })
}
export const updateDetials = (data) => {
  return axios({
    url: '/receiptIn/updateDetials',
    method: 'post',
    data
  })
}
export const saveDetials = (data) => {
  return axios({
    url: '/receiptIn/saveDetials',
    method: 'post',
    data
  })
}

export const saveDetialByOrder = (data) => {
  return axios({
    url: '/receiptIn/saveDetialByOrder',
    method: 'post',
    data
  })
}

export const deleteDetial = (data) => {
  return axios({
    url: '/receiptIn/deleteDetial',
    method: 'post',
    data
  })
}

export const batchDelete = (data) => {
  return axios({
    url: '/receiptIn/batchDelete',
    method: 'post',
    data
  })
}

//任务开始
export const begin = (data) => {
  return axios({
    url: '/receiptIn/begin',
    method: 'post',
    data
  })
}
//任务完成
export const finsh = (data) => {
  return axios({
    url: '/receiptIn/finsh',
    method: 'post',
    data
  })
}

//预览
export const Preview = (data) => {
  return axios({
      url: '/receiptIn/Preview',
      method: 'post',
      data
  })
}

//入库没给你写
export const FindReportPage = (data) => {
  return axios({
      url: '/receiptIn/FindReportPage',
      method: 'post',
      data
  })
}
//平库入库明细
export const FindFlatReportPage = (data) => {
  return axios({
      url: '/receiptIn/FindFlatReportPage',
      method: 'post',
      data
  })
}
//导出
export const GetExportList = (data) => {
  return axios({
      url: '/receiptIn/GetExportList',
      method: 'post',
      data
  })
}


