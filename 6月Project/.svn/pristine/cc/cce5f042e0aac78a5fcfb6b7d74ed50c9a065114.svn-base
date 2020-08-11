<template>
  <div class="container" >
	<!--工具栏-->
	<div class="toolbar" style="float:left;padding-top:10px;padding-left:15px;">
		<el-form :inline="true" :model="filters" :size="size">
			<el-form-item>
				<el-input v-model.trim="filters.boxCode" placeholder="托盘条码" :style="{width: '175px'}"></el-input>
			</el-form-item>	
			<el-form-item >
						<el-select v-model="filters.itemId"
							placeholder="请选择物料名称"
							style="width: 175px" clearable>
							<el-option v-for="item in Items"
									:key="item.id"
									:label="item.name"
									:value="item.id">
							</el-option>
				        </el-select>
			</el-form-item>			
			<el-form-item>
				<el-select v-model="filters.whId"
							placeholder="请选择库房"
							auto-complete="off"
							style="width: 175px;"
							clearable>
					<el-option v-for="item in whTypes"
							:key="item.id"
							:label="item.name"
							:value="item.id">
					</el-option>
				</el-select>
        	</el-form-item>
			<el-form-item>
				<el-select v-model="filters.areaId"
							:placeholder="$t('field.Core.corewhloc.Please enter the areaName')"
							auto-complete="off"
							style="width: 175px;"
							clearable>
					<el-option v-for="item in areaTypes"
							:key="item.Id"
							:label="item.areaName"
							:value="item.id">
					</el-option>
				</el-select>
			</el-form-item>
			<el-form-item>
				<el-select v-model="filters.locId"
							:placeholder="$t('请选择库位')"
							auto-complete="off"
							style="width: 175px;"
							clearable>
					<el-option v-for="item in whLocs"
							:key="item.Id"
							:label="item.id"
							:value="item.id">
					</el-option>
				</el-select>
			</el-form-item>
			
		</el-form>
	</div>
	<div class="toolbar" style="float:left;padding-top:0px;padding-left:15px;">
		<el-form :inline="true" :model="filters" :size="size">	
		<el-form-item>
          <el-date-picker type="datetime"
                          v-model="filters.exeBeginTime "
                          placeholder="有效期开始时间"
                          value-format="yyyy-MM-dd"
                          format="yyyy-MM-dd"
                          :style="{width: '175px'}">
          </el-date-picker>
        </el-form-item>
        <el-form-item>
          <el-date-picker type="datetime"
                          v-model="filters.exeEndTime "
                          placeholder="有效期结束时间"
                          value-format="yyyy-MM-dd"
                          format="yyyy-MM-dd"
                          :style="{width: '175px'}">
          </el-date-picker>
        </el-form-item>	
		<el-form-item>
          <el-date-picker type="datetime"
                          v-model="filters.retestBeginTime "
                          placeholder="复检期开始时间"
                          value-format="yyyy-MM-dd"
                          format="yyyy-MM-dd"
                          :style="{width: '175px'}">
          </el-date-picker>
        </el-form-item>
        <el-form-item>
          <el-date-picker type="datetime"
                          v-model="filters.retestEndTime "
                          placeholder="复检期结束时间"
                          value-format="yyyy-MM-dd"
                          format="yyyy-MM-dd"
                          :style="{width: '175px'}">
          </el-date-picker>
        </el-form-item>	
		<el-form-item>
			<kt-button :label="$t('action.search')" perms="core:coreStock:showDetail" type="primary" @click="findPage(null)"/>
		</el-form-item>
		</el-form>
	</div>
	<!--表格内容栏-->
	<kt-table2 	:myButtons="myButtons"
				:height="388" 
				:data="pageResult" 
				:columns="columns" 
				:showOperation="true"
				:showBatchDelete="false"
				@handleEdit="handleEdit"
				@findPage="findPage" :pageRequest="this.pageRequest">
	</kt-table2>

	<!--新增编辑界面-->
	<el-dialog :title="$t('action.edit')" width="40%" :visible.sync="editDialogVisible" 
	:close-on-click-modal="false">
		<el-form :model="dataForm" label-width="90px" ref="dataForm" :size="size">
			<el-form-item label="编号" prop="stockDetailId">
				<el-input v-model="dataForm.stockDetailId" :disabled="true" auto-complete="off"></el-input>
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
import KtTable from "@/views/Core/KtTable"
import KtButton from "@/views/Core/KtButton"
import { format } from "@/utils/datetime"
import { formatDay } from "@/utils/datetime"
export default {
	components:{
			KtTable2,
			KtButton
	},
	data() {
		return {
			size: 'small',
			filters: {
				boxCode: ''
			},
			dicts:{},
			whLocs: [],		
			areaTypes: [],
			Items: [],
			whTypes:[],
			columns: [
				//{prop:"id", label:"主表主键", minWidth:100},
				//{prop:"stockDetailId", label:"明细主键", minWidth:100},
				//{prop:"stockId", label:"主键", minWidth:100},
				//{prop:"whId", label:"仓库", minWidth:100,formatter:this.whFormat},
				//{prop:"pos", label:"", minWidth:100},
				{prop:"type", label:"物料类型", minWidth:100,formatter:this.selectionFormat},
				{prop:"itemId", label:"物料名称", minWidth:100,formatter:this.itemFilter},
				{prop:"wmsBanchNo", label:"内部批号", minWidth:100},
				{prop:"countDb", label:"数量", minWidth:100},
				{prop:"businessStatus", label:"检验状态", minWidth:100,formatter:this.selectionFormat},
				{prop:"inTime", label:"入库时间", minWidth:100,formatter:this.dateFormatDay},
				{prop:"releaseDate", label:"放行期", minWidth:100,formatter:this.dateFormatDay},
				{prop:"businessExp", label:"保质期", minWidth:100,formatter:this.dateFormatDay},
				{prop:"retestDate", label:"复检期", minWidth:100,formatter:this.dateFormatDay},
				{prop:"areaId", label:"库区", minWidth:100,formatter:this.areaFormat},
				{prop:"locId", label:"库位", minWidth:100},
				
				{prop:"boxCode", label:"托盘条码", minWidth:100},
				//{prop:"itemCode", label:"", minWidth:100},
				{prop:"stockStatus", label:"库存状态", minWidth:100,formatter:this.selectionFormat},
				
				{prop:"pkDetailStatus", label:"盘库状态", minWidth:100,formatter:this.selectionFormat},
				
				
				//{prop:"outTime", label:"出库时间", minWidth:130,formatter:this.dateFormat},
				//{prop:"changeTime", label:"改变时间", minWidth:130,formatter:this.dateFormat},
				//{prop:"receiptlnId", label:"", minWidth:100},
				//{prop:"receiptlOutId", label:"", minWidth:100},
				//{prop:"soOutId", label:"", minWidth:100},						
				//{prop:"businessStatus", label:"托盘状态", minWidth:100},
				//{prop:"businessCreateTime", label:"生产日期", minWidth:130,formatter:this.dateFormat},
				
				
				
				
				{prop:"locked", label:"是否锁定", minWidth:100,formatter:this.selectionFormat},
				//{prop:"priority", label:"优先级", minWidth:100,formatter:this.selectionFormat},
				
				//{prop:"frozen", label:"是否冻结", minWidth:100,formatter:this.selectionFormat},
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
			operation: false, // true:新增, false:编辑
			editDialogVisible: false, // 新增编辑界面是否显示
			editLoading: false,
			dataFormRules: {
				boxCode: [
					{ required: true, message: '请输入名称', trigger: 'blur' }
				]
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
			this.$api.coreStock.QueryRealCoreDetailPage(this.filters).then((res) => {
				this.pageResult = res.data
			}).then(data!=null?data.callback:'')
		},		
		submitForm: function () {
			this.$refs.dataForm.validate((valid) => {
			if (valid) {
				this.$confirm(this.getKey('action.isConfirm'), this.getKey('action.tips'), {}).then(() => {
				this.editLoading = true
				let params = Object.assign({}, this.dataForm)
				this.$api.coreStock.UpdatePriorityByCoreId(params).then((res) => {
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
		// 时间格式化
      	dateFormat: function (row, column, cellValue, index){
          	return format(row[column.property])
      	},
		handleEdit: function (params) {	
					this.editDialogVisible = true
					this.dataForm = Object.assign({}, params.row)
				},
		// 时间格式化
      	dateFormatDay: function (row, column, cellValue, index){
          	return formatDay(row[column.property])
      	},
		//获取库房名称
		findWhloc: function () {
			this.$api.corewhloc.findPage().then((res) => {
				this.whLocs = res.data.content
			})
		},
		//加载物料
		findItems: function () {
			this.$api.item.findAll().then((res) => {
				this.Items = res.data			
			})
		},
		//库区
		findAreaTypes: function () {
			this.$api.corewharea.findPage().then((res) => {
				this.areaTypes = res.data.content
			})
		},
		 //获取库房名称
		findWhTypes: function () {
		this.$api.corewh.findPage().then((res) => {
			this.whTypes = res.data.content
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
		areaFormat: function (row, column, cellValue, index) {
			let key = ""
			let propt = column.property;
			let val = row[column.property];
			let dict = this.areaTypes;
			for (let i = 0; i < dict.length; i++) {
				if (dict[i].id == val) {
				return dict[i].areaName;
				}
			}
			return row[column.property]
		},
		whFormat: function (row, column, cellValue, index) {
		let key = ""
		let propt = column.property;
		let val = row[column.property];
		let dict = this.whTypes;
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
		selectionFormat: function (row, column, cellValue, index){
			let key=""
			let propt=column.property;
			if(propt=="pileType"){
				key="trayType"
			}else if(propt=="status" || propt=="stockStatus"){
				key="stockStatus"
			}
			else if(propt=="pkDetailStatus"){
				key="pkStatus"
			}else if(propt=="bussStatus"){
				key="businessStatus"
			}else if(propt=="locked" || propt == "frozen"){
				key="isLocked"
			}else if (propt == "businessStatus") {
				key = "batchStatus";
			} else if (propt == "type") {
				key = "itemType";
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
      	}
	},
	mounted() {
		this.findWhloc();
		this.findAreaTypes();
		this.findItems();
		this.findWhTypes();
	}
}
</script>

<style scoped>

</style>