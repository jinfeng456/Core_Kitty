<template>
  <div>
    <!--表格栏-->
    <el-table :data="data.content" :highlight-current-row="highlightCurrentRow" @selection-change="selectionChange" 
          @current-change="handleCurrentChange" v-loading="loading" :element-loading-text="$t('action.loading')" :border="border" :stripe="stripe"
          :show-overflow-tooltip="showOverflowTooltip" :max-height="maxHeight" :height="height" :size="size" :align="align" style="width:100%;" >
      <el-table-column type="selection" width="40" v-if="false"></el-table-column>
      <!-- 序号 -->
      <el-table-column :label="$t('action.desc')" width="50" fixed="left"  header-align="center" align="center">
        <template slot-scope="scope">
         <span>{{scope.$index+1}}</span>
        </template>
      </el-table-column>
      <el-table-column v-for="column in columns" header-align="center" align="center"
        :prop="column.prop" :label="$t(column.label)" :width="column.width" :min-width="column.minWidth" 
        :fixed="column.fixed" :key="column.prop" :type="column.type" :formatter="column.formatter"
        :sortable="column.sortable==null?true:column.sortable">
      </el-table-column>     
    </el-table>
  </div>
</template>

<script>
import KtButton from "@/views/Core/KtButton"
export default {
  name: 'KtTableList',
  components:{
			KtButton
	},
  props: {
    columns: Array, // 表格列配置
    data: Object, // 表格分页数据 
    size: { // 尺寸样式
      type: String,
      default: 'mini'
    },
    pageRequest: { // 分页
      type: Object,
      default: {
				pageNum: 1,
        pageSize: 8
      }
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
    }
  },
  data() {
    return {     
      pageRequest:{
				pageNum: 1,
        pageSize: 8   
      },
      loading: false,  // 加载标识
      selections: []  // 列表选中列
    }
  },
  methods: {
    // 选择切换
    selectionChange: function (selections) {
      this.selections = selections
      this.$emit('selectionChange', {selections:selections})
    },
    // 分页查询
    findPage: function () {
        this.loading = true
        let callback = res => {
          this.loading = false
        }
      this.$emit('findPage', {pageRequest:this.pageRequest, callback:callback})
    },
    // 换页刷新
		refreshPageRequest: function (pageNum) {
      this.pageRequest.pageNum = pageNum
      this.findPage()
    },
    // 选择切换
    handleCurrentChange: function (val) {
      this.$emit('handleCurrentChange', {val:val})
    }   
  }
}
</script>

<style scoped>

</style>