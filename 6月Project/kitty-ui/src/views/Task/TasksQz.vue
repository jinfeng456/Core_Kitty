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
			<el-form-item>
				<kt-button label="开启" perms="sys:tasksQz:add" type="primary" @click="handleStartJob" />
			</el-form-item>
			<el-form-item>
				<kt-button label="暂停" perms="sys:tasksQz:add" type="primary" @click="handleStopJob" />
			</el-form-item>
			<el-form-item>
				<kt-button label="重启" perms="sys:tasksQz:add" type="primary" @click="handleReCoveryJob" />
			</el-form-item>
		</el-form>
	</div>
	<!--表格内容栏-->
	<kt-table2  permsDelete="sys:tasksQz:delete" :myButtons="myButtons"
		:data="pageResult" :columns="columns" 
		@findPage="findPage" @selectionChange='selectionChange' @handleEdit="handleEdit" @handleDelete="handleDelete" :pageRequest="this.pageRequest">
	</kt-table2>
	<!--新增编辑界面-->
	<el-dialog :title="operation?'新增':'编辑'" width="40%" :visible.sync="editDialogVisible" :close-on-click-modal="false">
		<el-form :model="dataForm" label-width="90px" :rules="dataFormRules" ref="dataForm" :size="size">

			<el-form-item label = "任务组" prop="jobGroup" >
				<el-input v-model="dataForm.jobGroup" auto-complete="off"></el-input>
			</el-form-item>

			<el-form-item label = "名称" prop="name" >
				<el-input v-model="dataForm.name" auto-complete="off"></el-input>
			</el-form-item>

			<el-form-item label = "程序集" prop="assemblyName" >
				<el-input v-model="dataForm.assemblyName" auto-complete="off"></el-input>
			</el-form-item>

			<el-form-item label = "执行类名" prop="className" >
				<el-input v-model="dataForm.className" auto-complete="off"></el-input>
			</el-form-item>
	
			<el-form-item prop="triggerType" label="是否Cron" width="" sortable>
				<el-switch v-model="dataForm.triggerType" >
				</el-switch>
				<span style="float:right;color: #aaa;">(1：Cron模式，0：Simple模式)</span> 
			</el-form-item>
			
			<el-form-item label="Cron表达式" v-if="dataForm.triggerType" prop="Cron">
			<el-tooltip placement="top">
				<div slot="content">
					每隔5秒执行一次：*/5 * * * * ?<br >
					每隔1分钟执行一次：0 */1 * * * ?<br >
					每天23点执行一次：0 0 23 * * ?<br >
					每天凌晨1点执行一次：0 0 1 * * ?<br >
					每月1号凌晨1点执行一次：0 0 1 1 * ?<br >
					每月最后一天23点执行一次：0 0 23 L * ?<br >
					每周星期天凌晨1点实行一次：0 0 1 ? * L<br >
					在26分、29分、33分执行一次：0 26,29,33 * * * ?<br >
					每天的0点、13点、18点、21点都执行一次：0 0 0,13,18,21 * * ?<br >
				</div>
			<el-input v-model="dataForm.cron" auto-complete="off"></el-input>
			</el-tooltip>
			</el-form-item>
			<el-form-item label="循环周期" v-else prop="intervalSecond">
			<el-input-number v-model="dataForm.intervalSecond"  :min="1" style="width:200px;" auto-complete="off"></el-input-number>
				<span style="float:right;color: #aaa;">(单位：秒)</span> 
        	</el-form-item>
			
	
			<el-form-item label="是否激活" prop="isStart">
          <el-switch v-model="dataForm.isStart" >
            </el-switch>
        </el-form-item>

        <el-form-item label="开始时间" prop="beginTime">
            <el-date-picker type="date" placeholder="选择日期" v-model="dataForm.beginTime"></el-date-picker>
        </el-form-item>
        <el-form-item label="结束时间" prop="endTime">
            <el-date-picker type="date" placeholder="选择日期" v-model="dataForm.endTime"></el-date-picker>
        </el-form-item>
{{this.selection}}
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
			selection: [],
			columns: [
				//{ prop: "id", label: "", minWidth: 100},
				{ prop: "jobGroup", label: "任务分组", minWidth: 100},
				{ prop: "triggerType", label: "任务类型", minWidth: 100,formatter:this.selectionFormat},
				{ prop: "name", label: "名称", minWidth: 100},				
				{ prop: "cron", label: "Cron表达式", minWidth: 120},
				{ prop: "intervalSecond", label: "循环s", minWidth: 100},
				{ prop: "assemblyName", label: "程序集", minWidth: 100},
				//{ prop: "className", label: "任务所在类", minWidth: 100},
				//{ prop: "remark", label: "任务描述", minWidth: 100},
				{ prop: "runTimes", label: "运行次数", minWidth: 100},
				{ prop: "beginTime", label: "开始时间", minWidth: 100},
				{ prop: "endTime", label: "结束时间", minWidth: 100},
				{ prop: "isStart", label: "状态", minWidth: 100,formatter:this.statusFormat},
				//{ prop: "jobParams", label: "执行传参", minWidth: 100},
				//{ prop: "isDeleted", label: "是否删除", minWidth: 100},
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
				jobGroup: [{ required: true, message: "请输入组名", trigger: "blur" }],
				name: [{ required: true, message: "请输入Job名", trigger: "blur" }],
				beginTime: [{ required: true, message: "请选择开始时间", trigger: "blur" }],
				endTime: [{ required: true, message: "请选择结束时间", trigger: "blur" }],
				assemblyName: [{ required: true, message: "请输入程序集名", trigger: "blur" }],
				className: [{ required: true, message: "请输入执行的Job类名", trigger: "blur" }],
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
				runTimes: 0,
				beginTime: null,
				endTime: null,
				triggerType: true,
				intervalSecond: 0,
				isStart: false,
				jobParams: null,
				isDeleted: false,
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
		selectionFormat: function (row, column, cellValue, index){
			let key=""
			let propt=column.property;
			if(propt=="triggerType"){
				key="quartJobType"
			}else if(propt=="isStart"){
				key="quartJobStatus"
			}
		    let val=row[column.property];
			let dict = this.$store.state.dict.dicts[key];
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
		statusFormat: function (row, column, cellValue, index){	
			let val=row[column.property];
			return val==1?"开启":"关闭"	;
      	},
		//开启job
		handleStartJob() {
		let row = this.selection.selections;
		if (row.length!=1) {
			this.$message({
			message: "请选择要操作的一行数据！",
			type: "error"
			});
			return;
		}
		this.$confirm("确认启动该Job吗?", "提示", {
			type: "warning"
		})
			.then(() => {
			this.listLoading = true;
			//NProgress.start();		
			let para = { jobId: row[0].id };
			this.$api.tasksQz.startJob(para).then(res => {
				debugger
				if (isEmt(res)) {
				this.listLoading = false;
				return;
				}
				this.listLoading = false;
				//NProgress.done();
				debugger
				if (res.data.success) {
				this.$message({
					message: "启动成功",
					type: "success"
				});
				} else {
				this.$message({
					message: res.data.msg,
					type: "error"
				});
				}

				this.getTasks();
			});
			})
			.catch(() => {});
		},
		//暂停job
		handleStopJob() {
		let row = this.selection.selections;
		if (row.length!=1) {
			this.$message({
			message: "请选择要操作的一行数据！",
			type: "error"
			});

			return;
		}
		this.$confirm("确认暂停该Job吗?", "提示", {
			type: "warning"
		})
			.then(() => {
			this.listLoading = true;
			//NProgress.start();
			let para = { jobId: row[0].id };
			this.$api.tasksQz.stopJob(para).then(res => {
				if (isEmt(res)) {
				this.listLoading = false;
				return;
				}
				this.listLoading = false;
				//NProgress.done();
				if (res.data.success) {
				this.$message({
					message: "暂停成功",
					type: "success"
				});
				} else {
				this.$message({
					message: res.data.msg,
					type: "error"
				});
				}

				this.getTasks();
			});
			})
			.catch(() => {});
		},
		//重启job
		handleReCoveryJob() {
		let row = this.selection.selections;
		if (row.length!=1) {
			this.$message({
			message: "请选择要操作的一行数据！",
			type: "error"
			});

			return;
		}
		this.$confirm("确认重启该Job吗?", "提示", {
			type: "warning"
		})
			.then(() => {
			this.listLoading = true;
			//NProgress.start();
			let para = { jobId: row[0].id };
			this.$api.tasksQz.reCovery(para).then(res => {
				if (isEmt(res)) {
				this.listLoading = false;
				return;
				}
				this.listLoading = false;
				//NProgress.done();
				if (res.data.success) {
				this.$message({
					message: "重启成功",
					type: "success"
				});
				} else {
				this.$message({
					message: res.data.msg,
					type: "error"
				});
				}

				this.getTasks();
			});
			})
			.catch(() => {});
		},
		// 批量删除
		handleDelete: function(data){
			this.$api.tasksQz.batchDelete(data.params).then(data != null ? data.callback : '')
		},
		selectionChange: function (selection) {
      		this.selection = selection;
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
				runTimes: 0,
				beginTime: null,
				endTime: null,
				triggerType: true,
				intervalSecond: 0,
				isStart: false,
				jobParams: "",
				isDeleted: false,
				createTime: null,
			}
		},
		// 显示编辑界面
		handleEdit: function(params){	
			if (params.row.triggerType==1) {
				params.row.triggerType=true
			}
			else
			{
				params.row.triggerType=false
			}		
			this.editDialogVisible = true
			this.operation = false
			this.dataForm = Object.assign({ }, params.row)
		},
		//国际化
		getKey: function (arg) {
			return this.$t(arg)
		},
		// 提交
		submitForm: function(){	
			this.$refs.dataForm.validate((valid) => {
				if (valid) {
					this.$confirm(this.getKey('action.isConfirm'), this.getKey('action.tips'), { }).then(() => {
						this.editLoading = true
						let params = Object.assign({ }, this.dataForm)
						debugger
						if(params.triggerType){
							params.triggerType=1
						}else{
							params.triggerType=0
						}
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
