import axios from '../../axios'

/* 
 * 系统登录模块
 */

// 登录
export const login = data => {
    return axios({
        url: 'login',
        method: 'post',
        data
    })
}

// 登出
export const logout = () => {
    return axios({
        url: 'logout',
        method: 'get'
    })
}

export const indexData = () => {
    return axios({
        url: 'api/welcome/indexData',
        method: 'get'
    })
}

export const requestLogin = params => {
    return axios({
        url: '/api/login/jwttoken3.0',
        method: 'get',
        params
    })
}



