import axios from '@/http/axios'
// 保存
export const save = (data) => {
    return axios({
        url: '/coreItem/save',
        method: 'post',
        data
    })
}
// 删除
export const batchDelete = (data) => {
    return axios({
        url: '/coreItem/delete',
        method: 'post',
        data
    })
}
// 分页查询
export const findPage = (data) => {
    return axios({
        url: '/coreItem/findPage',
        method: 'post',
        data
    })
}

export const getAllList = () => {
    return axios({
        url: '/coreItem/getAllList',
        method: 'post'
    })
}