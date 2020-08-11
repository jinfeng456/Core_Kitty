<template>
  <div class="page-container">
    <!--工具栏-->
    <div class="toolbar"
         style="float:left;padding-top:10px;padding-left:15px;">
      <el-form :inline="true"
               :model="filters"
               :size="size">
        <el-form-item>
          <el-input v-model="filters.receiptNo"
                    :placeholder="'请输入入库单号'"
                    clearable>
            </el-input>
        </el-form-item>
         <el-form-item>
         <search-select :itemlist="this.gysTypes" style="width: 150px;"
                  placeholder="输入框"
                 @itemChange="itemclick">
        </search-select>
      </el-form-item>

        <el-form-item>
          <el-select v-model="filters.inType"
                     :placeholder="'请选择入库类型'"
                     style="width: 150px;"
                     disabled="false">
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
                     style="width:150px;"
                     clearable>
            <el-option v-for="item in dicts.stnOut"
                       :key="item.value"
                       :value="item.value"
                       :label="item.label">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item>
          <kt-button icon="fa fa-search"
                     :label="$t('action.search')"
                     perms="sys:user:view"
                     type="primary"
                     @click="findPage(null)" />
        </el-form-item>
        <el-form-item>
          <kt-button icon="fa fa-plus"
                     :label="$t('action.add')"
                     perms="sys:user:add"
                     type="primary"
                     @click="handleAdd" />
        </el-form-item>
        <el-form-item>
				<!-- handlePreview -->
				<kt-button icon="fa fa-plus" label="预览" perms="core:CheckOut:add" type="primary" @click="handlePreview" />
			</el-form-item>
      </el-form>
    </div>
    <div class="toolbar"
         style="float:right;padding-top:10px;padding-right:15px;">
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
    <kt-table2 permsEdit="core:receiptout:edit"
               permsDelete="core:receiptout:delete"
               :myButtons="myButtons"
               :data="pageResult"
               :columns="filterColumns"
               @findPage="findPage"
               @handleEdit="handleEdit"
               @handleDelete="handleDelete" :pageRequest="this.pageRequest">
    </kt-table2>
    <edit-receipt-in :subDataForm="dataForm"
                      :inType="this.filters.inType"
                     :dialogVisible="dialogVisible1"
                     :operation="operation"
                     @receiptHidden="receiptHidden"
                     :key="componentKey">
    </edit-receipt-in>
  </div>

</template>

<script>
import PopupTreeInput from "@/components/PopupTreeInput"
import KtTable2 from "@/views/Core/KtTable2"
import SearchSelect from "@/views/Core/SearchSelect"
import KtButton from "@/views/Core/KtButton"
import TableColumnFilterDialog from "@/views/Core/TableColumnFilterDialog"
import { format } from "@/utils/datetime"
import EditReceiptIn from "./EditReceiptIn"
import { getLodop } from "@/utils/LodopFuncs"
export default {
  components: {
    PopupTreeInput,
    KtTable2,
    KtButton,
    TableColumnFilterDialog,
    EditReceiptIn,
    SearchSelect
  },
  data () {
    return {
      size: 'small',
      filters: {
        batchNo: '',
        inType:parseInt(this.$route.path.substr(this.$route.path.lastIndexOf('/')+1))
      },
      columns: [],
      filterColumns: [],
      pageRequest: { pageNum: 1, pageSize: 7 },
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

      operation: false, // true:新增, false:编辑
      dialogVisible1: false, // 新增编辑界面是否显示
      editLoading: false,
      dicts: this.$store.state.dict.dicts,
      // 新增编辑界面数据
      dataForm: {
        id: 0,
        name: '',
        passwords: '123456',
        deptId: 1,
        deptName: '',
        email: 'test@qq.com',
        mobile: '13889700023',
        userstatus: 1,
        userRoles: [],
        inType:parseInt(this.$route.path.substr(this.$route.path.lastIndexOf('/')+1))

      },
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
    receiptHidden:function() {

      this.dialogVisible1 = false;
      this.findPage(null);
    },
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
      this.$api.receiptIn.findReceiptInPage(this.filters).then((res) => {
        this.pageResult = res.data
      }).then(data != null ? data.callback : '')
    },
    LODOPL: function () {
                    var LODOP = getLodop();
                        return LODOP;
                        //layer.msg("请下载Lodop插件", { icon: 5 });
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
    handlePreview: function () {
			//debugger
			this.$api.receiptIn.findReceiptInPage(this.filters).then((res) => {
				//this.stockInList = res.data.content
				//for (let index = 0; index < res.data.totalSize; index++) {
					this.$api.receiptIn.Preview(res.data.content[0]).then((res) => {
				  var strList=res.data;
					var html = strList.html;

						if (strList.inList.length > 0) {
								    html = html.replace("{receiptNo}", strList.inList[0].receiptNo);
								    //html = html.replace("{srcSoNo}", (strList.inList[0].srcSoNo==null ?'':strList.stockInList[0].srcSoNo));
								    html = html.replace("{fromCorpCode}", strList.inList[0].fromCorpName);
								    html = html.replace("{fromCorpName}", strList.inList[0].fromCorpName);
								}
								var detail = "";
								if (strList.inDetailList.length > 0) {
								    for (let index = 0; index < strList.inDetailList.length; index++) {
								        detail += "<tr>";
								        detail += "<td>" + (strList.inDetailList[index].wmsBanchNo==null?'':strList.inDetailList[index].wmsBanchNo) + "</td>";
								        detail += "<td>" + (strList.inDetailList[index].itemName==null?'':strList.inDetailList[index].itemName) + "</td>";
								        detail += "<td>" + (strList.inDetailList[index].planCount==null?0:strList.inDetailList[index].planCount) + "</td>";
								        detail += "<td>" + (strList.inDetailList[index].finishCount==null?0:strList.inDetailList[index].finishCount) + "</td>";
								        detail += "<td>" + (strList.inDetailList[index].stn==null?'':strList.inDetailList[index].stn) + "</td>";
								        detail += "<td>" + (strList.inDetailList[index].packUnit==null?'':strList.inDetailList[index].packUnit) + "</td>";
								        detail += "<td>" + (strList.inDetailList[index].createTime==null?'':strList.inDetailList[index].createTime) + "</td>";
								        // detail += "<td>" + "AName" + "</td>";
								        // detail += "<td>" + "AuditinTime" + "</td>";
								        detail += "</tr>";
								    }
								}
								html = html.replace("{Content}", detail);
								var LODOP = this.LODOPL();
									LODOP.PRINT_INIT("");
									LODOP.NewPage();
									LODOP.PRINT_INIT("入库单")
									LODOP.ADD_PRINT_HTM(0, 100, "100%", "100%", html);
									//if (type === 1) {
										LODOP.PREVIEW();
										//LODOP.PRINT_DESIGN();
									// } else {
									//     LODOP.PRINT();
									// }

				})

				//}

            })

		},
    findgysTypes: function () {
      this.$api.corewhgro.findPage().then((res) => {
        this.gysTypes = res.data.content
      })
    },
    // 批量删除
    handleDelete: function (data) {
        this.$api.receiptIn.batchDelete(data.params).then(data != null ? data.callback : '')
    },
    // 显示新增界面
    handleAdd: function () {
      this.componentKey += 1;
      this.dialogVisible1 = true
      this.operation = true
      this.dataForm = {
        id: 0,
        name: '',
        passwords: '',
        deptId: 1,
        deptName: '',
        inType:parseInt(this.$route.path.substr(this.$route.path.lastIndexOf('/')+1))

      }
    },
    // 显示编辑界面
    handleEdit: function (params) {
      this.dialogVisible1 = true
      this.operation = false
      this.dataForm = Object.assign({}, params.row)
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
      //{ prop: "fromCorpBatchNo", label: "供应商批号", minWidth: 100 },
      //{ prop: "wmsBanchNo", label: "内部批号", minWidth: 100 },
      { prop: "stn", label: "field.stn", minWidth: 100, formatter: this.selectionFormat },
      { prop: "inType", label: "入库类型", minWidth: 90, formatter: this.selectionFormat },
      { prop: "fromCorpName", label: "供应商名称", minWidth: 70, minWidth: 120, formatter: this.selectionFormat },
      { prop: "status", label: "状态", minWidth: 120, formatter: this.selectionFormat },
      { prop: "fromCorpId", label: "供应商主键", minWidth: 120},

      //{ prop: "finshTime", label: "finshTime", minWidth: 100, formatter: this.dateFormat }

    ]
    this.filterColumns = this.columns;

  },
  watch:{
    $route(to,from){
         console.log(to.path);
         //debugger
          this.filters.inType=parseInt(to.path.substr(to.path.lastIndexOf('/')+1))
          this.findPage({pageRequest:{pageNum:1,pageSize:7}});
    },

    // gysTypes(val,oldVal){
    //     debugger
    //     if(oldVal.length==0){
    //       this.filters.fromCorpName="";
    //       //this.filters.pageNum = 1
    //       //this.filters.pageSize = 8
    //       //this.findPage(filters);
    //     }
    // }
  }
}
</script>

<style scoped>
</style>
