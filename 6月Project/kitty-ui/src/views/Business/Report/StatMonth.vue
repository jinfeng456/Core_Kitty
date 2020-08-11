<template>
 <div class="container" >
	<!--工具栏-->
	<div class="toolbar" style="float:left;padding-top:10px;padding-left:15px;">
		<el-form :inline="true" :model="filters" :size="size">
			<el-form-item>
				<el-input v-model.trim="filters.itemName" placeholder="物料名称"></el-input>
			</el-form-item>
			<el-form-item>
				<el-input v-model.trim="filters.modelSpecs" placeholder="规格"></el-input>
			</el-form-item>
			<el-form-item>
				<kt-button :label="$t('action.search')" perms="sys:statMonth:view" type="primary" @click="findPage(null)"/>
			</el-form-item>			
		</el-form>
	</div>
	<div class="toolbar" style="float:right;padding-top:0px;padding-right:0px;">
		<el-form :inline="true" :size="size">
			<el-form-item>
				<el-button-group>	
					<el-tooltip content="导出Excel" placement="top">
						<el-button icon="fa fa-file-excel-o" @click="exportExcel" /> 
					</el-tooltip>
				</el-button-group>
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
import { export_json_to_excel } from "@/excel/Export2Excel"

export default {
	components:{
			KtTable2,
			KtButton
	},
	data(){
		return {
			size: 'small',
			filters:{
				coreItemType:parseInt(this.$route.path.substr(this.$route.path.lastIndexOf('/')+1)),
			},
			columns: [
				//{ prop: "id", label: "主键", minWidth: 100},
				{ prop: "month", label: "月份", minWidth: 100},
				//{ prop: "itemId", label: "物料主键", minWidth: 100},
				{ prop: "itemName", label: "物料名称", minWidth: 100},
				{ prop: "itemCode", label: "物料编码", minWidth: 100},
				{ prop: "modelSpecs", label: "规格", minWidth: 100},
				{ prop: "unit", label: "单位", minWidth: 100},
				{ prop: "lastRemain", label: "期初数量", minWidth: 100},
				{ prop: "outCount", label: "出库数量", minWidth: 100},
				{ prop: "inCount", label: "入库数量", minWidth: 100},
				{ prop: "remain", label: "结存数量", minWidth: 100},
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
			}
			this.filters.pageSize=data.pageRequest.pageSize
			this.$api.statMonth.findPage(this.filters).then((res) => {
				this.pageResult = res.data
			}).then(data != null ? data.callback : '')
		},
		//导出的方法
		exportExcel() {
			this.filters.pageSize=-1
			require.ensure([], () => {		
					this.$api.statMonth.findPage(this.filters).then((res) => {						
					const tHeader = ['物料编码','物料名称','规格','单位','月份','期初数量', '入库数量','出库数量', '结存数量'];
					const filterVal = ["itemCode","itemName","modelSpecs","unit",'month','lastRemain', 'inCount','outCount','remain'];				
					const list =  res.data.content;  
					const data = this.formatJson(filterVal, list);
					export_json_to_excel(tHeader, data, '物料总账报表导出');
					})
				})
		},
		formatJson(filterVal, tableData) {
			return tableData.map(v => {
				return filterVal.map(j => {
						return v[j]
					})
				}
			)
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
	},
  	watch:{
		$route(to,from){
			console.log(to.path);
			this.filters.coreItemType=parseInt(to.path.substr(to.path.lastIndexOf('/')+1))
			this.findPage({pageRequest:{pageNum:1,pageSize:7}});
		}
  	}
}
</script>

<style scoped>

</style> 

	