<template>
  <div class="page-container">
	<!--新增编辑界面-->
	<el-dialog :title="operation?'批次出库-新增':'批次出库-编辑'" width="80%" :visible.sync="dialogVisible" :close-on-click-modal="false" @opened="getDetials"  :before-close="handleClose" >
		<el-form :model="subDataForm" label-width="200px" :rules="dataFormRules" ref="dataForm" size="mini"
			label-position="right">
			<el-row>
				<el-col :span="8">
					<el-form-item label="ID" prop="id" v-if="false">
						<el-input v-model="subDataForm.id" disabled="true" auto-complete="off"></el-input>
					</el-form-item>
				
					<el-form-item :label="$t('field.receipt.receiptNo')" prop="receiptNo">
						<el-input v-model="subDataForm.receiptNo" auto-complete="off"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="8">
					<el-form-item :label="$t('field.receipt.outType')" prop="outType" >
						<el-select v-model="subDataForm.outType"  style="width: 100%;" disabled="false">
							<el-option v-for="item in dicts.outTypeBatch" :key="item.value"
								:label="item.label" :value="item.value">
							</el-option>
						</el-select>
					</el-form-item>
				</el-col>
				<el-col :span="8">
					<el-form-item :label="$t('field.receipt.stn')"  prop="stn" >
						<el-select v-model="subDataForm.stn"  :placeholder="$t('action.select')" style="width: 100%;">
							<el-option v-for="item in dicts.stnOut" :key="item.value"  :value="item.value"
								:label="item.label">
							</el-option>
						</el-select>
					</el-form-item>
				
				</el-col>
			</el-row>
			<el-row>
						
				<el-col :span="8">
					<el-form-item :label="$t('field.receipt.priority')" prop="priority">
						<el-select v-model="subDataForm.priority"  :placeholder="$t('action.select')" style="width: 100%;">
							<el-option v-for="item in dicts.priority" :key="item.value"
								:label="item.label" :value="item.value">
							</el-option>
						</el-select>
					</el-form-item>
				</el-col>
				<el-col :span="8">
					<el-form-item label="分拣类型" prop="pickType">
						<el-select v-model="subDataForm.pickType"  :placeholder="$t('action.select')" style="width: 100%;">
							<el-option v-for="item in dicts.pickType" :key="item.value"
								:label="item.label" :value="item.value">
							</el-option>
						</el-select>
					</el-form-item>
				</el-col>
			</el-row>
		</el-form>
		<div slot="footer" class="dialog-footer">
			<el-button :size="size" @click.native="handleHiddenOut">{{$t('action.cancel')}}</el-button>
			<el-button :size="size" type="primary" @click.native="submitForm" :loading="editLoading">{{$t('action.submit')}}</el-button>
			<el-button icon="el-icon-edit" :size="size"  @click.native="handleAddDetailEdit"  >选择批次 </el-button>

		</div>

		<div v-show="operation">
			<div class="app-container">
				<el-table v-loading="listLoading" :data="list" height="250" border fit highlight-current-row style="width: 100%"  size="mini"  @cell-click="clickTable"   @selection-change="handleSelectionChange" >			
					<el-table-column type="selection" label="选择" align="center" width="55" ></el-table-column>
					<el-table-column width="120px" align="center" :label="$t('field.stn')"   fixed="right" prop="stn" key="stn"  header-align="center" :formatter="statusFilter"></el-table-column>
					<el-table-column width="120px" align="center" label="内部批号"   fixed="right" prop="batchNo" key="batchNo"  header-align="center" ></el-table-column>
					<el-table-column class-name="status-col"  :label="$t('field.itemName')"    min-width="110" prop="itemId"  align="center" fixed="right"  header-align="center"  :formatter="itemFilter"></el-table-column>
					<el-table-column width="200px"   :label="$t('field.planCount')"    align="center"  fixed="right"  header-align="center" >
						<template slot-scope="{row}"  >
							<template v-if="row.edit">
								<el-input v-model="row.planCount" class="edit-input" size="mini"  />
							</template>
							<span  style="cursor: pointer;" v-else  >{{ row.planCount }}</span>
						</template>
					</el-table-column>
					<el-table-column align="center" :label="$t('action.edit')" width="120" fixed="right" >
							<template slot-scope="{row}">
							<el-button v-if="row.edit" type="success" size="mini"  @click="confirmEdit(row)" icon="el-icon-circle-check-outline" > {{$t('action.comfirm')}} 
							</el-button>
							<el-button v-else type="primary" size="mini" icon="el-icon-edit" @click="row.edit=!row.edit" >   {{$t('action.edit')}} 
							</el-button>
							</template>
					</el-table-column>
					<el-table-column :label="$t('action.operation')" width="105" fixed="right"  header-align="center" align="center">	
						<template slot-scope="scope">
						<kt-button icon="fa fa-trash" :label="$t('action.delete')" perms="core:receiptout:delete" :size="size" type="danger" @click="handleDelete(scope.$index, scope.row)" />
						</template>
					</el-table-column>
		
				</el-table>
				
			</div>
		</div>
	 <!-- <stock-show-table :key="componentKey"  :itemDialogVisible="stockDialogVisible" @handleSelect="StockSelects"    @itemHidden="itemHidden" :multipleTable="this.multipleTable" :showReceipOutId="this.showReceipOutId" ></stock-show-table>  -->
	</el-dialog>
	  <batch-select :key="componentKey"  :itemDialogVisible="itemDialogVisible" @handleSelect="handleSelect"  @itemHidden="itemHidden"  ></batch-select> 
      <!-- <stock-select :key="componentKey"  :itemDialogVisible="stockDialogVisible" @handleSelect="StockSelects"    @itemHidden="itemHidden" :multipleTable="this.multipleTable" :showReceipOutId="this.showReceipOutId"></stock-select> -->
  </div>
</template>

<script>
import KtTableList from "@/views/Core/KtTableList"
import KtButton from "@/views/Core/KtButton"
import { format } from "@/utils/datetime"
// import StockSelect from "@/views/Receipt/ReceiptOut/CheckOut/StockSelect"
import BatchSelect from "./BatchSelect"
export default {
	name: 'EditReceiptOut',
	components:{
		KtTableList,
		KtButton,
		// StockSelect,
		BatchSelect
	},
	filters: {
	
  },
	props:{
		subDataForm:{
			type: Object
		},
	    dialogVisible:{
			type: Boolean
		},
		operation:{
			type: Boolean
		}
	},
	
	data() {
		return {
			size: 'mini',
			   listLoading: false,
			list:[],
			Items: [],	
		    componentKey: 0,
			pageResult: {},
      		multipleTable: [],     //存放选中值的数组
			editLoading: false,
			pageRequest: { pageNum: 1, pageSize: 1000 },
			pageziRequest: { pageziNum: 1, pageziSize: 3 },
			itemDialogVisible:false,
			stockDialogVisible:false,
			dicts:this.$store.state.dict.dicts,
			detailId:undefined,
			showReceipOutId:false,
			orderDetailData:null,
			filters: {
					boxCode: '',
				},
		}
	},
	computed: {
		dataFormRules() {
					const dataFormRules= {
						stn:[{ required: true, message: "请输入站台号", trigger: 'blur' }]
						};
					return dataFormRules;
			}		
	},
	methods: {
			
			confirmEdit(row) {
						//row.edit = false
						this.$api.receipt.updateDetials({id:row.id,planCount:row.planCount,receiptId: row.receiptId}).then((res) => {
						if (res.code == 200) {
							this.getDetials();
							} else {
							this.$message({ message: this.$t('action.operateFail') + res.msg, type: 'error' })
							this.getDetials();
							} 
						})				
				},
			statusFilter(status) {

			let key="stnOut"
			let dict = this.$store.state.dict.dicts[key];
			if(dict==undefined){
					return status
			}
			for(let i=0;i<dict.length;i++){
				if(dict[i].value==status.stn){
					return dict[i].label;
				}
			}

          	return status
		},
		clickTable:function(row, column, cell, event){//展开事件日志列表
		//alert("asdf")
		},
		handleSelectionChange(val) {
			this.multipleTable = val;   
			this.detailId=val.map(item => item.id).toString();            //  this.multipleTable 选中的值
			console.log(val);
			console.log(this.detailId);
		},
		//绑定托盘
		handleShowStockBind: function () {			
			this.stockDialogVisible = true
			this.showReceipOutId=false
			this.componentKey += 1; 
		},
		//查看绑定
		handleShowStock: function () {		
			this.stockDialogVisible = true
			this.showReceipOutId=true
			this.componentKey += 1; 
		},		
		//加载物料
		findItems: function () {
			this.$api.item.findAll().then((res) => {
				this.Items = res.data			
			})
		},
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
		// 换页刷新
		refreshPageRequest: function (pageNum) {
			//debugger
			this.filters.pageNum = pageNum
			this.$api.coreStock.QueryCoreStockDetailPage(this.filters).then((res) => {
				this.orderDetailData = res.data
			})
		},
		handleDelete:function(index,row){
			this.$confirm('确认删除选中记录吗？', '提示', {
				type: 'warning'
			}).then(() => {
					this.$api.receipt.deleteDetial({ id: row.id, receiptId: row.receiptId}).then((res) => {
					if (res.code == 200) {
                  	this.getDetials();
					} else {
					this.$message({ message: this.$t('action.operateFail') + res.msg, type: 'error' })
					this.getDetials();
					} 
				})
			}).catch(() => {
			})			
		},
		handleSelect:function(data){
		 	this.$api.receipt.saveDetialsByBatch({id:this.subDataForm.id,items:data}).then((res) => {
				if(res.code == 200) {
								this.itemHidden();
								this.getDetials();
							} else {
								this.$message({message: this.$t('action.operateFail') + res.msg, type: 'error'})
								this.itemHidden();
								this.getDetials();
							}
			})
	
		},
		StockSelects:function(data){
		 	this.$api.coreStock.UpdateRecepitOutId({id:this.detailId,items:data}).then((res) => {	
				 if(res.code == 200) {
								this.$message({ message: this.$t('action.operateSucess'), type: 'success' })
									this.itemHidden();
									this.getDetials();
							} else {
								this.$message({message: this.$t('action.operateFail') + res.msg, type: 'error'})
							}				
			})
	
		},
		handleClose:function(done){
		  this.$emit('receiptHidden', {})
 			done();
		},
		itemHidden:function(){
			this.itemDialogVisible=false;
			this.stockDialogVisible=false;
		},
		// 获取分页数据
		 getDetials :function() {
			if(this.subDataForm==undefined||this.subDataForm.id==undefined||this.subDataForm.id==0){
				return;
			}
			this.listLoading = true
			this.$api.receipt.getDetials(this.subDataForm).then((res) => {
				

 			const items = res.data
			this.list = items.map(v => {
				this.$set(v, 'edit', false) 
				return v
			})
				

			    this.listLoading = false
			})
		},
		
	
		handleAddDetailEdit: function () {
			this.componentKey += 1; 
			if (this.subDataForm.status == 1) {
			this.itemDialogVisible = true
			} else {
			this.$message({ message: "出库单非待执行状态无法添加明细", type: 'error' })
			}			
		},
		handleHiddenOut: function (params) {
			this.$emit('receiptHidden', {})
		},		
		// 编辑
		submitForm: function () {
			if (this.subDataForm.status == 2 || this.subDataForm.status == 3) {
        		this.$message({ message: "出库单非待执行状态无法修改", type: 'error' })
      		} else {
				this.$refs.dataForm.validate((valid) => {
					if (valid) {
						this.$confirm(this.$t('action.isConfirm'), this.$t('action.tips'), {}).then(() => {
								this.editLoading = true
							let params = Object.assign({}, this.subDataForm)
							
							this.$api.receipt.saveReceiptOut(params).then((res) => {
								this.editLoading = false
								if(res.code == 200) {
									this.subDataForm.id = res.data.id;
									this.subDataForm.status = 1;
									this.subDataForm.receiptNo = res.data.receiptNo;
									this.$message({ message: this.$t('action.operateSucess'), type: 'success' })
									//this.handleHiddenOut();
									//this.$refs['dataForm'].resetFields()
								} else {
									this.$message({message: this.$t('action.operateFail') + res.msg, type: 'error'})
								}
							
							})								
						})
					}
				})
	  		}
		}

	},	
	mounted() {
	 //this.refreshPageRequest(1)
	 this.findItems()
	}
}
</script>

<style scoped>
	
</style>