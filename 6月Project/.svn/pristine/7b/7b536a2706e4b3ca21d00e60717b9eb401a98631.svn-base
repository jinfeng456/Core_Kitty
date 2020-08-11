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
                    :placeholder="$t('classify.please enter')"></el-input>
        </el-form-item>
        <el-form-item>
          <kt-button icon="fa fa-search"
                     :label="$t('action.search')"
                     perms="material:classify:view"
                     type="primary"
                     @click="findPage(null)" />
        </el-form-item>
        <el-form-item>
          <kt-button icon="fa fa-plus"
                     :label="$t('action.add')"
                     perms="material:classify:add"
                     type="primary"
                     @click="handleAdd" />
        </el-form-item>
        <el-form-item>
          <kt-button icon="fa fa-plus"
                     :label="'设置区位'"
                     perms="material:classify:setarea"
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
    </div>
    <!--表格内容栏-->
    <kt-table :height="350"
              permsEdit="material:classify:edit"
              permsDelete="material:classify:delete"
              :data="pageResult"
              :columns="filterColumns"
              @findPage="findPage"
              @handleEdit="handleEdit"
              @handleDelete="handleDelete"
              @selectionChange='selectionChange' :pageRequest="this.pageRequest">
    </kt-table>
    <!--新增编辑界面-->
    <el-dialog :title="operation?'物料类别 —— 新增':'物料类别 —— 编辑'"
               width="40%"
               :visible.sync="dialogVisible"
               :close-on-click-modal="false">
      <el-form :model="dataForm"
               label-width="90px"
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
        <el-form-item :label="$t('classify.name')"
                      prop="name">
          <el-input v-model="dataForm.name"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item :label="$t('classify.info')"
                      prop="info">
          <el-input v-model="dataForm.info"
                    auto-complete="off"></el-input>
        </el-form-item>
        <!-- <el-form-item label="机构" prop="deptName">
				<popup-tree-input 
					:data="deptData" 
					:props="deptTreeProps" 
					:prop="dataForm.deptName" 
					:nodeKey="''+dataForm.deptId" 
					:currentChangeHandle="deptTreeCurrentChangeHandle">
				</popup-tree-input>
			</el-form-item> -->
        <!-- <el-form-item :label="$t('classify.stockWidth')"
                      prop="stockWidth">
          <el-input v-model="dataForm.stockWidth"
                    auto-complete="off"
                    onkeyup="value=value.replace(/[^\d^\.]+/g,'').replace('.','$#$').replace(/\./g,'').replace('$#$','.')">
          </el-input>
        </el-form-item>
        <el-form-item :label="$t('classify.stockHigh')"
                      prop="stockHigh">
          <el-input v-model="dataForm.stockHigh"
                    auto-complete="off"
                    onkeyup="value=value.replace(/[^\d^\.]+/g,'').replace('.','$#$').replace(/\./g,'').replace('$#$','.')">
          </el-input>
        </el-form-item>
        <el-form-item :label="$t('classify.stockDeep')"
                      prop="stockDeep">
          <el-input v-model="dataForm.stockDeep"
                    auto-complete="off"
                    onkeyup="value=value.replace(/[^\d^\.]+/g,'').replace('.','$#$').replace(/\./g,'').replace('$#$','.')">
          </el-input>
        </el-form-item> -->
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

    <el-dialog :title="operation?'设置库区 —— 批量编辑':$t('action.edit')"
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
        <el-form-item :label="$t('field.Core.corewhloc.areaName')"
                      prop="areaId">
          <el-select v-model="dataForm.areaId"
                     placeholder="请选择"
                     auto-complete="off"
                     style="width: 100%;">
            <el-option v-for="item in areaTypes"
                       :key="item.id"
                       :label="item.areaName"
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
export default {
  components: {
    PopupTreeInput,
    KtTable,
    KtButton,
    TableColumnFilterDialog
  },
  data () {
    return {
      size: 'small',
      filters: {
        name: ''
      },
      columns: [],
      demo: [],
      filterColumns: [],
      pageRequest: { pageNum: 1, pageSize: 10 },
      pageResult: {},
      dicts: [],
      operation: false, // true:新增, false:编辑
      dialogVisible: false,
      dialogVisibles: false,// 设置区位界面是否显示
      editLoading: false,
      selections: [],
      // 新增编辑界面数据
      dataForm: {
        id: 0,
        name: '',
        info: '',
        stockWidth: 0,
        stockHigh: 0,
        stockDeep: 0
      },
      areaTypes: []
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
      this.$api.classify.findPage(this.filters).then((res) => {
        this.pageResult = res.data
        console.log("******");
        console.log(this.pageResult);
      }).then(data != null ? data.callback : '')
    },

    findAreaTypes: function () {
      this.$api.corewharea.findPage().then((res) => {
        this.areaTypes = res.data.content
      })
    },


    //批量编辑
    submitForms: function () {
      //let para = this.handleBatchEdit(data).data
      let ppa = [];
      for (var i = 0; i < this.demo.selections.length; i++) {
        //alert(this.demo.params[i].id)
        ppa.push(this.demo.selections[i].id)
      }
      // let params = Object.assign({}, this.dataForm).areaId
      // console.log(params);
      this.$refs.dataForm.validate((valid) => {
        if (valid) {
          this.$confirm(this.getKey('action.isConfirm'), this.getKey('action.tips'), {}).then(() => {
            this.editLoading = true
            let params = Object.assign({}, this.dataForm).areaId
            this.$api.classify.batchset(ppa, params).then((res) => {
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
      })
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



    findUserRoles: function () {
      this.$api.role.findAll().then((res) => {
        // 加载角色集合
        this.roles = res.data
      })
    },
    // 批量删除
    handleDelete: function (data) {
      this.$api.classify.batchDelete(data.params).then(data != null ? data.callback : '')
    },

    // 显示新增界面
    handleAdd: function () {
      this.dialogVisible = true
      this.operation = true
      this.dataForm = {
        id: 0,
        name: '',
        info: '',
        stockWidth: 0,
        stockHigh: 0,
        stockDeep: 0
      }
    },
    // 显示编辑界面
    handleEdit: function (params) {
      this.dialogVisible = true
      this.operation = false
      this.dataForm = Object.assign({}, params.row)
    },
    // 编辑
    submitForm: function () {
      this.$refs.dataForm.validate((valid) => {
        if (valid) {
          this.$confirm(this.getKey('action.isConfirm'), this.getKey('action.tips'), {}).then(() => {
            this.editLoading = true
            let params = Object.assign({}, this.dataForm)
            this.$api.classify.save(params).then((res) => {
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
        //{ prop: "id", label: "ID", minWidth: 50 },
        { prop: "name", label: "classify.name", minWidth: 120 },
        //{prop:"deptName", label:"机构", minWidth:120},
        { prop: "info", label: "classify.info", minWidth: 100 },
        //{ prop: "stockWidth", label: "classify.stockWidth", minWidth: 120 },
        //{ prop: "stockHigh", label: "classify.stockHigh", minWidth: 100 },
        //{ prop: "stockDeep", label: "classify.stockDeep", minWidth: 70 },
        //{ prop: "areaId", label: "所属库区", minWidth: 120, formatter: this.selectionFormat },
        // {prop:"createTime", label:"创建时间", minWidth:120, formatter:this.dateFormat}
        // {prop:"lastUpdateBy", label:"更新人", minWidth:100},
        // {prop:"lastUpdateTime", label:"更新时间", minWidth:120, formatter:this.dateFormat}
      ]
      this.filterColumns = this.columns;
    },
    selectionFormat: function (row, column, cellValue, index) {
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
  },
  created () {
    //this.findDeptTree()
    this.initColumns()
    this.findAreaTypes();
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