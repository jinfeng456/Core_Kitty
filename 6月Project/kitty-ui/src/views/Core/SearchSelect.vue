<template>
<el-autocomplete  popper-class="my-autocomplete" v-model="state" 
:fetch-suggestions="querySearch"  placeholder="请输入内容"  @select="handleSelect">
  <i class="el-icon-edit el-input__icon" slot="suffix" >
  </i>
  <template slot-scope="{ item }">
    <div class="name">{{ item.name }}</div>

  </template>
</el-autocomplete>
</template>


<script>
  export default {
    data() {
      return {
       
      };
    },


  props: {
    itemlist: Array, 
     state:{  // 文本对齐方式
      type: String,
      default: ''
    }
  },
    methods: {
      querySearch(queryString, cb) {
        var itemlist = this.itemlist;
        //debugger
        var results = queryString ? itemlist.filter(this.createFilter(queryString)) : itemlist;
        // 调用 callback 返回建议列表的数据
        cb(results);
      },
      createFilter(queryString) {
        return (restaurant) => {
          return (restaurant.name.toLowerCase().indexOf(queryString.toLowerCase()) != -1);
        };
      },
      handleSelect(item) {          
        this.state = item.name;
          this.$emit('itemChange', item)
      }
    },
    watch:{
      state(val,oldVal){  
          if(val.length==0){
            this.$emit('itemChange', [])          
          }
      }
    }
    
  }
</script>

<style scoped lang="scss">
.my-autocomplete {
  li {
    line-height: normal;
    padding: 7px;

    .name {
      text-overflow: ellipsis;
      overflow: hidden;
    }
    .addr {
      font-size: 12px;
      color: #b4b4b4;
    }

    .highlighted .addr {
      color: #ddd;
    }
  }
}
</style>