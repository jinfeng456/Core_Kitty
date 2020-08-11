import axios from '../../../axios'

/*
 * 订单管理模块
 */
// 分页查询
export const findPage = (data) => {
    return axios({
        url: '/whSoOut/findPage',
        method: 'post',
        data
    })
}

export const GetSoOutReceptList = (data) => {
    return axios({
        url: '/whSoOut/GetSoOutReceptList',
        method: 'post',
        data
    })
}


