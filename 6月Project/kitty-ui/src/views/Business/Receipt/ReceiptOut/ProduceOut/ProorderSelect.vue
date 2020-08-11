<template>
  <div class="page-container">
    <!--工具栏-->
    <el-dialog title="生产订单" width="50%" :visible.sync="itemDialogVisible"    :before-close="handleClose" >
	
      <div class="toolbar" style="float:left;padding-top:10px;padding-left:15px;">
          <el-form :inline="true"  :model="filters"  :size="size">
          <el-form-item>
            <el-input v-model.trim="filters.soNo"  placeholder="请输入订单号"></el-input>
          </el-form-item>
          <el-form-item>
            <kt-button icon="fa fa-search"
                      :label="$t('action.search')"
                      perms="material:item:view"
                      type="primary"
                      @click="findPage(null)" />
          </el-form-item>
        
        </el-form>
      </div>
      <!--表格内容栏-->
      <item-kt-table2 :height="350" :data="pageResult" :columns="filterColumns" @findPage="findPage" permsSelect="sys:user:delete"
    @handleSelect="handleSelect"  :showBatchDelete="!this.showOrder" :showOperation="!this.showOrder"> </item-kt-table2>

      <div slot="footer" class="dialog-footer">
			<el-button :size="size" @click.native="handleClose">{{$t('action.cancel')}}</el-button>
		</div>
    </el-dialog>
  </div>
</template>

<script>
import PopupTreeInput from "@/components/PopupTreeInput"
import ItemKtTable2 from "./ItemKtTable2"
//import ItemKtTable2 from "@/views/Core/ItemKtTable2"
import KtButton from "@/views/Core/KtButton"

import { format } from "@/utils/datetime"
export default {
  components: {
    PopupTreeInput,
    ItemKtTable2,
    KtButton
  },
  props:{
      items:String,
      showOrder:{
			type: Boolean
    },
	    itemDialogVisible:{
			type: Boolean
		}
	},
  data () {
    return {
      size: 'small',
      filters: {
        soNo: '',
        items:''
      },
      columns: [],
      filterColumns: [],
      pageRequest: { pageNum: 1, pageSize: 10 },
      pageResult: {},
      // 新增编辑界面数据
      editLoading:false,
      classTypes: []
    }
  },
  methods: {
    //获取分页数据
    findPage: function (data) {
      if (data !== null) {     
        this.filters.pageNum = data.pageRequest.pageNum
        this.filters.pageSize = data.pageRequest.pageSize
        this.filters.items = this.items;
      }
      this.$api.produce.findPage(this.filters).then((res) => {
        this.pageResult = res.data
      }).then(data != null ? data.callback : '')

    },
    // 批量选择
    handleSelect: function (data) {
        this.$emit('handleSelect', data)
    },
    //加载物料类别分类
    findClassTypes: function () {
      this.$api.classify.findPage().then((res) => {
        this.classTypes = res.data.content
       
      })
    },
    handleClose:function(){
        this.$emit('itemHidden', {})
    }
  },
  mounted () {

      this.columns = [
        //{ prop: "id", label: "id", minWidth: 100 },
        { prop: "soNo", label: "订单号", minWidth: 100 },
        { prop: "srcSoBill", label: "来源单号", minWidth: 100 },
        //{ prop: "applicantCode", label: "applicantCode", minWidth: 100 },
        //{ prop: "applicantName", label: "applicantName", minWidth: 100 },
        { prop: "status", label: "状态", minWidth: 100 }
      ]
      this.filterColumns = this.columns
      //this.findClassTypes()
  }
}
</script>

<style scoped>
</style>