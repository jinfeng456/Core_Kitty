<template>
  <div>
    <!--表格栏-->
    <el-table :data="data.content" :highlight-current-row="highlightCurrentRow" @selection-change="selectionChange" 
          @current-change="handleCurrentChange" v-loading="loading" :element-loading-text="$t('action.loading')" :border="border" :stripe="stripe"
          :show-overflow-tooltip="showOverflowTooltip" :max-height="maxHeight" :height="height" :size="size" :align="align" style="width:100%;" >
      <el-table-column type="selection" width="40" v-if="showBatchDelete & showOperation"></el-table-column>
       <!-- 序号 -->
      <el-table-column :label="$t('action.desc')" width="50" fixed="left" v-if="true" header-align="center" align="center">
        <template slot-scope="scope">
         <span>{{scope.$index+1}}</span>
        </template>
      </el-table-column>
      <el-table-column v-for="column in columns" header-align="center" align="center"
        :prop="column.prop" :label="$t(column.label)" :width="column.width" :min-width="column.minWidth" 
        :fixed="column.fixed" :key="column.prop" :type="column.type" :formatter="column.formatter"
        :sortable="column.sortable==null?true:column.sortable">
      </el-table-column>
    
      <el-table-column :label="$t('action.operation')" width="100" fixed="right" v-if="showOperation" header-align="center" align="center">
        <template slot-scope="scope">
          <kt-button icon="fa fa-trash" :label="$t('action.Select')" :perms="permsSelect"  :size="size" type="danger" @click="handleSelect(scope.$index, scope.row)" />
        </template>
      </el-table-column>
     
    </el-table>
    <!--分页栏-->
    <div class="toolbar" style="padding:10px;">
      <kt-button :label="$t('action.batchSelect')"  :perms="permsSelect"  :size="size" type="danger" @click="handleBatchSelect()" 
        :disabled="this.selections.length===0" style="float:left;" v-if="showBatchDelete & showOperation"/>
      <el-pagination layout="total, prev, pager, next, jumper" @current-change="refreshPageRequest" 
        :current-page="pageRequest.pageNum" :page-size="pageRequest.pageSize" :total="data.totalSize" style="float:right;" v-if="showPagination">
      </el-pagination>
    </div>
  </div>
</template>

<script>
import KtButton from "@/views/Core/KtButton"
export default {
  name: 'KtTable',
  components:{
			KtButton
	},
  props: {
    columns: Array, // 表格列配置
    data: Object, // 表格分页数据
    permsSelect:String,
    size: { // 尺寸样式
      type: String,
      default: 'mini'
    },
    align: {  // 文本对齐方式
      type: String,
      default: 'left'
    },
    maxHeight: {  // 表格最大高度
      type: Number,
      default: 420
    },
    height: {  // 表格最大高度
      type: Number,
      default: 250
    },
    showOperation: {  // 是否显示操作组件
      type: Boolean,
      default: true
    },
    showDetail: {  // 是否显示明细
      type: Boolean,
      default: false
    },
    showDetailandOut:{ //是否显示明细出库
      type: Boolean,
      default: false
    },
    border: {  // 是否显示边框
      type: Boolean,
      default: false
    },
    stripe: {  // 是否显示斑马线
      type: Boolean,
      default: true
    },
    highlightCurrentRow: {  // // 是否高亮当前行
      type: Boolean,
      default: true
    },
    showOverflowTooltip: {  // 是否单行显示
      type: Boolean,
      default: true
    },
    showBatchDelete: {  // 是否显示操作组件
      type: Boolean,
      default: true
    },
    showPagination:{  // 是否显示分页组件
      type: Boolean,
      default: true
    }
  },
  data() {
    return {
      // 分页信息
			pageRequest: {
				pageNum: 1,
        pageSize: 10
      },
      loading: false,  // 加载标识
      selections: []  // 列表选中列
    }
  },
  methods: {
    // 分页查询
    findPage: function () {
        this.loading = true
        let callback = res => {
          this.loading = false
        }
      this.$emit('findPage', {pageRequest:this.pageRequest, callback:callback})    
    },
    // 选择切换
    selectionChange: function (selections) {
      this.selections = selections
      this.$emit('selectionChange', {selections:selections})
    },
    // 选择切换
    handleCurrentChange: function (val) {
      this.$emit('handleCurrentChange', {val:val})
    },
    // 换页刷新
		refreshPageRequest: function (pageNum) {
      this.pageRequest.pageNum = pageNum
      this.findPage()
    },
   
    // 选择
		handleSelect: function (index, row) {
			this.select(row.id)
		},
		// 批量选择
		handleBatchSelect: function () {
			let ids = this.selections.map(item => item.id).toString()
			this.select(ids)
    },

		select: function (ids) {
				// let params = []
				// let idArray = (ids+'').split(',')
				// for(var i=0; i<idArray.length; i++) {
				// 	params.push({'id':idArray[i]})
        // }
        
        this.$emit('handleSelect',ids)
			
		}
  },
  mounted() {
    this.refreshPageRequest(1)
  }
}
</script>

<style scoped>

</style>