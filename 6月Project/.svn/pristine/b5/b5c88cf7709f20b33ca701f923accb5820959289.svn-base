<template>
  <div class="page-container">
    <!--工具栏-->
    <div class="toolbar"
         style="float:left;padding-top:10px;padding-left:15px;">
      <el-form :inline="true"
               :model="filters"
               :size="size">
        <el-form-item>
          <el-input v-model="filters.name"
                    placeholder="请输入供应商名称"
                    auto-complete="off"
                    clearable>
          </el-input>
        </el-form-item>
        <el-form-item>
          <el-select v-model="filters.editable"
                     placeholder="请选择"
                     auto-complete="off"
                     style="width: 100%;"
                     clearable>
            <el-option :value="'可编辑'">
            </el-option>
            <el-option :value="'不可编辑'">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item>
          <kt-button icon="fa fa-search"
                     :label="$t('action.search')"
                     perms="material:supplier:view"
                     type="primary"
                     @click="findPage(null)" />
        </el-form-item>
        <el-form-item>
          <kt-button icon="fa fa-plus"
                     :label="$t('action.add')"
                     perms="material:supplier:add"
                     type="primary"
                     @click="handleAdd" />
        </el-form-item>
        <el-form-item>
          <kt-button icon="fa fa-plus"
                     :label="'设置物料'"
                     perms="material:supplier:setitem"
                     type="primary"
                     @click="handleBatchSet" />
        </el-form-item>
      </el-form>
    </div>
    <div class="toolbar"
         style="float:right;padding-top:10px;padding-right:15px;">
      <el-form :inline="true"
               :size="size">
        <el-form-item>
          <el-button-group>
            <el-tooltip content="下载模板" placement="top">
              <el-button icon="fa fa-download" @click="exportExample"></el-button>
            </el-tooltip>	
            	
            <el-tooltip content="导出Excel" placement="top">
              <el-button icon="fa fa-file-excel-o" @click="exportExcel" /> 
            </el-tooltip>
            <el-tooltip content="导入Excel" placement="top">
              <el-button  icon="fa fa-upload" @click="importExcel" />              
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
    <kt-table :height="350"
              permsEdit="material:classifyarea:edit"
              permsDelete="material:classifyarea:delete"
              :data="pageResult"
              :columns="filterColumns"
              @findPage="findPage"
              @handleEdit="handleEdit"
              @handleDelete="handleDelete"
              @selectionChange='selectionChange' :pageRequest="this.pageRequest">
    </kt-table>
    <!-- EXCEL导入 -->
    <upload-file :key="componentKey" :UpLoadFileVisible="UpLoadFileVisible" @ImportExcelData="ImportExcelData" @cancel="cancel" :PercentageValue="this.percentageValue"></upload-file>
    <!--新增编辑界面-->
    <el-dialog :title="operation?'供应商 —— 新增':'供应商 —— 编辑'"
               width="40%"
               :visible.sync="dialogVisible"
               :close-on-click-modal="false">
      <el-form :model="dataForm"
               label-width="100px"
               :rules="dataFormRules"
               ref="dataForm"
               :size="size"
               label-position="right">
        <el-form-item label="ID"
                      prop="id"
                      v-if="false">
          <el-input v-model="dataForm.id"
                    :disabled="true"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item :label="'NC系统Id'"
                      prop="name">
          <el-input v-model="dataForm.ncId"
                    auto-complete="off"
                    clearable></el-input>
        </el-form-item>
        <el-form-item :label="'供应商名称'"
                      prop="name">
          <el-input v-model="dataForm.name"
                    auto-complete="off"
                    clearable></el-input>
        </el-form-item>
        <el-form-item :label="'供应商状态'"
                      prop="editable">
          <el-select v-model="dataForm.editable"
                     placeholder="请选择"
                     auto-complete="off"
                     style="width: 100%;"
                     clearable>
            <el-option :value="'可编辑'">
            </el-option>
            <el-option :value="'不可编辑'">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item :label="'供应商编码'"
                      prop="code">
          <el-input v-model="dataForm.code"
                    auto-complete="off">
          </el-input>
        </el-form-item>
        <el-form-item :label="'供应商地址'"
                      prop="address">
          <el-input v-model="dataForm.address"
                    auto-complete="off">
          </el-input>
        </el-form-item>
      </el-form>
      <div slot="footer"
           class="dialog-footer">
        <el-button :size="size"
                   @click.native="dialogVisible = false">{{$t('action.cancel')}}</el-button>
        <el-button :size="size"
                   type="primary"
                   @click.native="submitForm"
                   :loading="editLoading">{{$t('action.submit')}}</el-button>
      </div>
    </el-dialog>
    <el-dialog :title="operation?'设置物料 —— 批量编辑':$t('action.edit')"
               width="30%"
               :visible.sync="dialogVisibles"
               :close-on-click-modal="false">
      <el-form :model="dataForm"
               label-width="100px"
               :rules="dataFormRules"
               ref="dataForm"
               :size="size"
               label-position="right">
        <el-form-item label="ID"
                      prop="id"
                      v-if="false">
          <el-input v-model="dataForm.id"
                    :disabled="true"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item :label="'物料名称'"
                      prop="areaId">
          <el-select v-model="dataForm.itemId"
                     placeholder="请选择"
                     auto-complete="off"
                     style="width: 100%;">
            <el-option v-for="item in itemTypes"
                       :key="item.id"
                       :label="item.name"
                       :value="item.id">
            </el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <div slot="footer"
           class="dialog-footer">
        <el-button :size="size"
                   @click.native="dialogVisibles = false">{{$t('action.cancel')}}</el-button>
        <el-button :size="size"
                   type="primary"
                   @click.native="submitForms"
                   :loading="editLoading">{{$t('action.submit')}}</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import PopupTreeInput from "@/components/PopupTreeInput"
import KtTable from "@/views/Core/KtTable"
import KtButton from "@/views/Core/KtButton"
import TableColumnFilterDialog from "@/views/Core/TableColumnFilterDialog"
import { format } from "@/utils/datetime"
import UploadFile from "@/views/Core/UploadFile"
import { export_json_to_excel } from "@/excel/Export2Excel"
import XLSX from "xlsx";
export default {
  components: {
    PopupTreeInput,
    KtTable,
    KtButton,
    TableColumnFilterDialog,
    UploadFile
  },
  data () {
    return {
      size: 'small',
      filters: {
        name: ''
      },
      percentageValue:0,
      columns: [],
      demo: [],
      filterColumns: [],
      pageRequest: { pageNum: 1, pageSize: 10 },
      pageResult: {},
      dicts: [],
      componentKey: 0,
      UpLoadFileVisible:false,
      dictss: this.$store.state.dict.dictss,
      operation: false, // true:新增, false:编辑
      dialogVisible: false,
      dialogVisibles: false,// 设置区位界面是否显示
      editLoading: false,
      selections: [],
      // 新增编辑界面数据
      dataForm: {
        id: 0,
        name: '',
        code: '',
        ncId: '',
        editable: '',
      },
      ediTypes: [],
      classTypes: [],
      itemTypes: []
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
    // 获取分页数据
    findPage: function (data) {
      if(data!==null){
				this.filters.pageNum=data.pageRequest.pageNum		
			}else{
				this.filters.pageNum=1
			}
			this.filters.pageSize=this.pageRequest.pageSize
      this.$api.corewhgro.findPage(this.filters).then((res) => {
        this.pageResult = res.data
      }).then(data != null ? data.callback : '')
    },
    //批量编辑
    submitForms: function () {
      //let para = this.handleBatchEdit(data).data
      let ppa = [];
      if (this.demo.selections.id == 0) {
        this.$message({ message: "请至少选择一条数据", type: 'error' })
      } else {
        for (var i = 0; i < this.demo.selections.length; i++) {
          ppa.push(this.demo.selections[i].id)
        }
        this.$refs.dataForm.validate((valid) => {
          if (valid) {
            this.$confirm(this.getKey('action.isConfirm'), this.getKey('action.tips'), {}).then(() => {
              this.editLoading = true
              let params = Object.assign({}, this.dataForm).itemId
              this.$api.corewhgro.batchset(ppa, params).then((res) => {
                this.editLoading = false
                if (res.code == 200) {
                  this.$message({ message: this.getKey('action.operateSucess'), type: 'success' })
                  this.dialogVisibles = false
                  this.$refs['dataForm'].resetFields()
                } else {
                  this.$message({ message: this.getKey('action.operateFail') + res.msg, type: 'error' })
                }
                this.findPage(null)
              })
            })
          }
        })      }
    },
    selectionChange: function (selection) {

      this.selection = selection;
    },
    //显示批量设置库位界面
    handleBatchSet: function () {
      this.dialogVisibles = true
      this.operation = true
      this.demo = this.selection;
      console.log(this.demo);
    },

    findItemTypes: function () {
      this.$api.item.findPage().then((res) => {
        this.itemTypes = res.data.content
      })
    },

    findUserRoles: function () {
      this.$api.role.findAll().then((res) => {
        // 加载角色集合
        this.roles = res.data
      })
    },
    // 批量删除
    handleDelete: function (data) {
      this.$api.corewhgro.batchDelete(data.params).then(data != null ? data.callback : '')
    },

    // 显示新增界面
    handleAdd: function () {
      this.dialogVisible = true
      this.operation = true
      this.dataForm = {
        id: 0,
        name: '',
        code: '',
        ncId: '',
        editable: '',
      }
    },
    // 显示编辑界面
    handleEdit: function (params) {
      if (Object.assign({}, params.row).editable == "不可编辑") {
        this.$message({ message: "该供应商不可编辑", type: 'error' })
      } else {
        this.dialogVisible = true
        this.operation = false
        this.dataForm = Object.assign({}, params.row)
      }
    },
    // 编辑
    submitForm: function () {
      this.$refs.dataForm.validate((valid) => {
        if (valid) {
          this.$confirm(this.getKey('action.isConfirm'), this.getKey('action.tips'), {}).then(() => {
            this.editLoading = true
            let params = Object.assign({}, this.dataForm)
            this.$api.corewhgro.save(params).then((res) => {
              this.editLoading = false
              if (res.code == 200) {
                this.$message({ message: this.getKey('action.operateSucess'), type: 'success' })
                this.dialogVisible = false
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
    importExcel(){       
      this.componentKey += 1;
      this.UpLoadFileVisible = true
    },
    ImportExcelData(excelData){  
                  // 将上面数据转换成 table需要的数据
                  let arr = [];
                  excelData.forEach(item => {
                      let obj = {};
                      obj.ncId = item["nc系统Id"];
                      obj.name = item["供应商名称"];
                      obj.address = item["供应商地址"];
                      obj.code = item["编码"];   
                      obj.editable = 0;                
                      arr.push(obj);            
                      this.percentageValue=Math.round(this.percentageValue+100/excelData.length) 
         
                  });
                   this.$api.corewhgro.ImportList(arr).then((res) => {
                        if(res.code==200){
                            this.$message({ message: this.getKey('action.operateSucess'), type: 'success' })
                            this.UpLoadFileVisible = false
                            this.findPage(null)
                            this.percentageValue=0
                        } 
                         else{
                            this.$message({ message: this.getKey('action.operateFail') + res.msg, type: 'error' })
                            this.UpLoadFileVisible = false
                            this.percentageValue=0
                        }                     
                    })
                  
    },
    cancel:function(){
			this.UpLoadFileVisible=false;
		},
    //导出的方法
		exportExcel() {
        require.ensure([], () => {  
              this.$api.corewhgro.GetExportList(this.filters).then((res) => {
                debugger
              // Excel的表格第一行的标题			
              const tHeader = ['nc系统Id','供应商名称', '供应商地址', '编码'];
              // index、nickName、name是tableData里对象的属性
              const filterVal = ['ncId','name', 'address', 'code'];            
              const list = res.data;  //把data里的tableData存到list
              const data = this.formatJson(filterVal, list);
              export_json_to_excel(tHeader, data, '供应商信息导出');
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
    //下载模板
    exportExample() {
        require.ensure([], () => {  
              this.$api.corewhgro.GetExportList(this.filters).then((res) => {
              // Excel的表格第一行的标题			
              const tHeader = ['nc系统Id','供应商名称', '供应商地址', '编码'];
              // index、nickName、name是tableData里对象的属性
              const filterVal = [];            
              const list = res.data;  //把data里的tableData存到list
              const data = this.formatJson(filterVal, list);
              export_json_to_excel(tHeader, data, '供应商模板导出');
          })    	        
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
    // 处理表格列过滤显示
    handleFilterColumns: function (data) {
      this.filterColumns = data.filterColumns
      this.$refs.tableColumnFilterDialog.setDialogVisible(false)
    },
    getKey: function (arg) {
      return this.$t(arg)
    },
    // 处理表格列过滤显示
    initColumns: function () {
      this.columns = [
        { prop: "ncId", label: "nc系统Id", minWidth: 120, formatter: this.selectionFormats },
        { prop: "name", label: "供应商名称", minWidth: 120, formatter: this.selectionFormats },
        { prop: "editable", label: "供应商状态", minWidth: 100, formatter: this.selectionFormat },
        { prop: "code", label: "供应商编码", minWidth: 120, formatter: this.itemFilter },
        { prop: "address", label: "供应商地址", minWidth: 120, formatter: this.itemFilter },
     
      ]
      this.filterColumns = this.columns;
    },
    selectionFormat: function (row, column, cellValue, index) {
      let key = ""
      let propt = column.property;
      let val = row[column.property];
      let dict = this.itemTypes;
      for (let i = 0; i < dict.length; i++) {
        if (dict[i].id == val) {
          return dict[i].name;
        }
      }
      return row[column.property]
    },
  },
  created () {
    //this.findDeptTree()
    this.initColumns()
    this.findItemTypes()
  },
   watch:{
	
    dialogVisible(to,from){
       if (this.$refs['dataForm'] !== undefined) {
            this.$refs["dataForm"].resetFields();
          }
    }
  }
}
</script>

<style scoped>
</style>