<template>
  <div class="page-container">
    <!-- 工具栏-->
    <div class="toolbar"
         style="float:left;padding-top:10px;padding-left:15px;">
      <el-form :inline="true"
               :model="filters"
               :size="size">
        <el-form-item>
          <el-input v-model="filters.info"
                    placeholder="日志内容"></el-input>
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
    <kt-table :height="488"
              :data="pageResult"
              :columns="columns"
              :pageRequest="pageRequest"
              :showOperation="showOperation"
              @findPage="findPage" >
    </kt-table>
  </div>
</template>

<script>
import KtTable from "@/views/Core/KtTable"
import KtButton from "@/views/Core/KtButton"
import { format } from "@/utils/datetime"
export default {
  components: {
    KtTable,
    KtButton
  },
  data () {
    return {
      size: 'small',
      filters: {
        id: '',
        info: '',
        time: ''
      },
      columns: [
        { prop: "info", label: "日志内容", minWidth: 350 },
        { prop: "time", label: "时间", minWidth: 40, formatter: this.dateFormat },

      ],
      pageRequest: { pageNum: 1, pageSize: 100 },
      pageResult: {},
      showOperation: false
    }
  },
  methods: {
    // 获取分页数据
    findPage: function (data) {
      if(data!==null){
				this.filters.pageNum=data.pageRequest.pageNum		
			}else{
				this.filters.pageNum=1
			}
			this.filters.pageSize=this.pageRequest.pageSize
      this.$api.wcslog.findPage(this.filters).then((res) => {
        this.pageResult = res.data
      }).then(data != null ? data.callback : '')
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