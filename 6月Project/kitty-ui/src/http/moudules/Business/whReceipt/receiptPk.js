import axios from "../../../axios";

/* 
 * 盘点管理模块
 */

// 保存
export const save = (data) => {
    return axios({
        url: '/whReceiptPk/save',
        method: 'post',
        data
    })
}
// 删除
export const batchDelete = (data) => {
    return axios({
        url: '/whReceiptPk/delete',
        method: 'post',
        data
    })
}
// 分页查询
export const findPage = (data) => {
    return axios({
        url: '/whReceiptPk/findPage',
        method: 'post',
        data
    })
}

//生成单据
export const Generate = (data) => {
    return axios({
        url: '/whReceiptPk/Generate',
        method: 'post',
        data
    })
}