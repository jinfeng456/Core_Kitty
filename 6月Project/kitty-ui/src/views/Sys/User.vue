<template>
  <div class="page-container">
	<!--工具栏-->
	<div class="toolbar" style="float:left;padding-top:10px;padding-left:15px;">
		<el-form :inline="true" :model="filters" :size="size">
			<el-form-item>
				<el-input v-model="filters.name" :placeholder="$t('user.name')"></el-input>
			</el-form-item>		
			<el-form-item>
				<kt-button icon="fa fa-search" :label="$t('action.search')" perms="sys:user:view" type="primary" @click="findPage(null)"/>
			</el-form-item>
			<el-form-item> 
				<kt-button icon="fa fa-plus" :label="$t('action.add')" perms="sys:user:add" type="primary" @click="handleAdd" />
			</el-form-item>
		</el-form>
	</div>
	<div class="toolbar" style="float:right;padding-top:10px;padding-right:15px;">
		<el-form :inline="true" :size="size">
			<el-form-item>
				<el-button-group>
				<el-tooltip :content="$t('action.refresh')" placement="top">
					<el-button icon="fa fa-refresh" @click="findPage(null)"></el-button>
				</el-tooltip>
				<el-tooltip :content="$t('action.column')" placement="top">
					<el-button icon="fa fa-filter" @click="displayFilterColumnsDialog"></el-button>
				</el-tooltip>
				<!-- <el-tooltip content="导出" placement="top">
					<el-button icon="fa fa-file-excel-o"></el-button>
				</el-tooltip> -->
				</el-button-group>
			</el-form-item>
		</el-form>
		<!--表格显示列界面-->
		<table-column-filter-dialog ref="tableColumnFilterDialog" :columns="columns" 
			@handleFilterColumns="handleFilterColumns"> 
		</table-column-filter-dialog>
	</div>
	<!--表格内容栏-->
	<kt-table :height="388" permsEdit="sys:user:edit" permsDelete="sys:user:delete"
		:data="pageResult" :columns="filterColumns"
		@findPage="findPage" @handleEdit="handleEdit" @handleDelete="handleDelete" :pageRequest="this.pageRequest">
	</kt-table>
	<!--新增编辑界面-->
	<el-dialog :title="operation?$t('action.add'):$t('action.edit')" width="40%" :visible.sync="dialogVisible" :close-on-click-modal="false">
		<el-form :model="dataForm" label-width="90px" :rules="dataFormRules" ref="dataForm" :size="size"
			label-position="right">
			<el-form-item label="ID" prop="id" v-if="false">
				<el-input v-model="dataForm.id" :disabled="true" auto-complete="off"></el-input>
			</el-form-item>
			<el-form-item :label="$t('user.name')" prop="name">
				<el-input v-model.trim="dataForm.name" auto-complete="off"></el-input>
			</el-form-item>
			<!-- <el-form-item :label="$t('user.passwords')" prop="passwords">
				<el-input v-model.trim="dataForm.passwords" type="password" auto-complete="off"></el-input>
			</el-form-item> -->
			<!-- <el-form-item label="机构" prop="deptName">
				<popup-tree-input 
					:data="deptData" 
					:props="deptTreeProps" 
					:prop="dataForm.deptName" 
					:nodeKey="''+dataForm.deptId" 
					:currentChangeHandle="deptTreeCurrentChangeHandle">
				</popup-tree-input>
			</el-form-item> -->
			<!-- <el-form-item :label="$t('user.email')" prop="email">
				<el-input v-model.trim="dataForm.email" auto-complete="off"></el-input>
			</el-form-item>
			<el-form-item :label="$t('user.mobile')" prop="mobile">
				<el-input v-model.trim="dataForm.mobile" auto-complete="off"></el-input>
			</el-form-item> -->
			<el-form-item :label="$t('user.code')" prop="email">
				<el-input v-model="dataForm.code" auto-complete="off"></el-input>
			</el-form-item>
			<!-- <el-form-item :label="$t('user.auditPassword')" prop="email">
				<el-input v-model="dataForm.auditPassword" type="password" auto-complete="off"></el-input>
			</el-form-item>		 -->
			<el-form-item :label="$t('user.roleNames')" prop="userRoles" v-if="!operation">
				<el-select v-model="dataForm.userRoles" multiple :placeholder="$t('action.select')"
					 style="width: 100%;">
					<el-option v-for="item in roles" :key="item.id"
						:label="item.remark" :value="item.id">
					</el-option>
				</el-select>
			</el-form-item>
		</el-form>
		<div slot="footer" class="dialog-footer">
			<el-button :size="size" @click.native="dialogVisible = false">{{$t('action.cancel')}}</el-button>
			<el-button :size="size" type="primary" @click.native="submitForm" :loading="editLoading">{{$t('action.submit')}}</el-button>
			<el-button :size="size" type="primary" @click.native="reset" :loading="resetLoading">{{$t('action.reset')}}</el-button>

		</div>
	</el-dialog>
  </div>
</template>

<script>
import PopupTreeInput from "@/components/PopupTreeInput"
import KtTable from "@/views/Core/KtTable"
import KtButton from "@/views/Core/KtButton"
import TableColumnFilterDialog from "@/views/Core/TableColumnFilterDialog"
import { format } from "@/utils/datetime"
export default {
	components:{
		PopupTreeInput,
		KtTable,
		KtButton,
		TableColumnFilterDialog
	},
	data() {
		return {
			size: 'small',
			filters: {
				name: ''
			},
			columns: [],
			filterColumns: [],
			pageRequest: { pageNum: 1, pageSize: 10 },
			pageResult: {},

			operation: false, // true:新增, false:编辑
			dialogVisible: false, // 新增编辑界面是否显示
			editLoading: false,
			resetLoading:false,
			param:{},
			// 新增编辑界面数据
			dataForm: {
				id: 0,
				name: '',
				passwords: '123456',
				deptId: 1,
				deptName: '',
				email: 'test@qq.com',
				mobile: '13889700023',
				userstatus: 1,
				userRoles: [],
				code:'',
				auditPassword:''
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
		dataFormRules() {
			const dataFormRules= {
				name:[{ required: true, message: this.getKey("user.userInput"), trigger: 'blur' }]
			};
			return dataFormRules;
			}		
	},	
	methods: {
		// 获取分页数据
		findPage: function (data) {
			if(data!==null){
				this.filters.pageNum=data.pageRequest.pageNum		
			}else{
				this.filters.pageNum=1
				this.pageRequest.pageNum=1
			}
			this.filters.pageSize=this.pageRequest.pageSize		
			this.$api.user.findPage(this.filters).then((res) => {
				this.pageResult = res.data
				//this.findUserRoles()				
			}).then(data!=null?data.callback:'')			
		},
		// 加载用户角色信息
		findUserRoles: function () {
			this.$api.role.findAll().then((res) => {
				// 加载角色集合
				this.roles = res.data	
			})
		},
		// 批量删除
		handleDelete: function (data) {
		
			this.$api.user.batchDelete(data.params).then(data!=null?data.callback:'')
		},
		// 显示新增界面
		handleAdd: function () {
			this.dialogVisible = true
			this.operation = true
			this.dataForm = {
				id: 0,
				name: '',
				passwords: '123456',
				deptId: 1,
				deptName: '',
				email: 'test@qq.com',
				mobile: '13889700023',
				userstatus: 1,
				userRoles: [],
				code:'',
				auditPassword:''
			}
		},
		// 显示编辑界面
		handleEdit: function (params) {
			this.dialogVisible = true
			this.operation = false
			//params.row.passwords=null
			this.dataForm = Object.assign({}, params.row)		
			let userRoles = []
			this.$api.role.findUserRole({'userId':params.row.id}).then((res) => {
					// 加载角色集合
					for(let i=0,len=res.data.length; i<len; i++) {
					userRoles.push(res.data[i].id)
				}
			})		
			// for(let i=0,len=params.row.userRoles.length; i<len; i++) {
			// 	userRoles.push(params.row.userRoles[i].roleId)
			// }
			this.dataForm.userRoles = userRoles
		},
		// 提交
		submitForm: function () {
			this.$refs.dataForm.validate((valid) => {
				if (valid) {
					this.$confirm(this.getKey('action.isConfirm'), this.getKey('action.tips'), {}).then(() => {
						this.editLoading = true
						let params = Object.assign({}, this.dataForm)
						let userRoles = []
						for(let i=0,len=params.userRoles.length; i<len; i++) {
							let userRole = {
								userId: params.id,
								roleId: params.userRoles[i]
							}
							userRoles.push(userRole)
						}
						params.userRoles = userRoles
						this.$api.user.save(params).then((res) => {
							this.editLoading = false
							if(res.code == 200) {
								this.$message({ message: this.getKey('action.operateSucess'), type: 'success' })
								this.dialogVisible = false
								this.$refs['dataForm'].resetFields()
							} else {
								this.$message({message: this.getKey('action.operateFail') + res.msg, type: 'error'})
							}
							this.findPage(null)
						})
					})
				}
			})
		},
		//重置密码
		reset: function () {
			this.$refs.dataForm.validate((valid) => {
				if (valid) {
					this.$confirm(this.getKey('action.isConfirm'), this.getKey('action.tips'), {}).then(() => {
						this.resetLoading = true
						let params = Object.assign({}, this.dataForm)
						let userRoles = []
						for(let i=0,len=params.userRoles.length; i<len; i++) {
							let userRole = {
								userId: params.id,
								roleId: params.userRoles[i]
							}
							userRoles.push(userRole)
						}
						params.userRoles = userRoles	
						params.passwords="123456";				
						this.$api.user.save(params).then((res) => {
							this.resetLoading = false
							if(res.code == 200) {
								this.$message({ message: this.getKey('action.operateSucess'), type: 'success' })
								this.dialogVisible = false
								this.$refs['dataForm'].resetFields()
							} else {
								this.$message({message: this.getKey('action.operateFail') + res.msg, type: 'error'})
							}
							this.findPage(null)
						})
					})
				}
			})
		},
		// 获取部门列表
		findDeptTree: function () {
			this.$api.dept.findDeptTree().then((res) => {
				this.deptData = res.data
			})
		},
		// 菜单树选中
      	deptTreeCurrentChangeHandle (data, node) {
        	this.dataForm.deptId = data.id
        	this.dataForm.deptName = data.name
		},
		// 时间格式化
      	dateFormat: function (row, column, cellValue, index){
          	return format(row[column.property])
      	},
		// 处理表格列过滤显示
      	displayFilterColumnsDialog: function () {
			this.$refs.tableColumnFilterDialog.setDialogVisible(true)
      	},
		// 处理表格列过滤显示
      	handleFilterColumns: function (data) {
			this.filterColumns = data.filterColumns
			this.$refs.tableColumnFilterDialog.setDialogVisible(false)
      	},
		getKey: function (arg) {
			return this.$t(arg)
		},
		// 处理表格列过滤显示
      	initColumns: function () {
			this.columns = [
				//{prop:"id", label:"ID", minWidth:50},  
				{prop:"name", label:"user.name", minWidth:120}, 
				//{prop:"deptName", label:"机构", minWidth:120},
				//{prop:"roleNames", label:"user.roleNames", minWidth:100},
				//{prop:"email", label:"user.email", minWidth:120},
				//{prop:"mobile", label:"user.mobile", minWidth:100},
				{prop:"code", label:"user.code", minWidth:70},
				{prop:"userstatus", label:"user.userstatus", minWidth:70},
				// {prop:"createBy", label:"创建人", minWidth:120},
				// {prop:"createTime", label:"创建时间", minWidth:120, formatter:this.dateFormat}
				// {prop:"lastUpdateBy", label:"更新人", minWidth:100},
				// {prop:"lastUpdateTime", label:"更新时间", minWidth:120, formatter:this.dateFormat}
			]
			this.filterColumns = JSON.parse(JSON.stringify(this.columns));
      	}		
	},	
	mounted() {
		//this.findDeptTree()
		this.findUserRoles()
		this.initColumns()
	},
   watch:{
	
    dialogVisible(to,from){
       if (this.$refs['dataForm'] !== undefined) {
            this.$refs["dataForm"].resetFields();
          }
    }
  }
}
</script>

<style scoped>

</style>