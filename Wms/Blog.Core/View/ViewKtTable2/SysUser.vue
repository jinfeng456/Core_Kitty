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
			<el-form-item>
				<kt-button :label="$t('action.add')" perms="sys:sysUser:add" type="primary" @click="handleAdd" />
			</el-form-item>
		</el-form>
	</div>
	<!--表格内容栏-->
	<kt-table2  permsDelete="sys:sysUser:delete" :myButtons="myButtons"
		:data="pageResult" :columns="columns" 
		@findPage="findPage" @handleEdit="handleEdit" @handleDelete="handleDelete" :pageRequest="this.pageRequest">
	</kt-table2>
	<!--新增编辑界面-->
	<el-dialog :title="operation?'新增':'编辑'" width="40%" :visible.sync="editDialogVisible" :close-on-click-modal="false">
		<el-form :model="dataForm" label-width="90px" :rules="dataFormRules" ref="dataForm" :size="size">
	
			<el-form-item label = "" prop="id" >
				<el-input v-model="dataForm.id" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "" prop="name" >
				<el-input v-model="dataForm.name" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "" prop="passwords" >
				<el-input v-model="dataForm.passwords" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "" prop="salt" >
				<el-input v-model="dataForm.salt" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "" prop="email" >
				<el-input v-model="dataForm.email" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "" prop="mobile" >
				<el-input v-model="dataForm.mobile" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "" prop="userstatus" >
				<el-input v-model="dataForm.userstatus" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "" prop="deptId" >
				<el-input v-model="dataForm.deptId" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "" prop="createBy" >
				<el-input v-model="dataForm.createBy" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "" prop="createTime" >
				<el-input v-model="dataForm.createTime" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "" prop="lastUpdateBy" >
				<el-input v-model="dataForm.lastUpdateBy" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "" prop="lastUpdateTime" >
				<el-input v-model="dataForm.lastUpdateTime" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "" prop="delFlag" >
				<el-input v-model="dataForm.delFlag" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "" prop="code" >
				<el-input v-model="dataForm.code" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "" prop="auditPassword" >
				<el-input v-model="dataForm.auditPassword" auto-complete="off"></el-input>
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
				{ prop: "id", label: "", minWidth: 100},
				{ prop: "name", label: "", minWidth: 100},
				{ prop: "passwords", label: "", minWidth: 100},
				{ prop: "salt", label: "", minWidth: 100},
				{ prop: "email", label: "", minWidth: 100},
				{ prop: "mobile", label: "", minWidth: 100},
				{ prop: "userstatus", label: "", minWidth: 100},
				{ prop: "deptId", label: "", minWidth: 100},
				{ prop: "createBy", label: "", minWidth: 100},
				{ prop: "createTime", label: "", minWidth: 100},
				{ prop: "lastUpdateBy", label: "", minWidth: 100},
				{ prop: "lastUpdateTime", label: "", minWidth: 100},
				{ prop: "delFlag", label: "", minWidth: 100},
				{ prop: "code", label: "", minWidth: 100},
				{ prop: "auditPassword", label: "", minWidth: 100},
			],
			pageRequest: { pageNum: 1, pageSize: 8 },
			pageResult: { },
			myButtons:[{
				name:"handleEdit",
				perms:"sys:sysUser:edit",
				label:"action.edit",
				icon:"fa fa-edit"
			},{
				name:"handleDelete",
				perms:"sys:sysUser:delete",
				label:"action.delete",
				type:"danger",
				icon:"fa fa-trash"
			}],
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
				id: null,
				name: null,
				passwords: null,
				salt: null,
				email: null,
				mobile: null,
				userstatus: null,
				deptId: null,
				createBy: null,
				createTime: null,
				lastUpdateBy: null,
				lastUpdateTime: null,
				delFlag: null,
				code: null,
				auditPassword: null,
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
			this.$api.sysUser.findPage(this.filters).then((res) => {
				this.pageResult = res.data
			}).then(data != null ? data.callback : '')
		},
		// 批量删除
		handleDelete: function(data){
			this.$api.sysUser.batchDelete(data.params).then(data != null ? data.callback : '')
		},
		// 显示新增界面
		handleAdd: function(){
			this.editDialogVisible = true
			this.operation = true
			this.dataForm = {
				id: null,
				name: null,
				passwords: null,
				salt: null,
				email: null,
				mobile: null,
				userstatus: null,
				deptId: null,
				createBy: null,
				createTime: null,
				lastUpdateBy: null,
				lastUpdateTime: null,
				delFlag: null,
				code: null,
				auditPassword: null,
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
						this.$api.sysUser.save(params).then((res) => {
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
//----------------------------------------代码结束------------------------------------------------------
