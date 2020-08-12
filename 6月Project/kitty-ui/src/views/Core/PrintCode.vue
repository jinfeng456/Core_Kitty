<template>
  <div class="page-container">
    <!--工具栏-->
    <el-dialog title="打印物料二维码"
               width="90%"
               :visible.sync="itemDialogVisible"
                @opened="findPage"
                 :close-on-click-modal="false"
               :before-close="handleClose">
                
  <!--表格显示列界面-->
      <table-column-filter-dialog ref="tableColumnFilterDialog"
                                  :columns="columns"
                                  @handleFilterColumns="handleFilterColumns">
      </table-column-filter-dialog>

    <!--表格内容栏-->
    <kt-table3 :myButtons="myButtons"
                permsDelete="core:receiptout:delete"
               :data="pageResult"
               :columns="filterColumns"
               @findPage="findPage" 
               @handleEdit="handleEdit"
               @handleEdit1="handleEdit1"
               @handleDelete="handleDelete"
               :pageRequest="this.pageRequest">
    </kt-table3>   
      <!-- 表格内容栏
      <item-kt-table :height="350"
                     :data="pageResult"
                     :columns="columns"
                     @findPage="findPage"
                     permsSelect="sys:user:delete"
                     @handleSelect="handleSelect">
      </item-kt-table> -->

      <div slot="footer"
           class="dialog-footer">
        <el-button :size="size"
                   @click.native="handleClose">{{$t('action.cancel')}}</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import PopupTreeInput from "@/components/PopupTreeInput"
import ItemKtTable from "@/views/Core/ItemKtTable"
import KtButton from "@/views/Core/KtButton"
import KtTable3 from "@/views/Core/KtTable3"
import { format } from "@/utils/datetime"
import { getLodop } from "@/utils/LodopFuncs"
import { printSelected } from "@/utils/print"
import { printMoudle } from "@/utils/print"
export default {
  components: {
    PopupTreeInput,
    ItemKtTable,
    KtButton,
    KtTable3
  },
  props: {
    wmsBanchNo: {  // 供应商主键
      type: String
    },
    itemDialogVisible: {
      type: Boolean
    }
  },
  data () {
    return {
      size: 'small',
      filters: {
        wmsBanchNo: ''
      },
       myButtons: [{
        name: "handleEdit",
        perms: "core:receiptout:edit",
        label: "打印",
        icon: "fa fa-edit"
      }
     ],
      dicts:this.$store.state.dict.dicts,
      columns: [],
      filterColumns: [],
      pageRequest: { pageNum: 1, pageSize: 10 },
      pageResult: {},
      dicts:this.$store.state.dict.dicts,
      // 新增编辑界面数据
      editLoading: false,
      dataForm: {
        id: 0,
        //classifyId: ,
        code: '',
        name: '',
        active: 0
      },
      classTypes: []
    }
  },

  methods: {
    //获取分页数据
    findPage: function (data) {

      this.filters.wmsBanchNo = this.wmsBanchNo
      if (data !== null) {
        this.filters.pageNum = data.pageRequest.pageNum
        this.filters.pageSize = data.pageRequest.pageSize
      }
     
      //得到二维码信息
          this.$api.coreStock.GetCodeInfo(this.filters).then((res) => {
          this.pageResult = res.data
        
        }).then(data != null ? data.callback : '')



    },
       LODOPL: function () {
                    var LODOP = getLodop();
                        return LODOP;
                        //layer.msg("请下载Lodop插件", { icon: 5 });
        },
          // 批量删除
    handleDelete: function (data) {

         let dict =this.$store.state.dict.dicts["systenParam"];
         let dataForm = {baseUrl:dict[0].descriptions,dataArr:data.params}
       
        this.$api.CodePrints.code(dataForm).then((res) => {	})
    },
    // 显示添加界面
		handleEdit: function (params) {	
       let item =params.row


        let ids=[]

          ids.push({itemName:item.itemName,wmsBanchNo:item.wmsBanchNo
        ,countDb:item.countDb,modelSpecs:item.modelSpecs
        ,itemCode:item.itemCode,fromCorpBatchNo:item.fromCorpBatchNo
        ,packUnit:item.packUnit,exp:item.exp
        ,barCode:item.barCode})
     let dict =this.$store.state.dict.dicts["systenParam"];
     let dataForm = {baseUrl:dict[0].descriptions,dataArr: ids}
      	
    
      
     
			// a.click();
   		this.$api.CodePrints.code(dataForm).then((res) => {
         
      //       this.editLoading = false
      //       var html=res.data;
      //       var info1="规格型号：CSS为HTML标记语言提供了一种样式描述，定义了其中元素的显示方式。"+this.dataForm.packageSpec+"<br>物料编码："+this.dataForm.itemCode+"<br>内部批号："+this.dataForm.wmsBanchNo+"<br>供应商批号："+this.dataForm.FromCorpBatchNo+"<br>";
      //       var info2="<br>&nbsp;&nbsp;物料名称："+this.dataForm.itemName+"<br>&nbsp;&nbsp;数&nbsp;&nbsp; &nbsp;&nbsp; 量："+this.dataForm.countDb+"<br>&nbsp;&nbsp;单 &nbsp;&nbsp;&nbsp;&nbsp; 位："+this.dataForm.packUnit+"<br>&nbsp;&nbsp;有效期至：";    
      //       var info3= this.dataForm.packageSpec+"/"+this.dataForm.itemCode+"/"+this.dataForm.wmsBanchNo+"/"+this.dataForm.FromCorpBatchNo+"/"+this.dataForm.itemName+"/"+this.dataForm.countDb+"/"+this.dataForm.packUnit;  
           
      //            html = html.replace("{Content1}", info1);
      //            html = html.replace("{Content2}", info2);
      //            html = html.replace("{Content3}", info3);
      //            //var LODOP = this.LODOPL();
			// 						// LODOP.PRINT_INIT("");
			// 						// LODOP.NewPage(); 
      //             // LODOP.PRINT_INIT("入库单")
                  
			// 						// LODOP.ADD_PRINT_HTM(0, 0, "80mm", "60mm", html);
			// 						// //if (type === 1) {
			// 						// 	//LODOP.PREVIEW();
			// 						// 	LODOP.PRINT_DESIGN();
			// 						// // } else {
      //               debugger
      //             printMoudle(html);
                
          
			// 			if (res.code == 200) {
			// 			this.$message({ message: this.getKey('action.operateSucess'), type: 'success' })
			// 			/* this.dialogVisibles = true
			// 			this.$refs['dataForm'].resetFields() */
			// 			} else {
			// 			this.$message({ message: this.getKey('action.operateFail') + res.msg, type: 'error' })
      //       }
      //       	this.editDialogVisible = false
			// 			this.findPage(null)
			 		})
				
     
    },
   // 处理表格列过滤显示
    handleFilterColumns: function (data) {
      this.filterColumns = data.filterColumns
      this.$refs.tableColumnFilterDialog.setDialogVisible(false)
    },
     // 时间格式化
    dateFormat: function (row, column, cellValue, index) {
      return format(row[column.property])
    },
      selectionFormats: function (row, column, cellValue, index){
			let key=""
			let propt=column.property;
			if(propt=="coreItemType"){
				key="coreItemType"
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
  //国际化
		getKey: function (arg) {
			return this.$t(arg)
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
    // 批量删除
    handleSelect: function (data) {
      this.$emit('handleSelect', data)
    },
 
    handleClose: function () {
      this.$emit('itemHidden', {})
    },

    created () {

         
    }
  },
  mounted () {

    this.columns = [
      { prop: "itemName", label: "物料名称", minWidth: 100 },
      { prop: "wmsBanchNo", label: "内部批号", minWidth: 100},
      { prop: "countDb", label: "数量", minWidth: 100 },
      { prop: "modelSpecs", label: "规格型号", minWidth: 100 },
      { prop: "itemCode", label: "物料编码", minWidth: 100 },
      { prop: "fromCorpBatchNo", label: "供应商批次号", minWidth: 120 },     
      { prop: "packUnit", label: "单位", minWidth: 80 },
      // { prop: "validTime", label: "有效期", minWidth: 100, formatter: this.dateFormat  }
    ]
     this.filterColumns = this.columns;
    //this.filterColumns = JSON.parse(JSON.stringify(this.columns));
  }

}

</script>

<style scoped>
</style>
