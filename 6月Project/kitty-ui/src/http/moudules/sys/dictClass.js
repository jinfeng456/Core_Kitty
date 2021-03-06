import axios from '../../axios'

/* 
 * 字典分类管理模块
 */

// 保存
export const save = (data) => {
    return axios({
        url: '/dictClass/save',
        method: 'post',
        data
    })
}
// 删除
export const batchDelete = (data) => {
    return axios({
        url: '/dictClass/delete',
        method: 'post',
        data
    })
}
// 分页查询
export const findPage = (data) => {
    return axios({
        url: '/dictClass/findPage',
        method: 'post',
        data
    })
}

export const GetAllList = () => {
    return axios({
        url: '/dictClass/GetAllList',
        method: 'post'
    })
}