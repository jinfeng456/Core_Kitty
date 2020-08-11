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
               @findPage="findPage" :showBatchDelete="false" :showOperation="false" :pageRequest="this.pageRequest">
    </kt-table2>   
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

export default {
  components: {
    PopupTreeInput,
    KtTable2,
    KtButton,
    TableColumnFilterDialog,
    SearchSelect
  },
  data () {
    return {
      size: 'small',
      filters: {
        batchNo: ''
      },
      columns: [],
      filterColumns: [],
      pageRequest: { pageNum: 1, pageSize: 8 },
      pageResult: {},
      componentKey: 0,
      myButtons: [{
        name: "handleEdit",
        perms: "core:receiptout:edit",
        label: "action.edit",
        icon: "fa fa-edit"
      }, {
        name: "handleDelete",
        perms: "core:receiptout:delete",
        label: "action.delete",
        type: "danger",
        icon: "fa fa-trash"
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
      gysTypes: []
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
    LODOPL: function () {
                    var LODOP = getLodop();
                        return LODOP;
                        //layer.msg("请下载Lodop插件", { icon: 5 });
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