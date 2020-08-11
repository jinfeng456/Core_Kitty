import axios from '../../axios'

/* 
 * 导出文档
 */

// 保存
export const exports = (data) => {
    return axios({
        url: '/api/file/exports',
        method: 'post',
        data
    })
}

