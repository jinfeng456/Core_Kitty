<template>
 <div class="container" >
	<!--工具栏-->
	<div class="toolbar" style="float:left;padding-top:10px;padding-left:15px;">
		<el-form :inline="true" :model="filters" :size="size">
			<el-form-item>
				<el-input v-model="filters.label" placeholder="名称"></el-input>
			</el-form-item>
			<el-form-item>
				<kt-button :label="$t('action.search')" perms="sys:coreItem:view" type="primary" @click="findPage(null)"/>
			</el-form-item>
			<el-form-item>
				<kt-button :label="$t('action.add')" perms="sys:coreItem:add" type="primary" @click="handleAdd" />
			</el-form-item>
		</el-form>
	</div>
	<!--表格内容栏-->
	<kt-table :height="388" permsEdit = "sys:coreItem:edit" permsDelete="sys:coreItem:delete"
		:data="pageResult" :columns="columns" 
		@findPage="findPage" @handleEdit="handleEdit" @handleDelete="handleDelete" :pageRequest="this.pageRequest">
	</kt-table>
	<!--新增编辑界面-->
	<el-dialog :title="operation?'新增':'编辑'" width="40%" :visible.sync="editDialogVisible" :close-on-click-modal="false">
		<el-form :model="dataForm" label-width="90px" :rules="dataFormRules" ref="dataForm" :size="size">
			<el-form-item label="主键" prop="id"> 
 				<el-input v-model="dataForm.id" auto-complete="off"></el-input> 
			</el-form-item> 
			<el-form-item label="物料类别" prop="classifyId"> 
 				<el-input v-model="dataForm.classifyId" auto-complete="off"></el-input> 
			</el-form-item> 
			<el-form-item label="物料编码" prop="code"> 
 				<el-input v-model="dataForm.code" auto-complete="off"></el-input> 
			</el-form-item> 
			<el-form-item label="物料名称" prop="name"> 
 				<el-input v-model="dataForm.name" auto-complete="off"></el-input> 
			</el-form-item> 
			<el-form-item label="是否启用" prop="active"> 
 				<el-input v-model="dataForm.active" auto-complete="off"></el-input> 
			</el-form-item> 
			<el-form-item label="物料类型" prop="coreItemType"> 
 				<el-input v-model="dataForm.coreItemType" auto-complete="off"></el-input> 
			</el-form-item> 
			<el-form-item label="物料规格" prop="modelSpecs"> 
 				<el-input v-model="dataForm.modelSpecs" auto-complete="off"></el-input> 
			</el-form-item> 
			<el-form-item label="包装规格" prop="packageSpecs"> 
 				<el-input v-model="dataForm.packageSpecs" auto-complete="off"></el-input> 
			</el-form-item> 
			
		</el-form>
		<div slot = "footer" class="dialog-footer">
			<el-button :size="size" @click.native="editDialogVisible = false">{{$t('action.cancel')}}</el-button>
			<el-button :size="size" type="primary" @click.native="submitForm" :loading="editLoading">{{$t('action.submit')}}</el-button>
		</div>
	</el-dialog>
  </div>
</template>

<script>
import KtTable from "@/views/Core/KtTable"
import KtButton from "@/views/Core/KtButton"
import { format } from "@/utils/datetime"
export default {
	components:{
			KtTable,
			KtButton
	},
	data(){
		return {
			size: 'small',
			filters:{
				label: ''
			},
			columns: [
				{ prop: "id", label: "主键", minWidth: 100},
				{ prop: "classifyId", label: "物料类别", minWidth: 100},
				{ prop: "code", label: "物料编码", minWidth: 100},
				{ prop: "name", label: "物料名称", minWidth: 100},
				{ prop: "active", label: "是否启用", minWidth: 100},
				{ prop: "coreItemType", label: "物料类型", minWidth: 100},
				{ prop: "modelSpecs", label: "物料规格", minWidth: 100},
				{ prop: "packageSpecs", label: "包装规格", minWidth: 100},
				
			],
			pageRequest: { pageNum: 1, pageSize: 8 },
			pageResult: { },

			operation: false, // true:新增, false:编辑
			editDialogVisible: false, // 新增编辑界面是否显示
			editLoading: false,
			dataFormRules:{
				label: [
					{ required: true, message: '请输入名称', trigger: 'blur' }
				]
			},
			// 新增编辑界面数据
			dataForm:{
				id:0, 
				classifyId:null, 
				code:null, 
				name:null, 
				active:null, 
				coreItemType:null, 
				modelSpecs:null, 
				packageSpecs:null, 
				
			}
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
			this.$api.coreItem.findPage(this.filters).then((res) => {
				this.pageResult = res.data
			}).then(data != null ? data.callback : '')
		},
		// 批量删除
		handleDelete: function(data){
			this.$api.coreItem.batchDelete(data.params).then(data != null ? data.callback : '')
		},
		// 显示新增界面
		handleAdd: function(){
			this.editDialogVisible = true
			this.operation = true
			this.dataForm = {
				id:0, 
				classifyId:null, 
				code:null, 
				name:null, 
				active:null, 
				coreItemType:null, 
				modelSpecs:null, 
				packageSpecs:null, 
				
			}
		},
		// 显示编辑界面
		handleEdit: function(params){
			this.editDialogVisible = true
			this.operation = false
			this.dataForm = Object.assign({ }, params.row)
		},
		//国际化
		getKey: function (arg) {
			return this.$t(arg)
		},
		// 编辑
		submitForm: function(){
			this.$refs.dataForm.validate((valid) => {
				if (valid) {
					this.$confirm(this.getKey('action.isConfirm'), this.getKey('action.tips'), { }).then(() => {
						this.editLoading = true
						let params = Object.assign({ }, this.dataForm)
						this.$api.coreItem.save(params).then((res) => {
						if (res.code == 200){
								this.$message({ message: this.getKey('action.operateSucess'), type: 'success' })
							} else {
								this.$message({message: this.getKey('action.operateFail') + res.msg, type: 'error'})
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
