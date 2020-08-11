  <!-- 
             -->




<template>

  <div>
    
    <!--表格栏-->
    <el-table :data="data.content" :highlight-current-row="highlightCurrentRow" @selection-change="selectionChange" 
          @current-change="handleCurrentChange" v-loading="loading" :element-loading-text="$t('action.loading')" :border="border" :stripe="stripe"
          :show-overflow-tooltip="showOverflowTooltip" :max-height="maxHeight" :height="height" :size="size" :align="align" style="width:100%;" >
      <el-table-column type="selection" width="40" v-if="showBatchDelete & showOperation"></el-table-column>
     
      <el-table-column :label="$t('action.operation')" width="110" fixed="left" v-if="showGenerate" header-align="center" align="center">
        <template slot-scope="scope">
          <!-- 生成任务 -->
          <kt-button v-if="scope.row.status==1" icon="fa fa-edit" :label="$t('action.generate')" :perms="permsGenerate" :size="size" @click="handleGenerate(scope.$index, scope.row)" />
           <!-- 导出文档 -->
          <kt-button v-if="scope.row.status==3" icon="fa fa-edit" label="导出文档" :perms="permsExport" :size="size" @click="handleExport(scope.$index, scope.row)" />
        </template>
      </el-table-column>
 
      <el-table-column :label="$t('action.operation')" width="110" fixed="left" v-if="showExport" header-align="center" align="center">
        <template slot-scope="scope">
           <!-- 条码导出文档 -->
          <kt-button  icon="fa fa-edit" label="导出文档" :perms="permsExport" :size="size" @click="handleExport(scope.$index, scope.row)" />
        </template>
      </el-table-column>
   
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
      <!-- 显示编辑删除 -->
      <el-table-column :label="$t('action.operation')" width="185" fixed="right" v-if="showOperation" header-align="center" align="center">
       <template slot-scope="scope">
         <kt-button v-for="but in myButtons"  :icon="but.icon" :label="$t(but.label)" :perms="but.perms" 
          :key="but.name" size="mini" :type="but.type" @click="myHandleCommon(scope.$index, scope.row,but.name)" />      
            </template>
      </el-table-column>
    </el-table>
    <!--分页栏-->
    <div class="toolbar" style="padding:10px;">
      <kt-button :label="$t('action.batchDelete')" :perms="permsDelete" :size="size" type="danger" @click="handleBatchDelete()" 
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
    permsEdit: String,  // 编辑权限标识
    permsDelete: String,  // 删除权限标识
    permsRestore:String, //恢复权限标识
    permsDisable:String, //禁用权限标识
    permsOut:String, //出库
    permsGenerate:String, //生成
    myButtons:Array,
    permsExport:String, //导出文档
    size: { // 尺寸样式
      type: String,
      default: 'mini'
    },
    pageRequest: {
      type:Object,
      default:()=>{ 
        return {
          pageNum: 1,
          pageSize: 7
          }  	
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
      default: 375
    },
    showOperation: {  // 是否显示操作组件
      type: Boolean,
      default: true
    },
    showGenerate: {  // 是否显示生成任务和导出文档
      type: Boolean,
      default: false
    },
    showExport: {  // 是否显示导出文档
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
    // 编辑
		myHandleCommon: function (index, row,name) {
   
      if(name=='handleDelete'){
	      this.delete(row.id)
      }else{
         this.$emit(name, {index:index, row:row})
      }
     
		},
    
		// 批量删除
		handleBatchDelete: function () {
			let ids = this.selections.map(item => item.id).toString()
			this.delete(ids)
    },
    //生成任务
  	handleGenerate: function (index, row) {
      this.$emit('handleGenerate', {index:index, row:row})
    },
    //导出文档
    handleExport: function (index, row) {
      this.$emit('handleExport', {index:index, row:row})
    },
		// 删除操作
		delete: function (ids) {
			this.$confirm('确认删除选中记录吗？', '提示', {
				type: 'warning'
			}).then(() => {
				let params = []
				let idArray = (ids+'').split(',')
				for(var i=0; i<idArray.length; i++) {
					params.push({'id':idArray[i]})
        }
        this.loading = true
        let callback = res => {
          if(res.code == 200) {
            this.$message({message: '删除成功', type: 'success'})
            this.findPage()
          } else {
            this.$message({message: '操作失败, ' + res.msg, type: 'error'})
          }
          this.loading = false
        }
        this.$emit('handleDelete', {params:params, callback:callback})
			}).catch(() => {
			})
		}
  },
  mounted() {
    this.refreshPageRequest(1)
  }
}
</script>

<style scoped>

</style>