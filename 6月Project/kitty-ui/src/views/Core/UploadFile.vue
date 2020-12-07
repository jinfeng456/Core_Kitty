<template>
  <div class="page-container"> 
    <!--上传界面-->
    <el-dialog :title="operation?'Excel导入':'Excel导入'"
               width="40%"
               :visible.sync="UpLoadFileVisible"
               :close-on-click-modal="false" :before-close="cancel">
      <label for="import">导入</label>
      
      <input
          type="file"
          id="import"
          @change="handleImport"
          accept=".csv, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,
          application/vnd.ms-excel"
      />
      <div slot="footer"
           class="dialog-footer">
        <el-button :size="size"
                   @click.native="cancel">{{$t('action.cancel')}}</el-button>
        <el-button :size="size"
                   type="primary"
                   @click.native="submitForm" :loading="editLoading">上传</el-button>     
      </div>
      <div>
          <el-progress :text-inside="true" :stroke-width="26" :percentage="this.PercentageValue"></el-progress>
      </div>
      
    </el-dialog>

    
  </div>
</template>

<script>
import PopupTreeInput from "@/components/PopupTreeInput"
import KtButton from "@/views/Core/KtButton"
import TableColumnFilterDialog from "@/views/Core/TableColumnFilterDialog"
import { format } from "@/utils/datetime"
import { export_json_to_excel } from "@/excel/Export2Excel"
import XLSX from "xlsx";
export default {
  components: {
    PopupTreeInput,
    KtButton,
    TableColumnFilterDialog
  },
  props: {
    UpLoadFileVisible:  {  // 是否显示操作组件
      type: Boolean,
      default: false
    },
    PercentageValue: {
      type:Number,
      default: 0
    }
  },
  data () {
    return {
      size: 'small',
      filters: {
        name: ''
      },
      columns: [],
      filterColumns: [],
      pageRequest: { pageNum: 1, pageSize: 10 },
      pageResult: {},
      isShow:true,
      operation: false, // true:新增, false:编辑
      //UpLoadFileVisible: false, // 新增编辑界面是否显示
      editLoading: false,
      dicts:this.$store.state.dict.dicts,
      // 新增编辑界面数据
      dataForm: {
        id: 0,
        //classifyId: ,
        code: '',
        name: '',
        active: 0
      },
      classTypes: [],
      tableData:[]
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
      /**
       *  导入excel的input的change 函数
       *  @event 事件对象
       */
      handleImport(event) {
          // FileReader 对象允许Web应用程序异步读取存储在用户计算机上的文件（或原始数据缓冲区）的内容
          let fileReader = new FileReader();
          var file = event.currentTarget.files[0];
          // 回调函数
          fileReader.onload = ev => {
              try {
                  let data = ev.target.result;
                  let workbook = XLSX.read(data, {
                      type: "binary"
                  });
                  // excel读取出的数据
                  let excelData= XLSX.utils.sheet_to_json(
                      workbook.Sheets[workbook.SheetNames[0]]
                  );
                  this.tableData = excelData;            
              } catch (e) {
                  window.alert("文件类型不正确！");
                  return false;
              }
          };
          // 读取文件 成功后执行上面的回调函数
          fileReader.readAsBinaryString(file);
      },
    //新增
    submitForm: function () {
      	this.editLoading = true
        this.$emit('ImportExcelData', this.tableData)
        this.editLoading = false
    }, 
    cancel: function () {
        this.$emit('cancel')
    }, 
    // 时间格式化
    dateFormat: function (row, column, cellValue, index) {
      return format(row[column.property])
    },
    getKey: function (arg) {
      return this.$t(arg)
    }, 
  },
  created () {
    //this.findDeptTree()
    //this.initColumns()
    //this.findClassTypes()
  }
}
</script>

<style scoped>
</style>