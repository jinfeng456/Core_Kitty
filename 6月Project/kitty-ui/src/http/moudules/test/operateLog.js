import axios from '@/http/axios'
// 保存
export const save = (data) => {
    return axios({
        url: '/operateLog/save',
        method: 'post',
        data
    })
}
// 删除
export const batchDelete = (data) => {
    return axios({
        url: '/operateLog/delete',
        method: 'post',
        data
    })
}
// 分页查询
export const findPage = (data) => {
    return axios({
        url: '/operateLog/findPage',
        method: 'post',
        data
    })
}

export const getAllList = () => {
    return axios({
        url: '/operateLog/getAllList',
        method: 'post'
    })
}