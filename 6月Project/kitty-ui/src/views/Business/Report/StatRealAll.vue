<template>
 <div class="container" >
	<!--工具栏-->
	<div class="toolbar" style="float:left;padding-top:10px;padding-left:15px;">
		<el-form :inline="true" :model="filters" :size="size">
			<el-form-item>
				<el-input v-model.trim="filters.itemName" placeholder="物料名称"></el-input>
			</el-form-item>
			<el-form-item>
				<el-input v-model.trim="filters.packageSpecs" placeholder="包装规格"></el-input>
			</el-form-item>
			<el-form-item>
			<el-date-picker type="datetime"
							v-model="filters.opTimeBegin "
							placeholder="开始时间"
							value-format="yyyy-MM-dd"
							format="yyyy-MM-dd"
							:style="{width: '175px'}">
			</el-date-picker>
			</el-form-item>
			<el-form-item>
			<el-date-picker type="datetime"
							v-model="filters.opTimeEnd "
							placeholder="结束时间"
							value-format="yyyy-MM-dd"
							format="yyyy-MM-dd"
							:style="{width: '175px'}">
			</el-date-picker>
			</el-form-item>
			<el-form-item>
				<kt-button :label="$t('action.search')" perms="report:statRealAll:view" type="primary" @click="findPage(null)"/>
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
		:data="pageResult" :columns="columns" :showOperation="false" :showBatchDelete="false" :pageRequest="this.pageRequest"
		@findPage="findPage" >
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
				label: ''
			},
			columns: [
				//{ prop: "id", label: "主键", minWidth: 100},
				{ prop: "month", label: "月份", minWidth: 100},
				//{ prop: "itemId", label: "物料主键", minWidth: 100},
				//{ prop: "batchId", label: "批次主键", minWidth: 100},
				{ prop: "wmsBanchNo", label: "内部批次号", minWidth: 120},
				//{ prop: "forword", label: "单据类型", minWidth: 100},
				//{ prop: "count", label: "数量", minWidth: 100},
				{ prop: "inCount", label: "收入", minWidth: 100},
				{ prop: "outCount", label: "发出", minWidth: 100},
				{ prop: "remain", label: "结存", minWidth: 100},
				{ prop: "sourceWhither", label: "来源/去向", minWidth: 100},
				{ prop: "unit", label: "单位", minWidth: 100},
				//{ prop: "receiptDetailId", label: "明细主键", minWidth: 100},
				{ prop: "itemName", label: "物料名称", minWidth: 100},
				{ prop: "itemCode", label: "物料编码", minWidth: 100},
				{ prop: "modelSpecs", label: "规格", minWidth: 100},
				{ prop: "packageSpecs", label: "包装规格", minWidth: 100},				
				{ prop: "opTime", label: "时间", minWidth: 120, formatter:this.dateFormat},
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
			if(data!==null){
				this.filters.pageNum=data.pageRequest.pageNum		
			}else{
				this.filters.pageNum=1
			}
			this.filters.pageSize=this.pageRequest.pageSize
			this.$api.statReal.findPageAll(this.filters).then((res) => {
				this.pageResult = res.data
			}).then(data != null ? data.callback : '')
		},
		 //导出的方法
		exportExcel() {
			this.filters.pageSize=-1
			require.ensure([], () => {		
					this.$api.statReal.findPageAll(this.filters).then((res) => {						
					const tHeader = ['物料编码','物料名称','规格','包装规格','单位','月份','数量','内部批次号', '单据类型','结存', '操作时间'];
					const filterVal = ["itemCode","itemName","modelSpecs","packageSpecs","unit",'month','count', 'wmsBanchNo','forword','remain',"opTime"];				
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
	}
}
</script>

<style scoped>

</style> 

	