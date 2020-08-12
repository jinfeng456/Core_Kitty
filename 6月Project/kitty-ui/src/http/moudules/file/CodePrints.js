import axios from '../../axios'

/* 
 * 导出文档
 */

// 保存
export const code = (data) => {
    debugger
    return axios({
        url: data.baseUrl+'/Print/code',
        method: 'post',
        data:data.dataArr
    })
}

