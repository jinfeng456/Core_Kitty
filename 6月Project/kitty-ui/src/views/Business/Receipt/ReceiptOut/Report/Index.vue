<template>
  <div class="page-container">
	<!--工具栏-->
	<div class="toolbar" style="float:left;padding-top:10px;padding-left:15px;">
		<el-form :inline="true" :model="filters" :size="size">
			<el-form-item>
					<el-input v-model="filters.receiptNo" :placeholder="$t('field.receipt.receiptNo')" :style="{width: '175px'}"></el-input>
			</el-form-item>	
			<el-form-item>
					<el-select v-model="filters.status"  style="width: 175px;" clearable :placeholder="$t('field.receipt.status')">
						<el-option v-for="item in dicts.status" :key="item.value"
							:label="item.label" :value="item.value" >
						</el-option>
					</el-select>
			</el-form-item>	
			<el-form-item>
					<el-select v-model="filters.stn"  style="width: 175px;" clearable :placeholder="$t('field.receipt.stn')">
						<el-option v-for="item in dicts.stnOut" :key="item.value"
							:label="item.label" :value="item.value" >
						</el-option>
					</el-select>
			</el-form-item>			
			<el-form-item>
					<el-select v-model="filters.outType"  style="width: 175px;" clearable :placeholder="$t('field.receipt.outType')" >
						<el-option v-for="item in dicts.outTypeItem" :key="item.value"
							:label="item.label" :value="item.value" >
						</el-option>
					</el-select>
			</el-form-item>		
		</el-form>
	</div>
	<div class="toolbar" style="float:left;padding-top:0px;padding-left:15px;">
		<el-form :inline="true" :model="filters" :size="size">	
		<el-form-item>
          <el-date-picker type="datetime"
                          v-model="filters.createBeginTime "
                          placeholder="创建开始时间"
                          value-format="yyyy-MM-dd"
                          format="yyyy-MM-dd"
                          :style="{width: '175px'}">
          </el-date-picker>
        </el-form-item>
        <el-form-item>
          <el-date-picker type="datetime"
                          v-model="filters.createEndTime "
                          placeholder="创建结束时间"
                          value-format="yyyy-MM-dd"
                          format="yyyy-MM-dd"
                          :style="{width: '175px'}">
          </el-date-picker>
        </el-form-item>	
		<el-form-item>
          <el-date-picker type="datetime"
                          v-model="filters.finishBeginTime "
                          placeholder="完成开始时间"
                          value-format="yyyy-MM-dd"
                          format="yyyy-MM-dd"
                          :style="{width: '175px'}">
          </el-date-picker>
        </el-form-item>
        <el-form-item>
          <el-date-picker type="datetime"
                          v-model="filters.finishEndTime "
                          placeholder="完成结束时间"
                          value-format="yyyy-MM-dd"
                          format="yyyy-MM-dd"
                          :style="{width: '175px'}">
          </el-date-picker>
        </el-form-item>
			<el-form-item>
				<kt-button icon="fa fa-search" :label="$t('action.search')" perms="core:CheckOut:view" type="primary" @click="findPage(null)"/>
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
		<!--表格显示列界面-->
		<table-column-filter-dialog ref="tableColumnFilterDialog" :columns="columns" 
			@handleFilterColumns="handleFilterColumns"> 
		</table-column-filter-dialog>
	</div>
	<!--表格内容栏-->
	<kt-table2  :myButtons="myButtons" :data="pageResult" :columns="filterColumns" :showBatchDelete="false" :showOperation="false" :pageRequest="this.pageRequest"
		@findPage="findPage" >
	</kt-table2>

  </div>

</template>

<script>
import PopupTreeInput from "@/components/PopupTreeInput"
import KtTable2 from "@/views/Core/KtTable2"
import KtButton from "@/views/Core/KtButton"
import TableColumnFilterDialog from "@/views/Core/TableColumnFilterDialog"
import { format } from "@/utils/datetime"
import { getLodop } from "@/utils/LodopFuncs"
import { printSelected } from "@/utils/print"
import { baseUrl } from '@/utils/global'
import { printMoudle } from "@/utils/print"
import { export_json_to_excel } from "@/excel/Export2Excel"

export default {
	components:{
		PopupTreeInput,
		KtTable2,
		KtButton,
		TableColumnFilterDialog,
	},
	data() {
		return {
			size: 'small',
			filters: {
				batchNo: ''				
			},
			uploadData:{

			},
			innerHtml:'',
			componentKey: 0,
			baseUrl:baseUrl,
			columns: [],
			dicts:this.$store.state.dict.dicts,
			filterColumns: [],
			pageRequest: { pageNum: 1, pageSize: 8 },
			pageResult: {},
			myButtons:[{
				name:"handleEdit",
				perms:"core:receiptout:edit",
				label:"action.edit",
				icon:"fa fa-edit"
			},{
				name:"handleDelete",
				perms:"core:receiptout:delete",
				label:"action.delete",
				type:"danger",
				icon:"fa fa-trash"
			}],
			operation: false, // true:新增, false:编辑
			dialogVisible1: false, // 新增编辑界面是否显示
			editLoading: false,
			stockInList:[],		
			deptData: [],
			deptTreeProps: {
				label: 'name',
				children: 'children'
			},
			roles: []
			
		}
	},
	computed: {
		
	},	
	methods: {
		// 获取分页数据
		findPage: function (data) {		
			if(data!==null){
				this.filters.pageNum=data.pageRequest.pageNum		
			}else{
				this.filters.pageNum=1
			}
			this.filters.pageSize=this.pageRequest.pageSize
			this.$api.receipt.FindReportPage(this.filters).then((res) => {
				this.pageResult = res.data			
			}).then(data!=null?data.callback:'')
		},
		 //导出的方法
		exportExcel() {
			debugger
			this.filters.pageSize=-1
			require.ensure([], () => {						
					this.$api.receipt.FindReportPage(this.filters).then((res) => {		//GetExportList
					debugger				
					const tHeader = ['单号', '内部批次号', '物料名称', '创建时间', '完成时间'];
					const filterVal = ['receiptNo', 'batchNo', 'itemName', 'beginTime', 'finishTime'];				
					const list =  res.data.content;  
					const data = this.formatJson(filterVal, list);
					export_json_to_excel(tHeader, data, '出库单导出');
					})
				})
			//this.filters.pageSize=7
			},
		// 批量删除
		handleDelete: function (data) {
			this.$api.receipt.batchDelete(data.params).then(data!=null?data.callback:'')
		},
		formatJson(filterVal, tableData) {
			return tableData.map(v => {
				return filterVal.map(j => {
						return v[j]
					})
				}
			)
		},
	
		// 时间格式化
      	dateFormat: function (row, column, cellValue, index){
          	return format(row[column.property])
      	},
		
		selectionFormat: function (row, column, cellValue, index){
			let key=""
			let propt=column.property;
			if(propt=="stn"){
				key="stnOut"
			}else if(propt=="outType"){
				key="outTypeItem"
			}else if(propt=="priority"){
				key="priority"
			}else if(propt=="pickType"){
				key="pickType"
			}else if(propt=="status"){
				key="status"
			}
	
		    let val=row[column.property];
			let dict =this.$store.state.dict.dicts[key];
			if(dict==undefined){
					return row[column.property]
			}
			for(let i=0;i<dict.length;i++){
				if(dict[i].value==val){
					return dict[i].label;
				}
			}

          	return row[column.property]
      	},
		// 处理表格列过滤显示
      	displayFilterColumnsDialog: function () {
			this.$refs.tableColumnFilterDialog.setDialogVisible(true)
      	},
		// 处理表格列过滤显示
      	handleFilterColumns: function (data) {
			this.filterColumns = data.filterColumns
			this.$refs.tableColumnFilterDialog.setDialogVisible(false)
      	}	
	},
	created (){
	

	},
	mounted() {
	this.columns = [
				{prop:"receiptNo", label:"field.receipt.receiptNo", minWidth:130}, 
				//{prop:"srcSoNo", label:"field.receipt.srcSoNo", minWidth:100},
				{prop:"batchNo", label:"内部批号", minWidth:100},
				{prop:"itemName", label:"物料名称", minWidth:100},
				{prop:"status", label:"状态", minWidth:100 , formatter:this.selectionFormat},				
				{prop:"stn", label:"field.stn", minWidth:100 , formatter:this.selectionFormat},
				//{prop:"outType", label:"field.receipt.outType", minWidth:95, formatter:this.selectionFormat},
				{prop:"priority", label:"field.receipt.priority", minWidth:70 , minWidth:120, formatter:this.selectionFormat},
				{prop:"pickType", label:"分拣类型", minWidth:95, formatter:this.selectionFormat},
				{prop:"beginTime", label:"beginTime", minWidth:140, formatter:this.dateFormat},
				{prop:"finshTime", label:"finshTime", minWidth:140, formatter:this.dateFormat}
			]
			this.filterColumns = this.columns;
	} 	
}
</script>

<style scoped>

</style>