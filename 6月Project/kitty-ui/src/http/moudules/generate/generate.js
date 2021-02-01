import axios from '../../axios'

/* 
 * 角色管理模块
 */

// 保存
export const generate = (data,params,templete) => {
    return axios({
        url: '/api/DbFirst/GetAllFrameFilesByTableNames?ConnID='+params+"&templete="+templete,
        method: 'post',
        data
    })
}

//获取当前数据库
export const getDatabase = () => {
    return axios({
        url: '/api/DbFirst/getDatabase',
        method: 'post' 
    })
}

//获取所有表
export const getTableNames = () => {
    return axios({
        url: '/api/DbFirst/getTableNames',
        method: 'get' 
    })
}