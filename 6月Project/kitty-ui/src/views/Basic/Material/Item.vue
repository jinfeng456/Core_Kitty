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
                    :placeholder="$t('item.please enter')" style="width: 175px;"></el-input>
        </el-form-item>
        <el-form-item>
          <el-select v-model="filters.classifyId"
                     placeholder="请选择物料类别"
                     style="width: 175px;"
                     clearable>
            <el-option v-for="item in classTypes"
                       :key="item.id"
                       :label="item.name"
                       :value="item.id">
            </el-option>

          </el-select>
        </el-form-item>

        <el-form-item>
          <el-select v-model="filters.coreItemType"
                     placeholder="请选择物料类型"
                     style="width: 175px;"
                     clearable>
            <el-option v-for="item in dicts.coreItemType"
                       :key="item.value"
                       :label="item.label"
                       :value="item.value">
            </el-option>

          </el-select>
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
    <div class="toolbar"
         style="float:left;padding-top:0px;padding-left:15px;">
      <el-form :inline="true"
               :model="filters"
               :size="size">
        <el-form-item>
          <el-input v-model="filters.code"
                    :placeholder="$t('item.please code')" style="width: 175px;"></el-input>
        </el-form-item>
        <el-form-item>
          <el-input v-model="filters.modelSpecs"
                    placeholder="请输入规格型号" style="width: 175px;"></el-input>
        </el-form-item>
        <el-form-item>
          <kt-button icon="fa fa-search"
                     :label="$t('action.search')"
                     perms="material:item:view"
                     type="primary"
                     @click="findPage(null)" />
        </el-form-item>
        <el-form-item>
          <kt-button icon="fa fa-plus"
                     :label="$t('action.add')"
                     perms="material:item:add"
                     type="primary"
                     @click="handleAdd" />
        </el-form-item>
      </el-form>
    </div>
    <!--表格内容栏-->
  
    <kt-table2 :height="350" permsDelete="material:item:delete" :myButtons="myButtons"
		:data="pageResult" :columns="columns" 
		@findPage="findPage" @handleEdit="handleEdit" @handleRestore="handleRestore" @handleDisable="handleDisable" @handleDelete="handleDelete" :pageRequest="this.pageRequest">
	  </kt-table2>

    <!-- EXCEL导入 -->
    <upload-file :key="componentKey" :UpLoadFileVisible="UpLoadFileVisible" @ImportExcelData="ImportExcelData" @cancel="cancel" :PercentageValue="this.percentageValue"></upload-file>

    <!--新增编辑界面-->
    <el-dialog :title="operation?'物料 —— 新增':'物料 —— 编辑'"
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
                   auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item :label="$t('item.code')"
                      prop="code">
          <el-input v-model="dataForm.code"
                    v-bind:disabled="dataForm.id"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item :label="$t('item.name')"
                      prop="name">
          <el-input v-model="dataForm.name"
                    v-bind:disabled="dataForm.id"
                   auto-complete="off"></el-input>
        </el-form-item>

        <el-form-item label="规格型号"
                      prop="modelSpecs">
          <el-input v-model="dataForm.modelSpecs"
                    v-bind:disabled="dataForm.id"
                    auto-complete="off"></el-input>
        </el-form-item>
  
        <el-form-item label="物料类型"
                      prop="coreItemType">
          <el-select v-model="dataForm.coreItemType"
                     placeholder="请选择"
                     style="width: 100%;" >
            <el-option v-for="item in dicts.coreItemType"
                       :key="item.value"
                       :label="item.label"
                       :value="item.value">
            </el-option>
          </el-select>
        </el-form-item>

        <el-form-item :label="$t('item.classifyId')"
                      prop="classifyId">
          <el-select v-model="dataForm.classifyId"
                     placeholder="请选择"
                     style="width: 100%;">
            <el-option v-for="item in classTypes"
                       :key="item.id"
                       :label="item.name"
                       :value="item.id">
            </el-option>
          </el-select>
        </el-form-item>

        <el-form-item  label="包装规格"
                      prop="packageSpecs">
          <el-input v-model="dataForm.packageSpecs"
                    auto-complete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer"
           class="dialog-footer">
        <el-button :size="size"
                   @click.native="dialogVisible = false">{{$t('action.cancel')}}</el-button>
        <el-button :size="size"
                   type="primary"
                   @click.native="submitForm">{{$t('action.submit')}}</el-button>
      </div>
    </el-dialog>

  </div>
</template>

<script>
import PopupTreeInput from "@/components/PopupTreeInput"
import KtTable2 from "@/views/Core/KtTable2"
import KtButton from "@/views/Core/KtButton"
import TableColumnFilterDialog from "@/views/Core/TableColumnFilterDialog"
import { format } from "@/utils/datetime"
import UploadFile from "@/views/Core/UploadFile"
import { export_json_to_excel } from "@/excel/Export2Excel"
import XLSX from "xlsx";
export default {
  components: {
    PopupTreeInput,
    KtTable2,
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
      myButtons:[{
				name:"handleEdit",
				perms:"sys:sysCode:edit",
				label:"action.edit",
				icon:"fa fa-edit"
			},{
				name:"handleDelete",
				perms:"sys:sysCode:delete",
				label:"action.delete",
				type:"danger",
				icon:"fa fa-trash"
      }
      // ,{
			// 	name:"handleRestore",
			// 	perms:"material:item:restore",
			// 	label:"恢复",
			// 	type:"danger",
			// 	icon:"fa fa-trash"
			// },{
			// 	name:"handleDisable",
			// 	perms:"material:item:Disable",
			// 	label:"禁用",
			// 	type:"danger",
			// 	icon:"fa fa-trash"
      // }
      ],
      percentageValue:0,
      columns: [],
      filterColumns: [],
      pageRequest: { pageNum: 1, pageSize: 10 },
      pageResult: {},
      tableData:[],
      componentKey: 0,
      operation: false, // true:新增, false:编辑
      dialogVisible: false, // 新增编辑界面是否显示
      UpLoadFileVisible:false,
      editLoading: false,
      dicts:this.$store.state.dict.dicts,
      // 新增编辑界面数据
      dataForm: {
        id: 0,
        //classifyId: ,
        code: '',
        name: '',
        active: 0,
        modelSpecs:'',//规格型号
        packageSpecs:''//包装规格
      },
      classTypes: [],
    }
  },

  computed: {
    dataFormRules () {
      const dataFormRules = {        name: [{ required: true, message: "请输入物料名称", trigger: 'blur' }],
                                     modelSpecs: [{ required: true, message: "请输入规格型号", trigger: 'blur' }],
                                     code: [{ required: true, message: "请输入物料编码", trigger: 'blur' }]
      };
      return dataFormRules;
    }
  },

  methods: {
    //获取分页数据
    findPage: function (data) {
      if(data!==null){
				this.filters.pageNum=data.pageRequest.pageNum		
			}else{
				this.filters.pageNum=1
			}
			this.filters.pageSize=this.pageRequest.pageSize
      this.$api.item.findPage(this.filters).then((res) => {
        this.pageResult = res.data
      }).then(data != null ? data.callback : '')
    },
    // 加载用户角色信息
    findUserRoles: function () {
      this.$api.role.findAll().then((res) => {
        // 加载角色集合
        this.roles = res.data
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
                      obj.name = item["名称"];
                      obj.classifyId = this.classTypeToId(item["类别名称"]);
                      obj.coreItemType = this.dicToId(item["物料类型"]);
                      obj.code = item["编码"];
                      obj.modelSpecs = item["规格型号"];
                      obj.packageSpecs = item["包装规格"];
                      arr.push(obj);
                      this.percentageValue= Math.round(this.percentageValue+100/excelData.length)
                      // this.$api.item.save(obj).then((res) => {
                      //     if(res.code==200){
                      //       debugger
                      //         this.percentageValue= this.percentageValue+100/excelData.length
                      //     }
                      //     else
                      //     {
                      //         this.percentageValue=0
                      //     }
                      // })
                  });
                  this.$api.item.ImportList(arr).then((res) => {
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
      this.percentageValue=0
		},
    //导出的方法
		exportExcel() {
        this.filters.pageSize=-1
        require.ensure([], () => {
              this.$api.item.findPage(this.filters).then((res) => {
              // Excel的表格第一行的标题
              const tHeader = ['名称', '类别名称', '物料类型', '编码','规格型号','包装规格'];
              // index、nickName、name是tableData里对象的属性
              const filterVal = ['name', 'classifyName', 'coreItemTypeName', 'code','modelSpecs','packageSpecs'];
              const list = res.data.content;  //把data里的tableData存到list
              const data = this.formatJson(filterVal, list);
              export_json_to_excel(tHeader, data, '物料信息导出');
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
              this.$api.item.findPage(this.filters).then((res) => {
              // Excel的表格第一行的标题
              const tHeader = ['名称', '类别名称', '物料类型', '编码','规格型号','包装规格'];
              // index、nickName、name是tableData里对象的属性
              const filterVal = [];
              const list = res.data.content;  //把data里的tableData存到list
              const data = this.formatJson(filterVal, list);
              export_json_to_excel(tHeader, data, '物料信息导出');
          })
        })
      },
    // 批量删除
    handleDelete: function (data) {
      this.$api.item.batchDelete(data.params).then(data != null ? data.callback : '')
    },
    // 显示新增界面
    handleAdd: function () {

      this.dialogVisible = true
      this.operation = true
      this.dataForm = {
        id: 0,
        classifyId: undefined,
        code: '',
        name: '',
        active: 0
      }
    },
    selectionFormats: function (row, column, cellValue, index){
			let key=""
			let propt=column.property;
			if(propt=="coreItemType"){
				key="coreItemType"
      }
      else if(propt=="active"){
				key="activeStatus"
      }
		    let val=row[column.property];
			let dict =this.$store.state.dict.dicts[key];
			if(dict==undefined){
					return row[column.property]
			}
			for(let i=0;i<dict.length;i++){
				if(dict[i].value==val){
					return dict[i].label;
				}
			}
          	return row[column.property]
      	},

   // 显示编辑界面
    handleEdit: function (params) {

      this.dialogVisible = true
      this.operation = false
      this.dataForm = Object.assign({}, params.row)
    },
     //取消
    cancelForm: function () {
        if(this.$refs['dataForm']!=undefined){
              this.$refs['dataForm'].resetFields();
        }

          this.dialogVisible = false
    },
    //新增
    submitForm: function () {
      this.$refs.dataForm.validate((valid) => {
        if (valid) {
          this.$confirm(this.getKey('action.isConfirm'), this.getKey('action.tips'), {}).then(() => {
            this.editLoading = true
            let params = Object.assign({}, this.dataForm)
            this.$api.item.save(params).then((res) => {
              //this.editLoading = false
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
    //`恢复
    handleRestore: function (params) {
      this.dataForm = Object.assign({}, params.row)
      if (this.dataForm.active == "正常") {
        this.$confirm('你选中的物料已经是正常状态了', '提示', {
          type: 'warning'
        })
      } else {
        this.dataForm.active = 0;
        this.$api.item.restore(this.dataForm).then((res) => {
          if (res.code == 200) {
            this.$message({ message: this.getKey('action.operateSucess'), type: 'success' })
            this.dialogVisible = false
          } else {
            this.$message({ message: this.getKey('action.operateFail') + res.msg, type: 'error' })
          }
          this.findPage(null)
        })
      }
    },
    handleDisable: function (params) {
      this.dataForm = Object.assign({}, params.row)
      if (this.dataForm.active == "禁用") {
        this.$confirm('你选中的物料已经是禁用状态了', '提示', {
          type: 'warning'
        })
      } else {
        this.dataForm.active = 1;
        this.$api.item.disable(this.dataForm).then((res) => {
          if (res.code == 200) {
            this.$message({ message: this.getKey('action.operateSucess'), type: 'success' })
            this.dialogVisible = false
          } else {
            this.$message({ message: this.getKey('action.operateFail') + res.msg, type: 'error' })
          }
          this.findPage(null)
        })
      }
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
    //加载物料类别分类
    findClassTypes: function () {
      this.$api.classify.findPage().then((res) => {
        this.classTypes = res.data.content
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
        { prop: "code", label: "item.code", minWidth: 100 },
        { prop: "name", label: "item.name", minWidth: 100 },
        { prop: "modelSpecs", label: "规格型号", minWidth: 100 },
        { prop: "coreItemType", label: "物料类型", minWidth: 100, formatter:this.selectionFormats },
        { prop: "classifyId", label: "item.classifyId", minWidth: 100, formatter: this.selectionFormat },
        { prop: "packageSpecs", label: "包装规格", minWidth: 100 },
        { prop: "active", label: "item.active", minWidth: 100 , formatter:this.selectionFormats},
        { prop: "info", label: "物料分类描述", minWidth: 120 }

      ]
      this.filterColumns = this.columns;
    },

    selectionFormat: function (row, column, cellValue, index) {
      let key = ""
      let propt = column.property;
      let val = row[column.property];
      let dict = this.classTypes;
      for (let i = 0; i < dict.length; i++) {
        if (dict[i].id == val) {
          return dict[i].name;
        }
      }
      return val
    },
    classTypeToId: function (name) {
      let list = this.classTypes;
      for (let i = 0; i < list.length; i++) {
        if (list[i].name == name) {
          return list[i].id;
        }
      }
      return 0
    },

    idToClassType: function (id) {
      let list = this.classTypes;
      for (let i = 0; i < list.length; i++) {
        if (list[i].id == id) {
          return list[i].name;
        }
      }
      return id
    },

    dicToId: function (name) {
      let dict =this.$store.state.dict.dicts["coreItemType"];
			if(dict==undefined){
					return 0
			}
			for(let i=0;i<dict.length;i++){
				if(dict[i].label==name){
					return dict[i].value;
				}
      }
      return 0
    },

    idToDic: function (id) {
      let dict =this.$store.state.dict.dicts["coreItemType"];
			if(dict==undefined){
					return id
			}
			for(let i=0;i<dict.length;i++){
				if(dict[i].value==id){
					return dict[i].label;
				}
      }
      return id
    } 
  },


  created () {
    //this.findDeptTree()
    this.initColumns()
    this.findClassTypes()
  },
  watch:{
		$UpLoadFileVisible(to,from){
      console.log(to);
      console.log(from);
    },
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
