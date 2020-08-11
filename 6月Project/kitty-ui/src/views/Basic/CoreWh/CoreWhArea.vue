<template>
  <div class="page-container">
    <!--工具栏-->
    <div class="toolbar"
         style="float:left;padding-top:10px;padding-left:15px;">
      <el-form :inline="true"
               :model="filters"
               :size="size">
        <el-form-item>
          <el-input v-model="filters.areaName"
                    :placeholder="'请输入区域名称'"
                    clearable></el-input>
        </el-form-item>
        <el-form-item>
          <el-select v-model="filters.whId"
                     placeholder="请选择库房"
                     auto-complete="off"
                     style="width: 100%;"
                     clearable>
            <el-option v-for="item in whTypes"
                       :key="item.id"
                       :label="item.name"
                       :value="item.id">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-input v-model="filters.orderNo"
                    placeholder="仅可输入1,2,3进行查询"
                    auto-complete="off"
                    clearable
                    onkeyup="value=value.replace(/[^1-3]/g,'')">
          </el-input>
        </el-form-item>
        <el-form-item>
          <kt-button icon="fa fa-search"
                     :label="$t('action.search')"
                     perms="corewh:corewh:view"
                     type="primary"
                     @click="findPage(null)" />
        </el-form-item>
        <el-form-item>
          <kt-button icon="fa fa-plus"
                     :label="$t('action.add')"
                     perms="corewh:corewh:add"
                     type="primary"
                     @click="handleAdd" />
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
              permsEdit="corewh:corewh:edit"
              permsDelete="corewh:corewh:delete"
              :data="pageResult"
              :columns="filterColumns"
              @findPage="findPage"
              @handleEdit="handleEdit"
              @handleDelete="handleDelete" :pageRequest="this.pageRequest">
    </kt-table>
    <!--新增编辑界面-->
    <el-dialog :title="operation?'库区 —— 新增':'库区 —— 编辑'"
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
        <el-form-item :label="$t('field.Core.corewharea.areaName')"
                      prop="areaName">
          <el-input v-model="dataForm.areaName"
                    auto-complete="off"
                    clearable></el-input>
        </el-form-item>
        <el-form-item :label="$t('field.Core.corewharea.whName')"
                      prop="whId">
          <el-select v-model="dataForm.whId"
                     placeholder="请选择"
                     auto-complete="off"
                     style="width: 100%;"
                     clearable>
            <el-option v-for="item in whTypes"
                       :key="item.id"
                       :label="item.name"
                       :value="item.id">
            </el-option>
          </el-select>
        </el-form-item>
        <!-- <el-form-item :label="$t('field.Core.corewharea.craneName')"
                      prop="craneId">
          <el-input v-model="dataForm.craneId"
                    auto-complete="off"></el-input>
        </el-form-item> -->
        <el-form-item :label="$t('field.Core.corewharea.info')"
                      prop="info">
          <el-input v-model="dataForm.info"
                    auto-complete="off"
                    clearable></el-input>
        </el-form-item>
        <el-form-item :label="$t('field.Core.corewharea.orderNO')"
                      prop="orderNo">
          <el-input v-model="dataForm.orderNo"
                    auto-complete="off"
                    placeholder="请输入1,2,3"
                    onkeyup="value=value.replace(/[^1-3]/g,'')"
                    clearable></el-input>
        </el-form-item>
        <!-- <el-form-item :label="$t('field.Core.corewharea.locWidth')"
                      prop="locWidth">
          <el-input v-model="dataForm.locWidth"
                    auto-complete="off"
                    onkeyup="value=value.replace(/[^\d^\.]+/g,'').replace('.','$#$').replace(/\./g,'').replace('$#$','.')">
          </el-input>
        </el-form-item>
        <el-form-item :label="$t('field.Core.corewharea.locHight')"
                      prop="locHight">
          <el-input v-model="dataForm.locHight"
                    auto-complete="off"
                    onkeyup="value=value.replace(/[^\d^\.]+/g,'').replace('.','$#$').replace(/\./g,'').replace('$#$','.')">
          </el-input>
        </el-form-item>
        <el-form-item :label="$t('field.Core.corewharea.locdeep')"
                      prop="locdeep">
          <el-input v-model="dataForm.locdeep"
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
        areaName: ''
      },
      dicts: [],
      columns: [],
      filterColumns: [],
      pageRequest: { pageNum: 1, pageSize: 10 },
      pageResult: {},

      operation: false, // true:新增, false:编辑
      dialogVisible: false, // 新增编辑界面是否显示
      editLoading: false,

      // 新增编辑界面数据
      dataForm: {
        id: 0,
        whId: '',
        areaName: '',
        craneId: '',
        info: '',
        orderNO: '',
        locWidth: '',
        locHight: '',
        locdeep: '',
        name: 'abcdef'
      },
      whTypes: []

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
      this.$api.corewharea.findPage(this.filters).then((res) => {
        this.pageResult = res.data

      }).then(data != null ? data.callback : '')
    },
    // 批量删除
    handleDelete: function (data) {
      this.$api.corewharea.batchDelete(data.params).then(data != null ? data.callback : '')
    },
    // 显示新增界面
    handleAdd: function () {
      this.dialogVisible = true
      this.operation = true
      this.dataForm = {
        id: 0,
        whId: '',
        areaName: '',
        craneId: '',
        info: '',
        orderNO: '',
        locWidth: '',
        locHight: '',
        locdeep: ''
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
            this.$api.corewharea.save(params).then((res) => {
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
    //获取库房名称
    findWhTypes: function () {
      this.$api.corewh.findPage().then((res) => {
        this.whTypes = res.data.content
      })
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
        { prop: "areaName", label: "field.Core.corewharea.areaName", minWidth: 100 },
        { prop: "whId", label: "field.Core.corewharea.whName", minWidth: 100, formatter: this.selectionFormat },
        // { prop: "craneId", label: "field.Core.corewharea.craneName", minWidth: 100 },
        { prop: "info", label: "field.Core.corewharea.info", minWidth: 100 },
        { prop: "orderNo", label: "field.Core.corewharea.orderNO", minWidth: 100 },
        //{ prop: "locWidth", label: "field.Core.corewharea.locWidth", minWidth: 100 },
        //{ prop: "locHight", label: "field.Core.corewharea.locHight", minWidth: 100, },
        //{ prop: "locdeep", label: "field.Core.corewharea.locdeep", minWidth: 100 },
        //{ prop: "lastUpdateTime", label: "更新时间", minWidth: 120, formatter: this.dateFormat }
      ]
      this.filterColumns = this.columns;
    },
    selectionFormat: function (row, column, cellValue, index) {
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

  },
  created () {
    //this.findDeptTree()
    this.initColumns()
    // this.$api.corewh.findPage().then((res) => {
    //   this.dicts = res.data.content

    //})
    this.findWhTypes();
  }
}
</script>

<style scoped>
</style>