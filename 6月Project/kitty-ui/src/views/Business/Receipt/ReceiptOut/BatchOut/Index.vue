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
					<el-select v-model="filters.outType"  style="width: 175px;" clearable :placeholder="$t('field.receipt.outType')" disabled="false">
						<el-option v-for="item in dicts.outTypeBatch" :key="item.value"
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
                          value-format="yyyy-MM-dd "
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
			<el-form-item> 
				<kt-button icon="fa fa-plus" :label="$t('action.add')" perms="core:CheckOut:add" type="primary" @click="handleAdd" />
			</el-form-item>
		</el-form>
	</div>
	<div class="toolbar" style="float:right;padding-top:0px;padding-right:15px;">
		<el-form :inline="true" :size="size">
			<el-form-item>
				<el-button-group>
					<el-tooltip :content="$t('action.refresh')" placement="top">
						<el-button icon="fa fa-refresh" @click="findPage(null)"></el-button>
					</el-tooltip>
					<el-tooltip :content="$t('action.column')" placement="top">
						<el-button icon="fa fa-filter" @click="displayFilterColumnsDialog"></el-button>
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
	<kt-table2  permsDelete="core:CheckOut:delete" :myButtons="myButtons" :data="pageResult" :columns="filterColumns"
		@findPage="findPage" @handleEdit="handleEdit" @handleExport="handleExport" @handleDelete="handleDelete" @handleGenerate="handleGenerate" :showGenerate="true"  permsGenerate="core:whCheckout:generate" permsExport="core:whCheckout:export" :pageRequest="this.pageRequest">
	</kt-table2>
	<edit-receipt-out :key="componentKey" :subDataForm="dataForm" :dialogVisible="dialogVisible1" :operation="operation"  @receiptHidden="receiptHidden" :outType="this.filters.outType"></edit-receipt-out>

  </div>

</template>

<script>
import PopupTreeInput from "@/components/PopupTreeInput"
import KtTable2 from "@/views/Core/KtTable2"
import KtButton from "@/views/Core/KtButton"
import TableColumnFilterDialog from "@/views/Core/TableColumnFilterDialog"
import { format } from "@/utils/datetime"
import EditReceiptOut from "./EditReceiptOut"
import { baseUrl } from '@/utils/global'

export default {
	components:{
		PopupTreeInput,
		KtTable2,
		KtButton,
		TableColumnFilterDialog,
		EditReceiptOut
	},
	data() {
		return {
			size: 'small',
			filters: {
				batchNo: '',
        		outType:parseInt(this.$route.path.substr(this.$route.path.lastIndexOf('/')+1)),
				outTypeClass:3
			},
			componentKey: 0,
			columns: [],
			filterColumns: [],
			pageRequest: { pageNum: 1, pageSize: 7 },
			pageResult: {},
			baseUrl:baseUrl,
			myButtons:[{
				name:"handleEdit",
				perms:"core:CheckOut:edit",
				label:"action.edit",
				icon:"fa fa-edit"
			},{
				name:"handleDelete",
				perms:"core:CheckOut:delete",
				label:"action.delete",
				type:"danger",
				icon:"fa fa-trash"
			}],
			dicts:this.$store.state.dict.dicts,
			operation: false, // true:新增, false:编辑
			dialogVisible1: false, // 新增编辑界面是否显示
			editLoading: false,

			// 新增编辑界面数据
			dataForm: {
				id: 0,
				outTypeClass:3,
				outType:parseInt(this.$route.path.substr(this.$route.path.lastIndexOf('/')+1))
			},
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
		receiptHidden:function(){
			
			this.dialogVisible1=false;
			this.findPage(null);
		},
		// 获取分页数据
		findPage: function (data) {
		
			if(data!==null){
				this.filters.pageNum=data.pageRequest.pageNum		
			}else{
				this.filters.pageNum=1
			}
			this.filters.pageSize=this.pageRequest.pageSize	
			this.$api.receipt.findReceiptOutPage(this.filters).then((res) => {
				this.pageResult = res.data
			console.log(this.pageResult.content.status);
			}).then(data!=null?data.callback:'')
		},
		
		// 批量删除
		handleDelete: function (data) {
			this.$api.receipt.batchDelete(data.params).then(data!=null?data.callback:'')
		},
		// 显示新增界面
		handleAdd: function () {
			this.componentKey += 1;
			this.dialogVisible1 = true
			this.operation = true
			this.dataForm = {
				id: 0,
				outTypeClass:3,
				outType:parseInt(this.$route.path.substr(this.$route.path.lastIndexOf('/')+1))
			}
		},
		// 显示编辑界面
		handleEdit: function (params) {
			this.dialogVisible1 = true
			this.operation = true
			this.dataForm = Object.assign({}, params.row)
			 
		},
		// 导出文档
		handleExport: function (params) {
			this.saveFile(params);
		},
		saveFile : function(params) {
			 let a = document.createElement('a')
			 a.href =baseUrl+"/api/file/exports/"+params.row.id+"/"+params.row.receiptNo+"/"+params.row.outType
			 a.click();
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
				key="outTypeBatch"
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
		// 生成任务
		handleGenerate: function (params) {
			this.$confirm('确定生成任务吗？', '提示', {}).then(() => {
						this.$api.receipt.batchoutGenerate(params.row).then((res) => {
							if(res.code == 200) {
								this.$message({ message: '操作成功', type: 'success' })
								this.findPage(null)								
							} else {
								this.$message({message: '操作失败, ' + res.msg, type: 'error'})
							}							
						})
					})
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
				//{prop:"batchNo", label:"内部批号", minWidth:100},
				{prop:"status", label:"状态", minWidth:100 , formatter:this.selectionFormat},
				{prop:"stn", label:"field.stn", minWidth:100 , formatter:this.selectionFormat},
				{prop:"outType", label:"field.receipt.outType", minWidth:100 , formatter:this.selectionFormat},
				{prop:"priority", label:"field.receipt.priority", minWidth:70 , minWidth:120, formatter:this.selectionFormat},
				{prop:"pickType", label:"分拣类型", minWidth:100 , formatter:this.selectionFormat},
				{prop:"beginTime", label:"beginTime", minWidth:140, formatter:this.dateFormat},
				{prop:"finshTime", label:"finshTime", minWidth:140, formatter:this.dateFormat}
			]
			this.filterColumns = this.columns;
	},
  	watch:{
		$route(to,from){
			console.log(to.path);
			//debugger
			this.filters.outType=parseInt(to.path.substr(to.path.lastIndexOf('/')+1))
			this.findPage({pageRequest:{pageNum:1,pageSize:7}});
		}
  	}
}
</script>

<style scoped>

</style>