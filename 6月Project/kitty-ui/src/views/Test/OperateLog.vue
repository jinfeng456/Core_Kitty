<template>
<div class="container" >
	<!--工具栏-->
	<div class="toolbar" style="float:left;padding-top:10px;padding-left:15px;">
		<el-form :inline="true" :model="filters" :size="size">
			<el-form-item>
				<el-input v-model="filters.area" placeholder="区域名称"></el-input>
			</el-form-item>
			<el-form-item>
				<kt-button :label="$t('action.search')" perms="sys:operateLog:view" type="primary" @click="findPage(null)"/>
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
				area: ''
			},
			columns: [
				{ prop: "id", label: "主键", minWidth: 100},
				{ prop: "isDeleted", label: "是否删除", minWidth: 100},
				{ prop: "area", label: "区域名", minWidth: 100},
				{ prop: "controller", label: "区域控制器名", minWidth: 120},
				{ prop: "action", label: "Action名称", minWidth: 110},
				{ prop: "ipAddress", label: "IP地址", minWidth: 100},
				{ prop: "description", label: "描述", minWidth: 100},
				{ prop: "logTime", label: "登录时间", minWidth: 130,formatter:this.dateFormat},
				{ prop: "loginName", label: "登录名称", minWidth: 100},
				{ prop: "userId", label: "用户ID", minWidth: 100},
				
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
			this.$api.operateLog.findPage(this.filters).then((res) => {
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



