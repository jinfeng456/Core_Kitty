import axios from '../../axios'

/* 
 * 用户管理模块
 */

// 保存
export const save = (data) => {
    return axios({
        url: '/user/save',
        method: 'post',
        data
    })
}
// 删除
export const batchDelete = (data) => {
    return axios({
        url: '/user/delete',
        method: 'post',
        data
    })
}
// 分页查询
export const findPage = (data) => {
    return axios({
        url: '/user/findPage',
        method: 'post',
        data
    })
}
// 查找用户的菜单权限标识集合
export const findPermissions = (params) => {
    return axios({
        url: '/user/findPermissions',
        method: 'get',
        params
    })
}
//修改用户密码
export const updateUserPassWord = (params) => {
    var url = '/user/updateUserPassWord/'+params.passWord+"/"+params.oldWord;
    return axios({
        url: url,
        method: 'get'
    })
}
//修改验收密码
export const updateCheckPassWord = (params) => {
    var url = '/user/updateCheckPassWord/'+params.passWord1+"/"+params.oldWord1;
    return axios({
        url: url,
        method: 'get'
    })
}

export const getUserByToken = params => {
    return axios({
        url: '/user/getInfoByToken',
        method: 'get',
        params
    })
}