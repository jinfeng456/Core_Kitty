import axios from '@/http/axios'
// 分页查询
export const findPage = (data) => {
    return axios({
        url: '/statReal/findPage',
        method: 'post',
        data
    })
}

// 分页查询
export const findPageAll = (data) => {
    return axios({
        url: '/statReal/findPageAll',
        method: 'post',
        data
    })
}


	