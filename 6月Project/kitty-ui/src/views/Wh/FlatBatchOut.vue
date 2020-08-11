<template>
  <div class="container">
    <!--工具栏-->
    <div class="toolbar" style="float:left;padding-top:10px;padding-left:15px;">
      <el-form :inline="true" :model="filters" :size="size">
        <el-form-item>
          <el-input v-model.trim="filters.batchNo" placeholder="内部批号"></el-input>
        </el-form-item>
        <el-form-item>
          <el-input v-model.trim="filters.itemName" placeholder="产品名称"></el-input>
        </el-form-item>
        <el-form-item prop="businessStatus">
          <el-select
            v-model="filters.businessStatus"
            :placeholder="$t('请选择检验状态')"
            style="width: 100%;"
            clearable
          >
            <el-option
              v-for="item in dicts.batchStatus"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item>
          <kt-button
            :label="$t('action.search')"
            perms="wh:batch:view"
            type="primary"
            @click="findPage(null)"
          />
          <!-- <kt-button
            label="同步批次"
            perms="wh:batch:sync"
            type="primary"
            @click="synchronization(null)"
          /> -->
        </el-form-item>
      </el-form>
    </div>
    <kt-table2
      :myButtons="myButtons"
      :data="pageResult"
      :columns="columns"
      @findPage="findPage"
      @handleEdit="handleEdit"
      @handleOut="handleOut"
      :showPagination="true"
      :showBatchDelete="false" :pageRequest="this.pageRequest"
    ></kt-table2>
    <!--新增编辑界面-->
    <el-dialog
      :title="operation?'编辑平库出库':'编辑平库出库'"
      width="40%"
      :visible.sync="editDialogVisible"
      :close-on-click-modal="false"
    >
      <el-form :model="dataForm" label-width="80px" ref="dataForm" :rules="dataFormRules" :size="size">
        <el-form-item label="id" prop="id" v-if="false">
          <el-input v-model="dataForm.id" auto-complete="off"></el-input>
        </el-form-item>

        <el-form-item label="出库数量" prop="finshCount">
          <el-input  v-model="dataForm.finshCount" auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input
            v-model="dataForm.remark"
            type="textarea"
            placeholder="请输入多行文本"
            :autosize="{minRows: 4, maxRows: 4}"
            :style="{width: '100%'}"
          > </el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button :size="size" @click.native="editDialogVisible = false">{{$t('action.cancel')}}</el-button>
        <el-button
          :size="size"
          type="primary"
          @click.native="submitForm"
          :loading="editLoading"
        >{{$t('action.submit')}}</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import KtTable from "@/views/Core/KtTable";
import KtButton from "@/views/Core/KtButton";
import { format } from "@/utils/datetime";
import { formatDay } from "@/utils/datetime"
import KtTable2 from "@/views/Core/KtTable2";
export default {
  components: {
    KtTable,
    KtButton,
    KtTable2
  },
  data() {
  let validatorIdNumber =  (rule, value, callback) =>{
  
      if(!value){
        callback()
      }
      else  if(value.length>25) {
            return callback(new Error ('备注太长'))
        }
        
		else {
  
           callback()
        }
    }
    let validatorIdNumber1 =  (rule, value, callback) =>{
  
     var numReg = /^[0-9]*$/
     
      if(!value){
        
        return callback(new Error('请输入出库数量'))
      }
      else  if(!numReg.test(value)) {
      
            return callback(new Error ('出库数量不是数字'))
        }
        
		else {
  
           callback()
        }
    }
    return {
      size: "small",
      filters: {
        batchNo: "",
        whAreaId:1111111111
      },
      columns: [
        //{prop:"id", label:"编号", minWidth:100},
        //{prop:"itemId", label:"物料类别", minWidth:100},
        { prop: "itemName", label: "产品名称", minWidth: 100 },
        { prop: "count", label: "数量", minWidth: 100 },
        { prop: "batchNo", label: "内部批号", minWidth: 100 },
        {
          prop: "businessStatus",
          label: "检验状态",
          minWidth: 100,
          formatter: this.selectionFormat
        },
        {
          prop: "businessExp",
          label: "有效期",
          minWidth: 100,
          formatter:this.dateFormatDay
        },
        {
          prop: "retestDate",
          label: "复检期",
          minWidth: 100,
          formatter:this.dateFormatDay
        },
        {
          prop: "releaseDate",
          label: "放行日期",
          minWidth: 100,
          formatter:this.dateFormatDay
        }    
        // {
        //   prop: "frozen",
        //   label: "是否冻结",
        //   minWidth: 100,
        //   formatter: this.selectionFormat
        // }
      ],
      pageRequest: { pageNum: 1, pageSize: 8 },
      pageResult: {},
      dicts: {},
      operation: false, // true:新增, false:编辑
      editDialogVisible: false, // 新增编辑界面是否显示
      editLoading: false,
      auditFormRules: {
        auditPassword: [
          { required: true, message: "请输入电子密码", trigger: "blur" }
        ]
      },
      // 新增编辑界面数据
      dataForm: {
        id: null,
        itemId: null,
        businessExp: null,
        count: null,
        batchNo: null,
        businessStatus: null,
        businessExp: null,
        retestDate: null,
        frozen: null,
        finishCount:0,
        releaseDate:null,
        remark:null
      },
      auditForm: {
        id: null,
        auditType: 1, //这里暂时订1 QA 修改批次状态
        auditId: null,
        status: null,
        auditInfo: null,
        auditPassword: null
      },
      myButtons: [
        {
          name: "handleEdit",
          perms: "wh:batch:edit",
          label: "出库",
          icon: "fa fa-edit"
        }
        // ,{
        // 	name:"handleOut",
        // 	perms:"wh:batch:out",
        // 	label:"出库",
        // 	type:"danger",
        // 	icon:"fa fa-trash"
        // }
      ],
      dataFormRules: {
                    finshCount:[{required: true,trigger: 'blur',validator: validatorIdNumber1}],
                    remark:[{required: false,trigger: 'blur',validator: validatorIdNumber}],
                   
                },
    };
  },
  //   computed: {
  //   dataFormRules () {
  //     const dataFormRules = {        finshCount: [{ required: true, message: "请输入出库数量", trigger: 'blur' }],
  //                                     remark:[{ required: false,  trigger: 'blur',validator: validatorIdNumber }],
  //     };
  //     return dataFormRules;
  //   }
  // },
  methods: {
 
    // 获取分页数据
    findPage: function(data) {
      if(data!==null){
				this.filters.pageNum=data.pageRequest.pageNum		
			}else{
				this.filters.pageNum=1
			}
			this.filters.pageSize=this.pageRequest.pageSize 
      this.$api.batch
        .findPage(this.filters)
        .then(res => {
          this.pageResult = res.data;
       
        })
        .then(data != null ? data.callback : "");
    },
    //同步
    // synchronization: function() {
    //   this.$confirm("确认同步吗？", "提示", {}).then(() => {
    //     this.$api.batch.synchronization().then(res => {
    //       if (res.code == 500) {
    //         this.$message({ message: "同步失败, " + res.msg, type: "error" });
    //       } else {
    //         this.$message({ message: "同步成功", type: "success" });
    //       }
    //     });
    //   });     
    // },
    // 批量删除
    handleOut: function(data) {
      this.$api.batch
        .batchDelete(data.params)
        .then(data != null ? data.callback : "");
    },
    // 显示新增界面
    handleAdd: function() {
      this.editDialogVisible = true;
      this.operation = true;
      this.dataForm = {
        id: null,
        itemId: null,
        businessExp: null,
        count: null,
        batchNo: null,
        businessStatus: null,
        retestDate: null,
        frozen: null,
        releaseDate:null
      };
    },
    // 时间格式化
      	dateFormatDay: function (row, column, cellValue, index){
          	return formatDay(row[column.property])
      	},
    // 显示编辑界面
    handleEdit: function(params) {
      this.editDialogVisible = true;
      this.operation = false;
      this.dataForm = Object.assign({}, params.row);
      this.auditForm.auditId = this.dataForm.id;
      this.auditForm.status = this.dataForm.businessStatus;
      this.auditForm.auditType = 1;
      //查询审核意见
      this.$api.audit.GetByAuditId(this.dataForm).then(res => {
        this.auditForm.auditInfo = res.data[0].auditInfo;
        this.auditForm.id = res.data[0].id;
      });
    },
    // 编辑
     submitForm: function () {
      this.$refs.dataForm.validate((valid) => {
  
        if (valid) {
       
          this.$confirm(this.getKey('action.isConfirm'), this.getKey('action.tips'), {}).then(() => {
         
            this.editLoading = true
            let data = Object.assign({}, this.dataForm)

            this.$api.batch.FlatOut(data).then((res) => {
 
              //this.editLoading = false
              if (res.code == 200) {
                this.$message({ message: this.getKey('action.operateSucess'), type: 'success' })
                this.editDialogVisible = false
                this.$refs['dataForm'].resetFields()
              } else {
                this.$message({ message: this.getKey('action.operateFail') + res.msg, type: 'error' })
              }
               this.editLoading = false
              this.findPage(null)
            })
          })
        }
      })
    },

    selectionFormat: function(row, column, cellValue, index) {
      let key = "";
      let propt = column.property;
      if (propt == "businessStatus") {
        key = "batchStatus";
      } else if (propt == "frozen") {
        key = "isLocked";
      }
      let val = row[column.property];
      let dict = this.$store.state.dict.dicts[key];
      if (dict == undefined) {
        return row[column.property];
      }
      for (let i = 0; i < dict.length; i++) {
        if (dict[i].value == val) {
          return dict[i].label;
        }
      }
      return row[column.property];
    },
    //国际化
    getKey: function(arg) {
      return this.$t(arg);
    },
    // 时间格式化
    dateFormat: function(row, column, cellValue, index) {
      return format(row[column.property]);
    }
  },
    watch:{

    editDialogVisible(to,from){
       if (this.$refs['dataForm'] !== undefined) {
            this.$refs["dataForm"].resetFields();
          }
    }
  },
  mounted() {
    this.dicts = this.$store.state.dict.dicts;
  }
};

</script>

<style scoped>
</style>