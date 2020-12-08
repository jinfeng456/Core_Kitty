





//--------------------------------------------------------------------
//     此代码由T4模板自动生成
//	   生成时间 2020-12-08 13:43:11 
//     对此文件的更改可能会导致不正确的行为，并且如果重新生成代码，这些更改将会丢失。
//--------------------------------------------------------------------
  

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
				<kt-button :label="$t('action.search')" perms="sys:tasksQz:view" type="primary" @click="findPage(null)"/>
			</el-form-item>
			<el-form-item>
				<kt-button :label="$t('action.add')" perms="sys:tasksQz:add" type="primary" @click="handleAdd" />
			</el-form-item>
		</el-form>
	</div>
	<!--表格内容栏-->
	<kt-table2  permsDelete="sys:tasksQz:delete" :myButtons="myButtons"
		:data="pageResult" :columns="columns" 
		@findPage="findPage" @handleEdit="handleEdit" @handleDelete="handleDelete" :pageRequest="this.pageRequest">
	</kt-table2>
	<!--新增编辑界面-->
	<el-dialog :title="operation?'新增':'编辑'" width="40%" :visible.sync="editDialogVisible" :close-on-click-modal="false">
		<el-form :model="dataForm" label-width="90px" :rules="dataFormRules" ref="dataForm" :size="size">
	
			<el-form-item label = "" prop="id" >
				<el-input v-model="dataForm.id" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "任务名称" prop="name" >
				<el-input v-model="dataForm.name" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "任务分组" prop="jobGroup" >
				<el-input v-model="dataForm.jobGroup" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "时间表达式" prop="cron" >
				<el-input v-model="dataForm.cron" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "程序集名称" prop="assemblyName" >
				<el-input v-model="dataForm.assemblyName" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "任务所在类" prop="className" >
				<el-input v-model="dataForm.className" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "任务描述" prop="remark" >
				<el-input v-model="dataForm.remark" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "执行次数" prop="runTimes" >
				<el-input v-model="dataForm.runTimes" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "开始时间" prop="beginTime" >
				<el-input v-model="dataForm.beginTime" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "结束时间" prop="endTime" >
				<el-input v-model="dataForm.endTime" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "触发器类型" prop="triggerType" >
				<el-input v-model="dataForm.triggerType" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "执行间隔时间" prop="intervalSecond" >
				<el-input v-model="dataForm.intervalSecond" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "是否启动" prop="isStart" >
				<el-input v-model="dataForm.isStart" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "执行传参" prop="jobParams" >
				<el-input v-model="dataForm.jobParams" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "IsDeleted" prop="isDeleted" >
				<el-input v-model="dataForm.isDeleted" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item label = "创建时间" prop="createTime" >
				<el-input v-model="dataForm.createTime" auto-complete="off"></el-input>
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
				{ prop: "name", label: "任务名称", minWidth: 100},
				{ prop: "jobGroup", label: "任务分组", minWidth: 100},
				{ prop: "cron", label: "时间表达式", minWidth: 100},
				{ prop: "assemblyName", label: "程序集名称", minWidth: 100},
				{ prop: "className", label: "任务所在类", minWidth: 100},
				{ prop: "remark", label: "任务描述", minWidth: 100},
				{ prop: "runTimes", label: "执行次数", minWidth: 100},
				{ prop: "beginTime", label: "开始时间", minWidth: 100},
				{ prop: "endTime", label: "结束时间", minWidth: 100},
				{ prop: "triggerType", label: "触发器类型", minWidth: 100},
				{ prop: "intervalSecond", label: "执行间隔时间", minWidth: 100},
				{ prop: "isStart", label: "是否启动", minWidth: 100},
				{ prop: "jobParams", label: "执行传参", minWidth: 100},
				{ prop: "isDeleted", label: "IsDeleted", minWidth: 100},
				{ prop: "createTime", label: "创建时间", minWidth: 100},
			],
			pageRequest: { pageNum: 1, pageSize: 8 },
			pageResult: { },
			myButtons:[{
				name:"handleEdit",
				perms:"sys:tasksQz:edit",
				label:"action.edit",
				icon:"fa fa-edit"
			},{
				name:"handleDelete",
				perms:"sys:tasksQz:delete",
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
				id: 0,
				name: null,
				jobGroup: null,
				cron: null,
				assemblyName: null,
				className: null,
				remark: null,
				runTimes: null,
				beginTime: null,
				endTime: null,
				triggerType: null,
				intervalSecond: null,
				isStart: null,
				jobParams: null,
				isDeleted: null,
				createTime: null,
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
			this.$api.tasksQz.findPage(this.filters).then((res) => {
				this.pageResult = res.data
			}).then(data != null ? data.callback : '')
		},
		// 批量删除
		handleDelete: function(data){
			this.$api.tasksQz.batchDelete(data.params).then(data != null ? data.callback : '')
		},
		// 显示新增界面
		handleAdd: function(){
			this.editDialogVisible = true
			this.operation = true
			this.dataForm = {
				id: 0,
				name: null,
				jobGroup: null,
				cron: null,
				assemblyName: null,
				className: null,
				remark: null,
				runTimes: null,
				beginTime: null,
				endTime: null,
				triggerType: null,
				intervalSecond: null,
				isStart: null,
				jobParams: null,
				isDeleted: null,
				createTime: null,
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
						this.$api.tasksQz.save(params).then((res) => {
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

 

	