<template>
  <div class="page-container">
    
    <!--工具栏-->
    <div class="toolbar" style="float:left;padding-top:10px;padding-left:15px;">
      <el-form :inline="true"
               :model="filters"
               :size="size">
        <el-form-item>
          <el-input v-model="filters.receiptNo"
                    :placeholder="'请输入入库单号'"
                    clearable  style="width: 175px;">
            </el-input>
        </el-form-item>
         <el-form-item>
         <search-select :itemlist="this.gysTypes" style="width: 175px;"
                  placeholder="输入框"
                 @itemChange="itemclick" > 
        </search-select>    
      </el-form-item>
       
        <el-form-item>
          <el-select v-model="filters.inType"
                     :placeholder="'请选择入库类型'"
                     style="width: 175px;"
                      clearable>
            <el-option v-for="item in dicts.inType"
                       :key="item.value"
                       :value="item.value"
                       :label="item.label">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-select v-model="filters.stn"
                     :placeholder="'请选择站台号'"
                     style="width:175px;"
                     clearable>
            <el-option v-for="item in dicts.stnOut"
                       :key="item.value"
                       :value="item.value"
                       :label="item.label">
            </el-option>
          </el-select>
        </el-form-item>
           
      </el-form>
    </div>
    <div class="toolbar" style="float:left;padding-top:0px;padding-left:15px;">
		<el-form :inline="true" :model="filters" :size="size">	
		<el-form-item>
          <el-date-picker type="datetime"
                          v-model="filters.createBeginTime "
                          placeholder="创建开始时间"
                          value-format="yyyy-MM-dd"
                          format="yyyy-MM-dd"
                          :style="{width: '175px'}">
          </el-date-picker>
        </el-form-item>
        <el-form-item>
          <el-date-picker type="datetime"
                          v-model="filters.createEndTime "
                          placeholder="创建结束时间"
                          value-format="yyyy-MM-dd"
                          format="yyyy-MM-dd"
                          :style="{width: '175px'}">
          </el-date-picker>
        </el-form-item>	
		<el-form-item>
          <el-date-picker type="datetime"
                          v-model="filters.finishBeginTime "
                          placeholder="完成开始时间"
                          value-format="yyyy-MM-dd"
                          format="yyyy-MM-dd"
                          :style="{width: '175px'}">
          </el-date-picker>
        </el-form-item>
        <el-form-item>
          <el-date-picker type="datetime"
                          v-model="filters.finishEndTime "
                          placeholder="完成结束时间"
                          value-format="yyyy-MM-dd"
                          format="yyyy-MM-dd"
                          :style="{width: '175px'}">
          </el-date-picker>
        </el-form-item>
			<el-form-item>
				<el-form-item>
          <kt-button icon="fa fa-search"
                     :label="$t('action.search')"
                     perms="sys:user:view"
                     type="primary"
                     @click="findPage(null)" />
        </el-form-item>  
			</el-form-item>	
		</el-form>
	</div>
    <div class="toolbar" style="float:right;padding-top:0px;padding-right:0px;">
      <el-form :inline="true"
               :size="size">
        <el-form-item>
          <el-button-group>
            <el-tooltip content="导出Excel" placement="top">
						<el-button icon="fa fa-file-excel-o" @click="exportExcel" /> 
					</el-tooltip>        
          </el-button-group>
        </el-form-item>
      </el-form>
      <!--新增编辑界面-->
	<el-dialog title="添加货物明细" width="40%" :visible.sync="editDialogVisible" 
	:close-on-click-modal="false">
		<el-form :model="dataForm" label-width="90px" ref="dataForm" :rules="dataFormRules"  :size="size">
		
			<el-form-item label="添加数量" prop="addCount">
				<el-input v-model="dataForm.addCount" :placeholder="'请添加货物数量'" auto-complete="off"></el-input>
			</el-form-item>
      	<el-form-item label="条码数量" prop="codeCount">
				<el-input v-model="dataForm.codeCount" :placeholder="'请添加条码数量'" auto-complete="off"></el-input>
			</el-form-item>
		</el-form>
		<div slot="footer" class="dialog-footer">
			<el-button :size="size" @click.native="editDialogVisible = false">{{$t('action.cancel')}}</el-button>
			<el-button :size="size" type="primary" @click.native="submitForm" :loading="editLoading">{{$t('action.submit')}}</el-button>
		</div>
	</el-dialog>
      <!--表格显示列界面-->
      <table-column-filter-dialog ref="tableColumnFilterDialog"
                                  :columns="columns"
                                  @handleFilterColumns="handleFilterColumns">
      </table-column-filter-dialog>
    </div>
    <!--表格内容栏-->
    <kt-table2 :myButtons="myButtons"
               :data="pageResult"
               :columns="filterColumns"
               @findPage="findPage" 
               @handleEdit="handleEdit"
               @handleEdit1="handleEdit1"
               :pageRequest="this.pageRequest">
    </kt-table2>   
      <print-code :itemDialogVisible="itemDialogVisible"
                 @handleSelect="handleSelect"
                 @itemHidden="itemHidden"
                 :wmsBanchNo="this.dataForm.wmsBanchNo"
                  :key="this.dataForm.wmsBanchNo"
                 >
      </print-code>
  </div>

</template>

<script>
import PopupTreeInput from "@/components/PopupTreeInput"
import KtTable2 from "@/views/Core/KtTable2"
import SearchSelect from "@/views/Core/SearchSelect"
import KtButton from "@/views/Core/KtButton"
import TableColumnFilterDialog from "@/views/Core/TableColumnFilterDialog"
import { format } from "@/utils/datetime"
import { getLodop } from "@/utils/LodopFuncs"
import { export_json_to_excel } from "@/excel/Export2Excel"
import PrintCode from "@/views/Core/PrintCode"
export default {
  components: {
    PopupTreeInput,
    KtTable2,
    KtButton,
    TableColumnFilterDialog,
    SearchSelect,
    PrintCode
  },

  data () {
     let validatorIdNumber1 =  (rule, value, callback) =>{
  
      if(!value){
        callback()
      }
      else  if(value>50) {
            return callback(new Error ('一次最多打印50张条码'))
        }
        
		else {
  
           callback()
        }
    }
    return {
      size: 'small',
      filters: {
        batchNo: ''
      },
      itemDialogVisible:false,
      dataForm: {
			  id: 0,
      },
      editDialogVisible: false, // 新增编辑界面是否显示
      columns: [],
      filterColumns: [],
      pageRequest: { pageNum: 1, pageSize: 8 },
      pageResult: {},
      pageResult1:{},
      componentKey: 0,
      myButtons: [{
        name: "handleEdit",
        perms: "core:receiptout:edit",
        label: "添加",
        icon: "fa fa-edit"
      },
      {
        name: "handleEdit1",
        perms: "core:receiptout:edit",
        label: "查看",
        icon: "fa fa-edit"
      }],

      dialogVisible1: false, // 新增编辑界面是否显示
      editLoading: false,
      dicts: this.$store.state.dict.dicts,
      deptData: [],
      deptTreeProps: {
        label: 'name',
        children: 'children'
      },
      roles: [],
      gysTypes: [],
       dataFormRules: {
                    codeCount:[{required: true,trigger: 'blur',validator: validatorIdNumber1}],
                   
                   
                },
    }
  },
  computed: {

  },

  methods: {
    
    // 获取分页数据
    itemclick:function(data){
      //debugger
      if (data.length!=0){
        this.filters.fromCorpName=data.name
      }else{
        this.filters.fromCorpName=""
      }
    },
    findPage:function (data) {
      if(data!==null){
				this.filters.pageNum=data.pageRequest.pageNum		
			}else{
				this.filters.pageNum=1
			}
			this.filters.pageSize=this.pageRequest.pageSize
      this.$api.receiptIn.FindReportPage(this.filters).then((res) => {    
        this.pageResult = res.data
      }).then(data != null ? data.callback : '')
    },
       handleSelect: function (data) {
           this.dataForm = Object.assign({}, data.row)
           alert(this.dataForm.countDB)
       
    },
    LODOPL: function () {
                    var LODOP = getLodop();
                        return LODOP;
                        //layer.msg("请下载Lodop插件", { icon: 5 });
    },
    submitForm: function () {
			this.$refs.dataForm.validate((valid) => {
			if (valid) {
    //alert(this.dataForm.package_Spec)
				this.$confirm(this.getKey('action.isConfirm'), this.getKey('action.tips'), {}).then(() => {
				this.editLoading = true
				let data = Object.assign({}, this.dataForm)
				this.$api.coreStock.InsertStockDetail(data).then((res) => {
						this.editLoading = false
						if (res.code == 200) {
            
         let dict =this.$store.state.dict.dicts["systenParam"];
         let dataForm ={baseUrl:dict[0].descriptions, dataArr: res.data}
      	
   		this.$api.CodePrints.code(dataForm).then((res) => {
         	})
						this.$message({ message: this.getKey('action.operateSucess'), type: 'success' })
						/* this.dialogVisibles = true
						this.$refs['dataForm'].resetFields() */
						} else {
						this.$message({ message: this.getKey('action.operateFail') + res.msg, type: 'error' })
            }
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
    //导出的方法
		exportExcel() {
      	this.filters.pageSize=-1
        require.ensure([], () => {	
          this.$api.receiptIn.FindReportPage(this.filters).then((res) => {			
          const tHeader = ['单号', '内部批次号', '物料名称','完成数量','单位', '创建时间', '完成时间'];
          const filterVal = ['receiptNo', 'wmsBanchNo', 'itemName','finshCount','packUnit','beginTime', 'finishTime'];				
          const list = res.data;    
          const data = this.formatJson(filterVal, list);
          export_json_to_excel(tHeader, data, '入库单导出');
          })
        })
      },
    formatJson(filterVal, tableData) {
			return tableData.map(v => {
				return filterVal.map(j => {
						return v[j]
					})
				}
			)
		},
    selectionFormat: function (row, column, cellValue, index) {
      let key = ""
      let propt = column.property;
      let val = row[column.property];
      let dict = this.gysTypes;
      for (let i = 0; i < dict.length; i++) {
        if (dict[i].name == val) {
          return dict[i].name;
        }
      }
      return row[column.property]
    }, 
    findgysTypes: function () {
      this.$api.corewhgro.findPage().then((res) => {
        this.gysTypes = res.data.content
      })
    },
    
     // 显示添加界面
		handleEdit: function (params) {	
			this.editDialogVisible = true
			this.dataForm = Object.assign({}, params.row)
    },
       // 显示查看界面
		handleEdit1: function (params) {	
      //this.editDialogVisible = true
      	this.dataForm = Object.assign({}, params.row)
        
      this.itemDialogVisible=true

    },
     itemHidden: function () {
      this.itemDialogVisible = false;
    
    },
    // 时间格式化
    dateFormat: function (row, column, cellValue, index) {
      return format(row[column.property])
    },
    //字典
    selectionFormat: function (row, column, cellValue, index) {
      let key = ""
      let propt = column.property;
      if (propt == "stn") {
        key = "stnOut"
      } else if (propt == "inType") {
        key = "inType"
      } else if (propt == "status") {
        key = "status"
      }

      let val = row[column.property];
      let dict = this.$store.state.dict.dicts[key];
      if (dict == undefined) {
        return row[column.property]
      }
      for (let i = 0; i < dict.length; i++) {
        if (dict[i].value == val) {
          return dict[i].label;
        }
      }  

      return row[column.property]
    },
    // 处理表格列过滤显示
    displayFilterColumnsDialog: function () {
      this.$refs.tableColumnFilterDialog.setDialogVisible(true)
    },
    // 处理表格列过滤显示
    handleFilterColumns: function (data) {
      this.filterColumns = data.filterColumns
      this.$refs.tableColumnFilterDialog.setDialogVisible(false)
    }
  },
  created () {
    this.findgysTypes()

  },
  mounted () {
    this.columns = [
     
      { prop: "receiptNo", label: "入库单号", minWidth: 120 },
      { prop: "itemName", label: "物料名称", minWidth: 120 },
      { prop: "finshCount", label: "完成数量", minWidth: 120 },
      { prop: "packUnit", label: "单位", minWidth: 120 },    
      { prop: "fromCorpBatchNo", label: "供应商批号", minWidth: 120 },
      { prop: "wmsBanchNo", label: "内部批号", minWidth: 100 },
      { prop: "stn", label: "field.stn", minWidth: 100, formatter: this.selectionFormat },
      { prop: "inType", label: "入库类型", minWidth: 100, formatter: this.selectionFormat },
      { prop: "fromCorpName", label: "供应商名称", minWidth: 70, minWidth: 120, formatter: this.selectionFormat },
      { prop: "status", label: "状态", minWidth: 120, formatter: this.selectionFormat },
      //{ prop: "fromCorpId", label: "供应商主键", minWidth: 120},
      { prop: "beginTime", label: "beginTime", minWidth: 140, formatter: this.dateFormat },
      { prop: "finshTime", label: "finshTime", minWidth: 140, formatter: this.dateFormat }

    ]
    this.filterColumns = this.columns;
  }
}
</script>

<style scoped>
</style>