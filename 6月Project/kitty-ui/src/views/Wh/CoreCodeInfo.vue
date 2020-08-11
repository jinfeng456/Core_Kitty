<template>
  <div class="container" >
	<!--工具栏-->
	<div class="toolbar" style="float:left;padding-top:10px;padding-left:15px;">
		<el-form :inline="true" :model="filters" :size="size">
			<el-form-item>
				<el-input v-model="filters.barCode" placeholder="条码"></el-input>
			</el-form-item>
			<el-form-item>
				<kt-button :label="$t('action.search')" perms="receipt:coreCodeInfo:view" type="primary" @click="findPage(null)"/>
			</el-form-item>
			<el-form-item>
				<kt-button label="修改完成" perms="receipt:coreCodeInfo:finish" type="primary" @click="UpdateUploadStatus" />
			</el-form-item>
			<el-form-item>
				<kt-button label="导出文档" perms="receipt:coreCodeInfo:export" type="primary" @click="handleExport" />
			</el-form-item>
		</el-form>
	</div>
	<!--表格内容栏-->
	<kt-table2 :height="388" :myButtons="myButtons"
		:data="pageResult" :columns="columns" 
		@findPage="findPage" @handleEdit="handleEdit" :showBatchDelete="false" :pageRequest="this.pageRequest" >
	</kt-table2>
	<!--新增编辑界面-->
	<el-dialog :title="operation?'新增':'编辑'" width="40%" :visible.sync="editDialogVisible" :close-on-click-modal="false">
		<el-form :model="dataForm" label-width="80px" :rules="dataFormRules" ref="dataForm" :size="size">
			<el-form-item label="编号" prop="id"  v-if="false">
				<el-input v-model="dataForm.id" auto-complete="off"></el-input>
			</el-form-item>
			<el-form-item label="条码" prop="barCode">
				<el-input v-model="dataForm.barCode" auto-complete="off"></el-input>
			</el-form-item>
		</el-form>
		<div slot="footer" class="dialog-footer">
			<el-button :size="size" @click.native="editDialogVisible = false">{{$t('action.cancel')}}</el-button>
			<el-button :size="size" type="primary" @click.native="submitForm" :loading="editLoading">{{$t('action.submit')}}</el-button>
		</div>
	</el-dialog>
  </div>
</template>

<script>
import KtTable2 from "@/views/Core/KtTable2"
import KtButton from "@/views/Core/KtButton"
import { format } from "@/utils/datetime"
import { baseUrl } from '@/utils/global'

export default {
	components:{
			KtTable2,
			KtButton
	},
	data() {
		return {
			size: 'small',
			filters: {
				barCode: ''
			},
			columns: [
				//{prop:"_id", label:"编号", minWidth:100},
				{prop:"barCode", label:"条码", minWidth:100},
				{prop:"parentCode", label:"父条码", minWidth:100},
				{prop:"isFull", label:"是否整托", minWidth:100},
				{prop:"status", label:"库存状态", minWidth:100, formatter:this.selectionFormat},
				{prop:"count", label:"数量", minWidth:100},
				{prop:"level", label:"等级", minWidth:100},
				{prop:"stockDetailId", label:"明细主键", minWidth:100},				
				{prop:"oldBarcode", label:"旧条码", minWidth:100},
				{prop:"uploadStatus", label:"上传状态", minWidth:100, formatter:this.selectionFormat},

			],
			outType:301,
			myButtons:[{
				name:"handleEdit",
				perms:"receipt:coreCodeInfo:edit",
				label:"修改条码",
				icon:"fa fa-edit"
			}],
			pageRequest: { pageNum: 1, pageSize: 8 },
			pageResult: {},
			oldBarcode:'',
			operation: false, // true:新增, false:编辑
			editDialogVisible: false, // 新增编辑界面是否显示
			editLoading: false,
			dataFormRules: {
				dictClassName: [
					{ required: true, message: '请输入字典分类名称', trigger: 'blur' }
				]
			},
			// 新增编辑界面数据
			dataForm: {
				id: null,
				dictClassName: null,
				dictRemark: null,
			}
		}
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
			this.$api.coreCodeInfo.findPage(this.filters).then((res) => {
				this.pageResult = res.data			
			}).then(data!=null?data.callback:'')
		},
		
		// 修改完成
		UpdateUploadStatus: function () {
			this.$confirm('确认完成修改吗？', '提示', {}).then(() => {
				this.$api.coreCodeInfo.UpdateUpLoadStatus().then((res) => {
								if(res.code == 200) {
									this.$message({ message: '操作成功', type: 'success' })
								} else {
									this.$message({message: '操作失败, ' + res.msg, type: 'error'})
								}						
								this.findPage(null)
							})
						})
		},
		// 显示编辑界面
		handleEdit: function (params) {
			this.editDialogVisible = true
			this.operation = false
			this.dataForm = Object.assign({}, params.row)
			this.oldBarcode = this.dataForm.barCode;
		},
		// 编辑
		submitForm: function () {
			this.$refs.dataForm.validate((valid) => {
				if (valid) {
					this.$confirm('确认提交吗？', '提示', {}).then(() => {
						this.editLoading = true
						let params = Object.assign({}, this.dataForm)
						params.oldBarcode = this.oldBarcode;
						this.$api.coreCodeInfo.UpdateBarCode(params).then((res) => {
							if(res.code == 200) {
								this.$message({ message: '操作成功', type: 'success' })
							} else {
								this.$message({message: '操作失败, ' + res.msg, type: 'error'})
							}
							this.editLoading = false
							this.$refs['dataForm'].resetFields()
							this.editDialogVisible = false
							this.findPage(null)
						})
					})
				}
			})
		},
		// 导出文档
		handleExport: function (params) {
			this.saveFile(params);
		},
		saveFile : function(params) {
			 let a = document.createElement('a')
			 a.href =baseUrl+"/api/file/ExportBarCode/"+this.outType
			 a.click();
		},
		//字典格式
		selectionFormat: function (row, column, cellValue, index){
			let key=""
			let propt=column.property;
			if(propt=="uploadStatus"){
				key="uploadStatus"
			}else if(propt=="status"){
				key="stockStatus"
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
		//国际化
		getKey: function (arg) {
			return this.$t(arg)
		},
		// 时间格式化
      	dateFormat: function (row, column, cellValue, index){
          	return format(row[column.property])
      	}
	},
	mounted() {
	}
}
</script>

<style scoped>

</style>