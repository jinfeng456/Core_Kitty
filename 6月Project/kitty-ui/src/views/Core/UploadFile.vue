<template>
  <div class="page-container"> 
    <!--上传界面-->
    <el-dialog title="Excel导入"
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
          ref="pathClear"
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
import KtButton from "@/views/Core/KtButton"
import { export_json_to_excel } from "@/excel/Export2Excel"
import XLSX from "xlsx";
export default {
  components: {
    KtButton
  },
  props: {
    UpLoadFileVisible:  {  // 是否显示操作组件
      type: Boolean,
      default: false
    },
    second: {
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
      PercentageValue:0,
      editLoading: false,
      clock:null,
      tableData:[]
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
    sendCode(xd = 10) { 
      this.clock = window.setInterval(() => {
        var pval = parseInt(this.PercentageValue + 1 * (100 / xd));
        pval = pval > 98 ? 99 : pval;
        this.PercentageValue = pval;
      }, 1000);  
    },
    //上传提交
    submitForm: function () {    
        this.editLoading = true;
        if(this.$refs.pathClear.value==''){
            this.$message({ message: "请选择文件!", type: 'error' })
                      this.editLoading = false
                      return;
        }
        if(this.tableData.length>2000){
                      this.$message({ message: "导入数据不能超过2000条!", type: 'error' })
                      this.editLoading = false
                      return;
                  }           
        this.sendCode(this.second);
        this.$emit('ImportExcelData', this.tableData)
        this.editLoading = false
    }, 
    //上传取消
    cancel: function () {
        this.$emit('cancel')
    }, 
    getKey: function (arg) {
      return this.$t(arg)
    }, 
  },
  created () {
    //当倒计时小于0时清除定时器
    window.clearInterval(this.clock); //关闭
  },
  watch: {
    UpLoadFileVisible (val, oldVal) {
      if (val== false) {
        window.clearInterval(this.clock); //关闭
        this.PercentageValue=0;
        this.$refs.pathClear.value ='' ;
      }
    }
  }
}
</script>

<style scoped>
</style>