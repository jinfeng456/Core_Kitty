import axios from '@/http/axios'
// 保存
export const save = (data) => {
    return axios({
        url: '/tasksQz/save',
        method: 'post',
        data
    })
}
// 删除
export const batchDelete = (data) => {
    return axios({
        url: '/tasksQz/delete',
        method: 'post',
        data
    })
}
// 分页查询
export const findPage = (data) => {
    return axios({
        url: '/tasksQz/findPage',
        method: 'post',
        data
    })
}

export const getAllList = () => {
    return axios({
        url: '/tasksQz/getAllList',
        method: 'post'
    })
}