<template>
	<!--工具栏-->
	<div class="toolbar" style="float:left;padding-top:10px;padding-left:15px;">
		<el-form :model="dataForm" label-width="80px" :rules="dataFormRules" ref="dataForm" :size="size">
			<el-form-item label="数据库" prop="dataBase" >
				<el-input v-model="dataForm.dataBase" auto-complete="off" disabled="false"></el-input>
			</el-form-item>
			<el-form-item label="表名" prop="tableName" >
				<el-select v-model="dataForm.tableName" multiple :placeholder="$t('action.select')"
					 style="width: 100%;" clearable="">
					<el-option v-for="item in tableNames" :key="item.name"
						:label="item.name" :value="item.name">
					</el-option>
				</el-select>
			</el-form-item>
			<el-form-item label="模板" prop="templete" >
				<el-select v-model="dataForm.templete" :placeholder="$t('action.select')"
					 style="width: 100%;" clearable="">
					<el-option v-for="item in templetes" :key="item"
						:label="item" :value="item">
					</el-option>
				</el-select>
			</el-form-item>
		</el-form>
		<div slot="footer" class="dialog-footer">
			<el-button :size="size" type="primary" @click.native="handleAdd" :loading="editLoading">{{$t('action.submit')}}</el-button>
		</div>
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
			tableList:[],
			dataForm: {
				tableName: [],
				dataBase:'',
				templete:''
			},
			templetes:["viewQuery.html","viewKtTable.html","viewKtTable2.html"],
			tableNames:[],
			editLoading:false,
			dataFormRules: {
				dataBase: [
					{ required: true, message: '请输入数据库名称', trigger: 'blur' }
				],
				tableName: [
					{ required: true, message: '请输入表名', trigger: 'blur' }
				]
			},
		}
	},
	methods: {			
		// 显示新增界面
		handleAdd: function () {
			this.$refs.dataForm.validate((valid) => {
				if (valid) {
					this.$confirm('确认提交吗？', '提示', {}).then(() => {	
						this.editLoading=true;
						this.$api.generate.generate(this.dataForm.tableName,this.dataForm.dataBase,this.dataForm.templete).then((res) => {
							if(res.status=200){
								this.$message({ message: '操作成功', type: 'success' })
							}	
						})
						this.editLoading=false;	
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
		getDatabase:function(){
			this.$api.generate.getDatabase().then((res) => {
							if(res.status=200){
								this.dataForm.dataBase=res.data;								
							}
						})
		},
		getTableNames:function(){
			this.$api.generate.getTableNames().then((res) => {
							if(res.status=200){
								this.tableNames=res.data;								
							}
						})
		}
		
	},
	mounted() {
		this.getDatabase()
		this.getTableNames()
	},
   watch:{ 
  }
}
</script>

<style scoped>

</style>