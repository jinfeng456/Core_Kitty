<template>
  <div class="container" >
	<!--工具栏-->
	<div class="toolbar" style="float:left;padding-top:10px;padding-left:15px;">
		<el-form :inline="true" :model="filters" :size="size">
			<!-- <el-form-item>
				<el-input v-model.trim="filters.wmsBanchNo" placeholder="内部批次号"></el-input>
			</el-form-item> -->
			<!-- <el-form-item>
				<kt-button :label="$t('action.search')" perms="sys:dictClass:view" type="primary" @click="findPage(null)"/>
			</el-form-item>		 -->
		</el-form>
	</div>
	<!--表格内容栏-->
	<kt-table2 :height="388" 
		:data="pageResult" :columns="columns" :showOperation="false" 
		@findPage="findPage" >
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
	data() {
		return {
			size: 'small',
			filters: {
				wmsBanchNo: '',
				isWarning:true
			},
			Items: [],
			columns: [
				{prop:"title", label:"标题", minWidth:100,formatter:this.itemFilter},
                {prop:"info", label:"内容", minWidth:100},
                //{prop:"noOutTime", label:"日期", minWidth:100},
			],
			pageResult: {},

			operation: false, // true:新增, false:编辑
			editDialogVisible: false, // 新增编辑界面是否显示
			editLoading: false,					
		}
	},
	
	methods: {
		// 获取分页数据
		findPage: function (data) {
			// if(data !== null) {
			// 	this.filters.pageNum=data.pageRequest.pageNum
			// 	this.filters.pageSize=data.pageRequest.pageSize
			// }    
			this.$api.login.indexData().then((res) => {
				this.pageResult = {content:res.data}
			}).then(data!=null?data.callback:'')
		},
		//加载物料
		findItems: function () {
			this.$api.item.findAll().then((res) => {
				this.Items = res.data			
			})
		},
		//物料名称
		itemFilter:  function (row, column, cellValue, index){
				let key = ""
				let propt = column.property;
				let val = row[column.property];				
				let dict = this.Items;
				for (let i = 0; i < dict.length; i++) {
					if (dict[i].id == val) {
					return dict[i].name;
					}
				}
				return row[column.property]
      	},		
		//国际化
		getKey: function (arg) {
			return this.$t(arg)
		},
		// 时间格式化
      	dateFormat: function (row, column, cellValue, index){
          	return format(row[column.property])
      	}
	},
	created() {
		//this.findItems();
		this.$api.login.indexData().then((res) => {
				this.pageResult = {content:res.data}
      		}).then(data!=null?data.callback:'') 
	}
}
</script>

<style scoped>

</style>