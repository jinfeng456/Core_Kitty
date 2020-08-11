<template>
  <div class="container" >
	<!--工具栏-->
	<div class="toolbar" style="float:left;padding-top:10px;padding-left:15px;">
		<el-form :inline="true" :model="filters" :size="size">
			<el-form-item>
				<el-input v-model.trim="filters.batchNo" placeholder="内部批次号"></el-input>
			</el-form-item>
			<el-form-item>
			<el-form-item >
						<el-select v-model.trim="filters.itemId"
							placeholder="请选择物料名称"
							style="width: 175px" clearable>
							<el-option v-for="item in Items"
									:key="item.id"
									:label="item.name"
									:value="item.id">
							</el-option>
				        </el-select>
			</el-form-item>	
				<kt-button :label="$t('action.search')" perms="sys:dictClass:view" type="primary" @click="findPage(null)"/>
			</el-form-item>		
		</el-form>
	</div>
	<!--表格内容栏-->
	<kt-table2 
               	:myButtons="myButtons"
			   	:height="388" 
				:data="pageResult" :columns="columns" :showOperation="true" :showBatchDelete="false"
				@handleEdit="handleEdit"
				@findPage="findPage" > :pageRequest="this.pageRequest"
	</kt-table2>
		<!--新增编辑界面-->
	<el-dialog :title="$t('action.edit')" width="40%" :visible.sync="editDialogVisible" 
	:close-on-click-modal="false">
		<el-form :model="dataForm" label-width="90px" ref="dataForm" :size="size">
			<el-form-item label="编号" prop="id">
				<el-input v-model="dataForm.id" :disabled="true" auto-complete="off"></el-input>
			</el-form-item>
			
			<el-form-item label="优先级" prop="priority">
				<el-input v-model="dataForm.priority" :placeholder="'请输入优先级1-9'" auto-complete="off"></el-input>
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
export default {
	components:{
			KtTable2,
			KtButton
	},
	data() {
		return {
			size: 'small',
			filters: {
				batchNo: '',
				isWarning:true
			},
			Items: [],
			columns: [
				{prop:"itemId", label:"物料名称", minWidth:100,formatter:this.itemFilter},
                {prop:"batchNo", label:"内部批次号", minWidth:100},
				{prop:"packageSpec", label:"规格", minWidth:100},
                {prop:"packUnit", label:"单位", minWidth:100},
                {prop:"inCount", label:"入库数量", minWidth:100},
                {prop:"outCount", label:"出库数量", minWidth:100},
				{prop:"lastCount", label:"结存数量", minWidth:100},
				{prop:"priority", label:"优先级", minWidth:100}			
			],
			pageRequest: { pageNum: 1, pageSize: 8 },
			pageResult: {},
			myButtons: [{
				name: "handleEdit",
				perms: "core:receiptout:edit",
				label: "action.edit",
				icon: "fa fa-edit"
			}],
			// 新增编辑界面数据
			dataForm: {
			
			},
		
			editDialogVisible: false, // 新增编辑界面是否显示
			editLoading: false,					
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
			this.$api.batch.FindBatchReport(this.filters).then((res) => {
				this.pageResult = res.data
			}).then(data!=null?data.callback:'')
		},
		submitForm: function () {
			this.$refs.dataForm.validate((valid) => {
			if (valid) {
				this.$confirm(this.getKey('action.isConfirm'), this.getKey('action.tips'), {}).then(() => {
				this.editLoading = true
				let params = Object.assign({}, this.dataForm)
				this.$api.batch.UpdatePriority(params).then((res) => {
						this.editLoading = false
						if (res.code == 200) {
						this.$message({ message: this.getKey('action.operateSucess'), type: 'success' })
						/* this.dialogVisibles = true
						this.$refs['dataForm'].resetFields() */
						} else {
						this.$message({ message: this.getKey('action.operateFail') + res.msg, type: 'error' })
						}
						this.findPage(null)
					})
				})
			}
		})
    	},
		    // 显示编辑界面
		handleEdit: function (params) {	
			this.editDialogVisible = true
			this.dataForm = Object.assign({}, params.row)
		},
		//加载物料
		findItems: function () {
			this.$api.item.findAll().then((res) => {
				this.Items = res.data			
			})
		},
		//物料名称
		itemFilter:  function (row, column, cellValue, index){
				let key = ""
				let propt = column.property;
				let val = row[column.property];				
				let dict = this.Items;
				for (let i = 0; i < dict.length; i++) {
					if (dict[i].id == val) {
					return dict[i].name;
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
	created() {
		this.findItems();
	}
}
</script>

<style scoped>

</style>