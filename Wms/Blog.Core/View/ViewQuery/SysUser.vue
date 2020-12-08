//-----------------------------------------代码开始--------------------------------------------------------
<template>
 <div class="container" >
	<!--工具栏-->
	<div class="toolbar" style="float:left;padding-top:10px;padding-left:15px;">
		<el-form :inline="true" :model="filters" :size="size">
			<el-form-item>
				<el-input v-model="filters.label" placeholder="名称"></el-input>
			</el-form-item>
			<el-form-item>
				<kt-button :label="$t('action.search')" perms="sys:sysUser:view" type="primary" @click="findPage(null)"/>
			</el-form-item>			
		</el-form>
	</div>
	<!--表格内容栏-->
	<kt-table2  
		:data="pageResult" :columns="columns" :showOperation="false" :showBatchDelete="false"
		@findPage="findPage" :pageRequest="this.pageRequest">
	</kt-table2>
  </div>
</template>

<script>
import KtTable2 from "@/views/Core/KtTable2"
import KtButton from "@/views/Core/KtButton"
import { format } from "@/utils/datetime"
export default {
	components:{
			KtTable2,
			KtButton
	},
	data(){
		return {
			size: 'small',
			filters:{
				label: ''
			},
			columns: [
				{ prop:"id", label: "", minWidth: 100},
				{ prop:"name", label: "", minWidth: 100},
				{ prop:"passwords", label: "", minWidth: 100},
				{ prop:"salt", label: "", minWidth: 100},
				{ prop:"email", label: "", minWidth: 100},
				{ prop:"mobile", label: "", minWidth: 100},
				{ prop:"userstatus", label: "", minWidth: 100},
				{ prop:"deptId", label: "", minWidth: 100},
				{ prop:"createBy", label: "", minWidth: 100},
				{ prop:"createTime", label: "", minWidth: 100},
				{ prop:"lastUpdateBy", label: "", minWidth: 100},
				{ prop:"lastUpdateTime", label: "", minWidth: 100},
				{ prop:"delFlag", label: "", minWidth: 100},
				{ prop:"code", label: "", minWidth: 100},
				{ prop:"auditPassword", label: "", minWidth: 100},
			],
			pageRequest: { pageNum: 1, pageSize: 8 },
			pageResult: { },			
			operation: false, // true:新增, false:编辑
			editDialogVisible: false, // 新增编辑界面是否显示
			editLoading: false,			
		}
	},
	methods: {
		// 获取分页数据
		findPage: function(data){
			if (data !== null){
				this.filters.pageNum=data.pageRequest.pageNum				
			}
			else{
				this.filters.pageNum=1
				this.pageRequest.pageNum=1
			}
			this.filters.pageSize=this.pageRequest.pageSize
			this.$api.sysUser.findPage(this.filters).then((res) => {
				this.pageResult = res.data
			}).then(data != null ? data.callback : '')
		},
	
		//国际化
		getKey: function (arg) {
			return this.$t(arg)
		},
		
		// 时间格式化
      	dateFormat: function(row, column, cellValue, index){
			return format(row[column.property])
		}
	},
	mounted(){
	}
}
</script>

<style scoped>

</style> 
//----------------------------------------代码结束------------------------------------------------------
