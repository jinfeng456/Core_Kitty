<template>
  <div class="page-container">
    <!--工具栏-->
    <div class="toolbar"
         style="float:left;padding-top:10px;padding-left:15px;">
      <el-form :inline="true"
               :model="filters"
               :size="size">
        <el-form-item>
          <el-input v-model="filters.urlName"
                    :placeholder="'路径'"></el-input>
        </el-form-item>
        <el-form-item>
          <kt-button icon="fa fa-search"
                     :label="$t('action.search')"
                     perms="sys:log:view"
                     type="primary"
                     @click="findPage(null)" />
        </el-form-item>
      </el-form>
    </div>
    <!--表格内容栏-->
    <kt-table2 permsEdit="core:receiptout:edit"
               permsDelete="core:receiptout:delete"
               :myButtons="myButtons"
               :data="pageResult"
               :columns="columns"
               @findPage="findPage"
               @handleEdit="handleEdit" :pageRequest="this.pageRequest">
    </Kt-table2>
    <!--新增编辑界面-->
    <el-dialog :title="operation?'日志 —— 新增':'日志 —— 查看'"
               width="70%"
               :visible.sync="dialogVisible"
               :close-on-click-modal="false">
      <el-form :model="dataForm"
               label-width="70px"
               :rules="dataFormRules"
               ref="dataForm"
               :size="size"
               label-position="right">


    <el-row>
 <el-col :span="12">

        <el-form-item :label="'用户'"  prop="user">
          <el-input v-model="dataForm.user"  auto-complete="off"></el-input>
        </el-form-item>
 </el-col>
  <el-col :span="12">
        <el-form-item :label="'路径'"
                      prop="urlName">
          <el-input v-model="dataForm.urlName"
                    auto-complete="off"></el-input>
        </el-form-item>
  </el-col>
   </el-row>
 <el-row>
 <el-col :span="24">
        <el-form-item :label="'参数'"  prop="param">
          <el-input  type="textarea" v-model="dataForm.param" :rows="8"
                    auto-complete="off"></el-input>
        </el-form-item>
 </el-col>
 </el-row>

  <el-row>
      <el-col :span="24">
        <el-form-item :label="'结果'" prop="result">
          <el-input type="textarea"  v-model="dataForm.result" :rows="10"
                    auto-complete="off" ></el-input>
        </el-form-item>

         </el-col>
 </el-row>

  <el-row>
        <el-col :span="12">
        <el-form-item :label="'时间'"  prop="dt">
          <el-input v-model="dataForm.dt"
                    auto-complete="off" ></el-input>
        </el-form-item>
        </el-col>
         <el-col :span="12">
        <el-form-item :label="'ip'"  prop="ip">
          <el-input v-model="dataForm.ip"
                    auto-complete="off" ></el-input>
        </el-form-item>
         </el-col>
  </el-row>
      </el-form>
      <div slot="footer"
           class="dialog-footer">
        <el-button :size="size"
                   @click.native="dialogVisible = false">{{'确认'}}</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import KtTable2 from "@/views/Core/KtTable2"
import KtButton from "@/views/Core/KtButton"
import { format } from "@/utils/datetime"

export default {
  components: {
    KtTable2,
    KtButton
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
      operation: false, // true:新增, false:编辑
      dialogVisible: false, // 新增编辑界面是否显示
      editLoading: false,
      dataForm: {
        id: 0,
        name: '',
        type: '',
        code: ''
      },
      filters: {
        name: ''
      },
      myButtons: [{
        name: "handleEdit",
        perms: "core:receiptout:edit",
        label: "查看",
        icon: "fa fa-edit"
      }],
      columns: [
        { prop: "ip", label: "log.ip", minWidth: 120 },
        { prop: "urlName", label: "log.urlName", minWidth: 120 },
        { prop: "user", label: "log.user", minWidth: 60 },
        { prop: "dt", label: "log.dt", minWidth: 80 },
        //{ prop: "result", label: "log.result", minWidth: 560 },
      ],
      pageResult: {},
      showOperation: true
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
        this.pageRequest.pageNum=1
			}
			this.filters.pageSize=this.pageRequest.pageSize
      this.$api.log.findPage(this.filters).then((res) => {
        this.pageResult = res.data
     
      }).then(data != null ? data.callback : '')
    },
    // 显示编辑界面
    handleEdit: function (params) {
          
      this.dialogVisible = true
      this.operation = false
      var data = Object.assign({}, params.row);
       data.result=this.formatJson( data.result);
      this.dataForm = data
      

     
    },

     formatJson : function (json) {
        var outStr = '',    
            padIdx = 0,     
            space = '     ';  
        
      
        json = json.replace(/([\{\}\[\]])/g, '\r\n$1\r\n')          
                    .replace(/(\,)/g, '$1\r\n')
                    .replace(/(\r\n\r\n)/g, '\r\n'); 
       (json.split('\r\n')).forEach(function (node, index) {
            var indent = 0,
                padding = '';
            if (node.match(/[\{\[]/)){
              indent = 1;
            }else if (node.match(/[\}\]]/)){
              padIdx = padIdx !== 0 ? --padIdx : padIdx;
            }else{
              indent = 0;
            }    
            for (var i = 0; i < padIdx; i++){
              padding += space;
            }    
            outStr += padding + node + '\r\n';
            padIdx += indent;
        });
        return outStr;
    },
    submitForm: function () {
      window.close();
    },
    getKey: function (arg) {
      return this.$t(arg)
    },
    // 时间格式化
    dateFormat: function (row, column, cellValue, index) {
      return format(row[column.property])
    }
  },
  mounted () {
  }
}
</script>

<style scoped>
</style>