import axios from "../../../axios";




// 分页查询
export const findReceiptOutPage = (data) => {
    return axios({
        url: '/receiptOut/findPage',
        method: 'post',
        data
    })
}



// 分页明细查询
export const findDetailPage = (data) => {
    return axios({
        url: '/receiptOut/findDetailPage',
        method: 'post',
        data
    })
}
// 查找用户的菜单权限标识集合
// 分页查询
export const saveReceiptOut = (data) => {
    return axios({
        url: '/receiptOut/Save',
        method: 'post',
        data
    })
}
// 查找用户的菜单权限标识集合
// 分页查询
export const getDetials = (data) => {
    return axios({
        url: '/receiptOut/getDetials',
        method: 'post',
        data
    })
}
export const updateDetials = (data) => {
    return axios({
        url: '/receiptOut/updateDetials',
        method: 'post',
        data
    })
}
export const saveDetials = (data) => {
    return axios({
        url: '/receiptOut/saveDetials',
        method: 'post',
        data
    })
}

export const saveDetialByOrder = (data) => {
    return axios({
        url: '/receiptOut/saveDetialByOrder',
        method: 'post',
        data
    })
}

export const deleteDetial = (data) => {
    return axios({
        url: '/receiptOut/deleteDetial',
        method: 'post',
        data
    })
}

export const batchDelete = (data) => {
    return axios({
        url: '/receiptOut/batchDelete',
        method: 'post',
        data
    })
}


export const saveDetialsByBatch = (data) => {
    return axios({
        url: '/receiptOut/saveDetialsByBatch',
        method: 'post',
        data
    })
}



export const saveDetialByProduce = (data) => {
    return axios({
        url: '/receiptOut/saveDetialByProduce',
        method: 'post',
        data
    })
}



export const checkoutGenerate = (data) => {
    return axios({
        url: '/receiptOut/checkoutGenerate',
        method: 'post',
        data
    })
}

export const otheroutGenerate = (data) => {
    return axios({
        url: '/receiptOut/otheroutGenerate',
        method: 'post',
        data
    })
}

export const batchoutGenerate = (data) => {
    return axios({
        url: '/receiptOut/batchoutGenerate',
        method: 'post',
        data
    })
}


//预览
export const Preview = (data) => {
    return axios({
        url: '/receiptOut/Preview',
        method: 'post',
        data
    })
}

//出库明细
export const FindReportPage = (data) => {
    return axios({
        url: '/receiptOut/FindReportPage',
        method: 'post',
        data
    })
}
//导出
export const GetExportList = (data) => {
    return axios({
        url: '/receiptOut/GetExportList',
        method: 'post',
        data
    })
  }

