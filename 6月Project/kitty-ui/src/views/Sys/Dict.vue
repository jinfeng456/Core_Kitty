<template>
  <div class="page-container">
	<!--工具栏-->
	<div class="toolbar" style="float:left;padding-top:10px;padding-left:15px;">
		<el-form :inline="true" :model="filters" :size="size" label-position="right">
					<el-form-item>
						<el-input v-model.trim="filters.label" :placeholder="$t('dict.name')"></el-input>
					</el-form-item>
					<el-form-item  prop="dictClassId">
					<el-select v-model="filters.dictClassId"  placeholder="请选择字典类型" style="width: 100%;"  clearable> 
							<el-option v-for="item in dictypes" :key="item.id"
								:label="item.dictRemark+item.dictClassName" :value="item.id" >
							</el-option>
					</el-select>
					</el-form-item>	
					<el-form-item>
					<kt-button icon="fa fa-search" :label="$t('action.search')" perms="sys:dict:view" type="primary" @click="findPage(null)"/>
					</el-form-item>		
					<el-form-item>
					<kt-button icon="fa fa-plus" :label="$t('action.add')" perms="sys:dict:add" type="primary" @click="handleAdd" />
					</el-form-item>		
		</el-form>
	</div>
	<!--表格内容栏-->
	<kt-table :height="388" permsEdit="sys:dict:edit" permsDelete="sys:dict:delete"
		:data="pageResult" :columns="columns" 
		@findPage="findPage" @handleEdit="handleEdit" @handleDelete="handleDelete" :pageRequest="this.pageRequest">
	</kt-table>
	<!--新增编辑界面-->
	<el-dialog :title="operation?$t('action.add'):$t('action.edit')" width="40%" :visible.sync="editDialogVisible" :close-on-click-modal="false">
		<el-form :model="dataForm" label-width="90px" :rules="dataFormRules" ref="dataForm" :size="size">
			<el-form-item label="ID" prop="id"  v-if="false">
				<el-input v-model="dataForm.id" :disabled="true" auto-complete="off"></el-input>
			</el-form-item>
			<el-form-item :label="$t('dict.dictType')" prop="dictClassId">
          	<el-select v-model="dataForm.dictClassId"  placeholder="Please select" style="width: 100%;"  > 
            		<el-option v-for="item in dictypes" :key="item.id"
						:label="item.dictClassName" :value="item.id" >
					</el-option>
          	</el-select>
        	</el-form-item>			
			<el-form-item :label="$t('dict.name')" prop="label">
				<el-input v-model="dataForm.label" auto-complete="off"></el-input>
			</el-form-item>
			<el-form-item :label="$t('dict.dictValue')" prop="value">
				<el-input v-model="dataForm.value" auto-complete="off"></el-input>
			</el-form-item>	
			<el-form-item :label="$t('dict.sort')" prop="sort">
				<el-input v-model="dataForm.sort" auto-complete="off"></el-input>
			</el-form-item>
			<el-form-item :label="$t('dict.description') " prop="descriptions">
				<el-input v-model="dataForm.descriptions" auto-complete="off" type="textarea"></el-input>
			</el-form-item>
			<el-form-item :label="$t('dict.remark')" prop="remarks">
				<el-input v-model="dataForm.remarks" auto-complete="off" type="textarea"></el-input>
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
import KtTable from "@/views/Core/KtTable"
import KtButton from "@/views/Core/KtButton"
import { format } from "@/utils/datetime"
export default {
	components:{
			KtTable,
			KtButton
	},
	data() {
		return {
			size: 'small',
			filters: {
				label: ''
			},
			pageRequest: { pageNum: 1, pageSize: 10 },
			pageResult: {},
            columns:[],
			operation: false, // true:新增, false:编辑
			editDialogVisible: false, // 新增编辑界面是否显示
			editLoading: false,
			dataFormRules: {
				label: [
					{ required: true, message: this.getKey("dict.dictNameInput"), trigger: 'blur' }
				],
				dictClassId: [
					{ required: true, message: this.getKey("dict.dictClassInput"), trigger: 'blur' }
				]
			},
			columns : [		
				{prop:"label", label:"dict.name", minWidth:100},	
				{prop:"value", label:"dict.dictValue", minWidth:100},
				{prop:"dtype", label:"dict.dictType", minWidth:120},
				{prop:"sort", label:"dict.sort", minWidth:50},
				{prop:"descriptions", label:"dict.description", minWidth:120},
				{prop:"remarks", label:"dict.remark", minWidth:120},
				{prop:"createBy", label:"public.createName", minWidth:120},
				{prop:"createTime", label:"public.createTime", minWidth:130, formatter:this.dateFormat}
				// {prop:"lastUpdateBy", label:"更新人", minWidth:100},
				// {prop:"lastUpdateTime", label:"更新时间", minWidth:120, formatter:this.dateFormat}
			],
			// 新增编辑界面数据
			dataForm: {
				id: 0,
				label: '',
				value: '',
				sort: 0,
				descriptions: '',
				remarks: '',
				dictClassId:undefined
			},
			dictypes: []
		}
	},
	methods: {
		// 获取分页数据
		findPage: function (data) {
			//debugger
			if(data!==null){
				this.filters.pageNum=data.pageRequest.pageNum		
			}else{
				this.filters.pageNum=1
				this.pageRequest.pageNum=1
			}
			this.filters.pageSize=this.pageRequest.pageSize		
			this.$api.dict.findPage(this.filters).then((res) => {
				this.pageResult = res.data
				this.findDictypes()
			}).then(data!=null?data.callback:'')		
		},
		// 批量删除
		handleDelete: function (data) {
			this.$api.dict.batchDelete(data.params).then(data!=null?data.callback:'')
		},
		// 显示新增界面
		handleAdd: function () {
			this.editDialogVisible = true
			this.operation = true		
			this.dataForm = {
				id: 0,
				label: '',
				value: '',
				sort: 0,
				descriptions: 'desc',
				remarks: 'remark',
				dictClassId:undefined
			}			
		},
		// 显示编辑界面
		handleEdit: function (params) {
			this.editDialogVisible = true
			this.operation = false
			this.dataForm = Object.assign({}, params.row)
			this.findDictypes()
		},
		// 编辑
		submitForm: function () {
			this.$refs.dataForm.validate((valid) => {
				if (valid) {
					this.$confirm(this.getKey('action.isConfirm'), this.getKey('action.tips'), {}).then(() => {
						this.editLoading = true
						let params = Object.assign({}, this.dataForm)
						this.$api.dict.save(params).then((res) => {
							if(res.code == 200) {
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
		//国际化
		getKey: function (arg) {
			return this.$t(arg)
		},
		// 时间格式化
      	dateFormat: function (row, column, cellValue, index){
          	return format(row[column.property])
      	},
		// 加载字典分类
		findDictypes: function () {
			this.$api.dictClass.GetAllList().then((res) => {
				// 加载字典分类集合
				this.dictypes = res.data	
			})		
		}
	},
   watch:{
	
    editDialogVisible(to,from){
       if (this.$refs['dataForm'] !== undefined) {
            this.$refs["dataForm"].resetFields();
          }
    }
  }
}
</script>

<style scoped>

</style>