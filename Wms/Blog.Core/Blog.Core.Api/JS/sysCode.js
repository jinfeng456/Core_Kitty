
//-----------------------------------------------代码开始-----------------------------------------------------------
import axios from '@/http/axios'

// 保存
export const save = (data) => {
    return axios({
        url: '/sysCode/save',
        method: 'post',
        data
    })
}
// 删除
export const batchDelete = (data) => {
    return axios({
        url: '/sysCode/delete',
        method: 'post',
        data
    })
}
// 分页查询
export const findPage = (data) => {
    return axios({
        url: '/sysCode/findPage',
        method: 'post',
        data
    })
}

export const getAllList = () => {
    return axios({
        url: '/sysCode/getAllList',
        method: 'post'
    })
}

//-----------------------------------------------代码结束-----------------------------------------------------------
