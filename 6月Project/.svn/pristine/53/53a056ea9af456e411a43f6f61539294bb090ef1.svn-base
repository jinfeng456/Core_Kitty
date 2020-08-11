<template>
  <div class="page-container">
    <!--工具栏-->
    <div class="toolbar"
         style="float:left;padding-top:10px;padding-left:15px;">
      <el-form :inline="true"
               :model="filters"
               :size="size">
        <el-form-item>
          <el-input v-model="filters.vbillcode"
                    :placeholder="$t('field.Purchase.Warehousein.please enter')"></el-input>
        </el-form-item>
        <el-form-item>
          <el-input v-model="filters.gysName"
                    :placeholder="'请输入供应商名称'"></el-input>
        </el-form-item>
        <el-form-item>
          <el-select v-model="filters.status"
                     placeholder="请选择状态"
                     auto-complete="off"
                     style="width: 100%;"
                     clearable>
            <el-option :value="$t('field.Purchase.Warehousein.status1')">
            </el-option>
            <el-option :value="$t('field.Purchase.Warehousein.status2')">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-select v-model="filters.orgcode"
                     :placeholder="'请选择公司'"
                     style="width: 100%;"
                     clearable>
            <el-option v-for="item in dicts.orgcode"
                       :key="item.value"
                       :value="item.value"
                       :label="item.label">
            </el-option>
          </el-select>
        </el-form-item>
      </el-form>
    </div>
    <div class="toolbar"
         style="float:left;padding-top:0px;padding-left:15px;">
      <el-form :inline="true"
               :model="filters"
               :size="size">

        <el-form-item>
          <el-date-picker type="datetime"
                          v-model="filters.beginTime "
                          placeholder="开始时间"
                          value-format="yyyy-MM-dd HH:mm:ss"
                          format="yyyy-MM-dd HH:mm:ss"
                          tyle="width:185px ;">
          </el-date-picker>
        </el-form-item>
        <el-form-item>
          <el-date-picker type="datetime"
                          v-model="filters.endTime "
                          placeholder="结束时间"
                          value-format="yyyy-MM-dd HH:mm:ss"
                          format="yyyy-MM-dd HH:mm:ss"
                          tyle="width:185px ;">
          </el-date-picker>
        </el-form-item>
        <el-form-item>
          <kt-button icon="fa fa-search"
                     :label="$t('action.search')"
                     perms="purchase:warehousein:view"
                     type="primary"
                     @click="findPage(null)" />
        </el-form-item>
        <el-form-item>
          <kt-button icon="fa fa-search"
                     :label="$t('action.Synchronize')"
                     perms="purchase:warehousein:Synchronize"
                     type="primary"
                     @click="synchronize" />
        </el-form-item>
         <el-form-item>
          <kt-button icon="fa fa-plus"
                     :label="$t('action.add')"
                     perms="sys:user:add"
                     type="primary"
                     @click="handleAdd"/>
        </el-form-item>
      </el-form>
    </div>
    <div class="toolbar"
         style="float:right;padding-top:0px;padding-right:15px;">
      <el-form :inline="true"
               :size="size">
        <el-form-item>
          <el-button-group>
            <el-tooltip :content="$t('action.refresh')"
                        placement="top">
              <el-button icon="fa fa-refresh"
                         @click="findPage(null)"></el-button>
            </el-tooltip>
            <el-tooltip :content="$t('action.column')"
                        placement="top">
              <el-button icon="fa fa-filter"
                         @click="displayFilterColumnsDialog"></el-button>
            </el-tooltip>
            <!-- <el-tooltip content="导出" placement="top">
					<el-button icon="fa fa-file-excel-o"></el-button>
				</el-tooltip> -->
          </el-button-group>
        </el-form-item>
      </el-form>
      <!--表格显示列界面-->
      <table-column-filter-dialog ref="tableColumnFilterDialog"
                                  :columns="columns"
                                  @handleFilterColumns="handleFilterColumns">
      </table-column-filter-dialog>
      <table-column-filter-dialog ref="tableColumnFilterDialog"
                                  :columns="detailscolumns"
                                  @handleFilterDetailsColumns="handleFilterDetailsColumns">
      </table-column-filter-dialog>
    </div>
    <!--表格内容栏-->
    <Wt-table :height="350"
              permsdetails="purchase:warehousein:details"
              permstransform="purchase:warehousein:transform"
              permsEdit="purchase:sales:edit"
              :data="pageResult"
              :columns="filterColumns"
              :showTransform="false"
              @findPage="findPage"
              @handledetails="handledetails"
              @handleEdit="handledeEdit">
    </Wt-table>

    <el-dialog :title="$t('action.details')"
               width="90%"
               :visible.sync="dialogVisible"
               :close-on-click-modal="false">
      <KtTableGt :height="500"
                 :data="pageResults"
                 :columns="detailsColumns"
                 @findPage="findDetailsPage"
                 :key="componentKey">
      </KtTableGt>
    </el-dialog>

    <edit-Produce
            :dialogVisible="dialogVisibleAdd"
            :subDataForm="dataForm"
            :operation="operation"
            @receiptHidden="receiptHidden"
            :key="componentKey">
    </edit-Produce>
  </div>
</template>

<script>
import PopupTreeInput from "@/components/PopupTreeInput"
import WtTable from "@/views/Core/WtTable"
import KtTableGt from "@/views/Core/KtTableGt"
import KtButton from "@/views/Core/KtButton"
import TableColumnFilterDialog from "@/views/Core/TableColumnFilterDialog"
import { format } from "@/utils/datetime"
import EditProduce from "./EditProduce"
export default {
  components: {
    PopupTreeInput,
    KtTableGt,
    WtTable,
    KtButton,
    TableColumnFilterDialog,
    EditProduce
  },
  data () {
    return {
      size: 'small',
      filters: {
        name: ''
      },
      componentKey: 0,
      columns: [],
      detailscolumns: [],
      filterColumns: [],
      filterDetailsColumns: [],
      pageRequest: { pageNum: 1, pageSize: 10 },
      pageResult: {},
      pageResults: {},
      dicts: this.$store.state.dict.dicts,
      operation: false, // true:新增, false:编辑
      dialogVisible: false,//明细
      dialogVisibleAdd:false,// 新增编辑界面是否显示
      editLoading: false,
      // 处理明细表格列过滤显示
      detailsColumns: [
        //{ prop: "id", label: "ID", minWidth: 50 },
        //{prop:"deptName", label:"机构", minWidth:120},
        //{ prop: "finshCount", label: "剩余数量", minWidth: 100 },
        { prop: "itemCode", label: "物料编码", minWidth: 120 },
        { prop: "itemName", label: "物料名称", minWidth: 80 },
        { prop: "count", label: "数量", minWidth: 100 },
        { prop: "packUnit", label: "物料单位", minWidth: 120 },
        { prop: "itemSpec", label: "规格", minWidth: 100 },
        //{ prop: "srcSoBillDetail", label: "子Id", minWidth: 120 }
      ],
      // 新增编辑界面数据
      dataForm: {
        soNo: '',
        id: 0,
        stn: '',
        FromCorpBatchNo: '',
        wmsBanchNo: '',
        inType: ''
      },
      //Types: []

    }
  },
  computed: {
    dataFormRules () {
      const dataFormRules = {        name: [{ required: true, message: this.getKey("user.userInput"), trigger: 'blur' }]
      };
      return dataFormRules;
    }
  },
  methods: {
      receiptHidden:function() {
      this.dialogVisibleAdd = false;
      this.findPage(null);
    },
    statusFilter (status) {

      let key = "stn"
      let dict = this.$store.state.dict.dicts[key];
      if (dict == undefined) {
        return status
      }
      for (let i = 0; i < dict.length; i++) {
        if (dict[i].value == status.stn) {
          return dict[i].label;
        }
      }

      return status
    },
    itemFilter: function (row, column, cellValue, index) {

      let propt = column.property;
      let val = row[column.property];
      let dict = this.$store.state.dict.item
      if (dict == undefined) {
        return row[column.property]
      }
      for (let i = 0; i < dict.length; i++) {
        if (dict[i].id == val) {
          return dict[i].name;
        }
      }

      return row[column.property]
    },
    // 获取分页数据
    findPage: function (data) {
      if (data !== null) {
        this.filters.pageNum = data.pageRequest.pageNum
        this.filters.pageSize = data.pageRequest.pageSize
      }
      this.$api.produce.findPage(this.filters).then((res) => {
        this.pageResult = res.data
        this.dialogVisible = false;
        console.log("&&&&&&");
        console.log(this.pageResult);
        console.log("&&&&&&");
      }).then(data != null ? data.callback : '')
    },
    // 获取明细数据
    findDetailsPage: function (data) {
      let params = Object.assign({}, this.dataForm)
      this.$api.produce.findDetailsPage(params).then((res) => {
        this.pageResults = { content: res.data }
        console.log("99999");
        console.log(this.pageResults);
        console.log("99999");
      }).then(data != null ? data.callback : '')
    },
    //同步
    synchronize: function (data) {
      if (this.filters.orgcode == null) {
        alert("公司不能为空");
      }
      else if (this.filters.beginTime == null) {
        alert("开始时间不能为空");
      }
      else if (this.filters.endTime == null) {
        alert("结束时间不能为空");
      }
      else if (this.filters.beginTime > this.filters.endTime) {
        alert("开始时间不能大于结束时间");
      } else {
        this.$api.produce.synchronize(this.filters).then((res) => {
          if (res.code == 200) {
            this.$message({ message: this.getKey('action.operateSucess'), type: 'success' })
          } else {
            this.$message({ message: this.getKey('action.operateFail') + res.msg, type: 'error' })
          }
          this.findPage(null)
        })
      }
    },
    // 批量删除
    handleDelete: function (data) {
      this.$api.corewh.batchDelete(data.params).then(data != null ? data.callback : '')
    },
    // 显示新增界面
    handleAdd: function () {
      this.componentKey += 1;
      this.dialogVisibleAdd = true
      this.operation = true
      this.dataForm = {
        soNo: '',
        id: 0,
        stn: '',
        FromCorpBatchNo: '',
        wmsBanchNo: '',
        inType: ''
        // Types: ['1', '2']
      }
    },
    // 显示明细界面
    handledetails: function (params) {
      this.componentKey += 1;
      this.dialogVisible = true
      this.dialogVisibleAdd=false;
      this.dataForm = Object.assign({}, params.row)
    },
            // 显示编辑界面
    handledeEdit: function (params) {
      this.dialogVisibleAdd = true
      this.operation = false
      this.dataForm = Object.assign({}, params.row)
    },
    // 提交
    submitForm: function () {
      this.$refs.dataForm.validate((valid) => {
        if (valid) {
          this.$confirm(this.getKey('action.isConfirm'), this.getKey('action.tips'), {}).then(() => {
            this.editLoading = true
            let params = Object.assign({}, this.dataForm)
            this.$api.produce.save(params).then((res) => {
              this.editLoading = false
              if (res.code == 200) {
                this.$message({ message: this.getKey('action.operateSucess'), type: 'success' })
                this.$refs['dataForm'].resetFields()
              } else {
                this.$message({ message: this.getKey('action.operateFail') + res.msg, type: 'error' })
              }
              this.findPage(null)
            })
          })
        }
      })
    },
    // 获取部门列表
    findDeptTree: function () {
      this.$api.dept.findDeptTree().then((res) => {
        this.deptData = res.data
      })
    },
    // 菜单树选中
    deptTreeCurrentChangeHandle (data, node) {
      this.dataForm.deptId = data.id
      this.dataForm.deptName = data.name
    },
    // 时间格式化
    dateFormat: function (row, column, cellValue, index) {
      return format(row[column.property])
    },
    // 处理表格列过滤显示
    displayFilterColumnsDialog: function () {
      this.$refs.tableColumnFilterDialog.setDialogVisible(true)
    },
    // 处理表格明细列过滤显示
    displayFilterDetailsColumnsDialog: function () {
      this.$refs.tableColumnFilterDialog.setDialogVisible(true)
    },
    // 处理表格列过滤显示
    handleFilterColumns: function (data) {
      this.filterColumns = data.filterColumns
      this.$refs.tableColumnFilterDialog.setDialogVisible(false)
    },
    // 处理表格明细列过滤显示
    handleFilterDetailsColumns: function (data) {
      this.filterDetailsColumns = data.filterDetailsColumns
      this.$refs.tableColumnFilterDialog.setDialogVisible(false)
    },
    getKey: function (arg) {
      return this.$t(arg)
    },
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
    initColumns: function () {
      this.columns = [
        //{ prop: "id", label: "ID", minWidth: 50 },
        //{prop:"deptName", label:"机构", minWidth:120},
        { prop: "soNo", label: "field.Purchase.Warehousein.soNo", minWidth: 100 },
        { prop: "applicantName", label: "field.Purchase.Warehousein.gysName", minWidth: 100 },
        // { prop: "srcSoBill", label: "field.Purchase.Warehousein.srcSoBill", minWidth: 120 },
        { prop: "status", label: "field.Purchase.Warehousein.status", minWidth: 80 , formatter: this.selectionFormat},
        // { prop: "createDate", label: "field.Purchase.Warehousein.createDate", minWidth: 120, formatter: this.dateFormat },
        //{ prop: "finshDate", label: "field.Purchase.Warehousein.finshDate", minWidth: 100, formatter: this.dateFormat },
      ]
      this.filterColumns = this.columns;
    },

  },
  mounted () {
    //this.findDeptTree()
    this.initColumns()
    //this.initDetailsColumns()
  }
}
</script>

<style scoped>
</style>
