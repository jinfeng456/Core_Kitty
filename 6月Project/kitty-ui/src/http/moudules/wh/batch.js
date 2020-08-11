import axios from '../../axios'

/* 
 * 字典分类管理模块
 */

// 保存
export const save = (data) => {
    return axios({
        url: '/batch/save',
        method: 'post',
        data
    })
}
// 平库出库
export const FlatOut = (data) => {

   
    return axios({
        url: '/batch/FlatOut',
        method: 'post',
        data
    })
}
// 删除
export const batchDelete = (data) => {
    return axios({
        url: '/batch/delete',
        method: 'post',
        data
    })
}
// 分页查询
export const findPage = (data) => {  
    return axios({
        url: '/batch/findPage',
        method: 'post',
        data
    })
}

// 同步批次
export const synchronization = (data) => {
    return axios({
        url: '/batch/synchronization',
        method: 'post',
        data
    })
}

//批次查询报表
export const FindBatchReport = (data) => {
    return axios({
        url: '/batch/FindBatchReport',
        method: 'post',
        data
    })
}

export const UpdatePriority = (data) => {
    return axios({
        url: '/batch/UpdatePriority',
        method: 'post',
        data
    })
}