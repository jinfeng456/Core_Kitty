<template>
  <div class="container" >
	<!--工具栏-->
	<div class="toolbar" style="float:left;padding-top:10px;padding-left:15px;">
		<el-form :inline="true" :model="filters" :size="size">
			<el-form-item>
				<el-input v-model="filters.dictClassName" placeholder="名称"></el-input>
			</el-form-item>
			<el-form-item>
				<kt-button :label="$t('action.search')" perms="sys:dictClass:view" type="primary" @click="findPage(null)"/>
			</el-form-item>
			<el-form-item>
				<kt-button :label="$t('action.add')" perms="sys:dictClass:add" type="primary" @click="handleAdd" />
			</el-form-item>
		</el-form>
	</div>
	<!--表格内容栏-->
	<kt-table :height="388" permsEdit="sys:dictClass:edit" permsDelete="sys:dictClass:delete"
		:data="pageResult" :columns="columns" 
		@findPage="findPage" @handleEdit="handleEdit" @handleDelete="handleDelete" :pageRequest="this.pageRequest">
	</kt-table>
	<!--新增编辑界面-->
	<el-dialog :title="operation?'新增':'编辑'" width="40%" :visible.sync="editDialogVisible" :close-on-click-modal="false">
		<el-form :model="dataForm" label-width="80px" :rules="dataFormRules" ref="dataForm" :size="size">
			<el-form-item label="编号" prop="id"  v-if="false">
				<el-input v-model="dataForm.id" auto-complete="off"></el-input>
			</el-form-item>
			<el-form-item label="字典分类" prop="dictClassName">
				<el-input v-model="dataForm.dictClassName" auto-complete="off"></el-input>
			</el-form-item>
			<el-form-item label="字典备注" prop="dictRemark">
				<el-input v-model="dataForm.dictRemark" auto-complete="off"></el-input>
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
				dictClassName: ''
			},
			columns: [
				//{prop:"id", label:"编号", minWidth:100},
				{prop:"dictClassName", label:"字典分类", minWidth:100},
				{prop:"dictRemark", label:"字典备注", minWidth:100},
			],
			pageRequest: { pageNum: 1, pageSize: 8 },
			pageResult: {},

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
			this.$api.dictClass.findPage(this.filters).then((res) => {
				this.pageResult = res.data
			}).then(data!=null?data.callback:'')
		},
		// 批量删除
		handleDelete: function (data) {
			this.$api.dictClass.batchDelete(data.params).then(data!=null?data.callback:'')
		},
		// 显示新增界面
		handleAdd: function () {
			this.editDialogVisible = true
			this.operation = true
			this.dataForm = {
				id: 0,
				dictClassName: '',
				dictRemark: '',
			}
		},
		// 显示编辑界面
		handleEdit: function (params) {
			this.editDialogVisible = true
			this.operation = false
			this.dataForm = Object.assign({}, params.row)
		},
		// 编辑
		submitForm: function () {
			this.$refs.dataForm.validate((valid) => {
				if (valid) {
					this.$confirm('确认提交吗？', '提示', {}).then(() => {
						this.editLoading = true
						let params = Object.assign({}, this.dataForm)
						this.$api.dictClass.save(params).then((res) => {
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