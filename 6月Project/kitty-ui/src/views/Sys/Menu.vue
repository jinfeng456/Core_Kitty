<template>
  <div class="page-container">
	<!--工具栏-->
	<div class="toolbar" style="float:left;padding-top:10px;padding-left:15px;">
		<el-form :inline="true" :model="filters" :size="size">
			<el-form-item>
				<el-input v-model="filters.name" :placeholder="$t('menu.name')"></el-input>
			</el-form-item>
			<el-form-item>
				<kt-button icon="fa fa-search" :label="$t('action.search')" perms="sys:menu:view" type="primary" @click="findTreeData(null)"/>
			</el-form-item>
			<el-form-item>
				<kt-button icon="fa fa-plus" :label="$t('action.add')" perms="sys:menu:add" type="primary" @click="handleAdd"/>
			</el-form-item>
		</el-form>
	</div>
	<!--表格树内容栏-->
    <el-table :data="tableTreeDdata" stripe size="mini" style="width: 100%;"
      rowKey="id" v-loading="loading" :element-loading-text="$t('action.loading')">
      <!-- <el-table-column
        prop="id" header-align="center" align="center" width="80" label="ID">
      </el-table-column> -->
      <table-tree-column 
        prop="name" header-align="center" treeKey="id" width="260" :label="$t('menu.name')">
      </table-tree-column>
      <el-table-column header-align="center" align="center" :label="$t('menu.icon')">
        <template slot-scope="scope">
          <i :class="scope.row.icon || ''"></i>
        </template>
      </el-table-column>
      <el-table-column prop="dtype" header-align="center" align="center" :label="$t('menu.type')">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.dtype === 0" size="small">{{$t('common.catalog')}}</el-tag>
          <el-tag v-else-if="scope.row.dtype === 1" size="small" type="success">{{$t('common.menu')}}</el-tag>
          <el-tag v-else-if="scope.row.dtype === 2" size="small" type="info">{{$t('common.button')}}</el-tag>
        </template>
      </el-table-column>
      <el-table-column 
        prop="parentName" header-align="center" align="center" width="120" :label="$t('menu.lastMenu')">
      </el-table-column>
      <el-table-column
        prop="url" header-align="center" align="center" width="150" 
        :show-overflow-tooltip="true" :label="$t('menu.menuUrl')">
      </el-table-column>
      <el-table-column
        prop="perms" header-align="center" align="center" width="150" 
        :show-overflow-tooltip="true" :label="$t('menu.authorizationMark')">
      </el-table-column>
      <el-table-column
        prop="orderNum" header-align="center" align="center" :label="$t('menu.sort')">
      </el-table-column>
      <el-table-column
        fixed="right" header-align="center" align="center" width="185" :label="$t('action.operation')">
        <template slot-scope="scope">
          <kt-button icon="fa fa-edit" :label="$t('action.edit')" perms="sys:menu:edit" @click="handleEdit(scope.row)"/>
          <kt-button icon="fa fa-trash" :label="$t('action.delete')" perms="sys:menu:delete" type="danger" @click="handleDelete(scope.row)"/>
        </template>
      </el-table-column>
    </el-table>
    <!-- 新增修改界面 -->
    <el-dialog :title="!dataForm.id ? $t('action.add'):$t('action.edit')" width="40%" :visible.sync="dialogVisible" :close-on-click-modal="false">
      <el-form :model="dataForm" :rules="dataRule" ref="dataForm" @keyup.enter.native="submitForm()" 
        label-width="110px" :size="size" style="text-align:left;">
        <el-form-item :label="$t('menu.menuType')" prop="dtype">
          <el-radio-group v-model="dataForm.dtype">
            <el-radio v-for="(dtype, index) in menuTypeList" :label="index" :key="index">{{ dtype }}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item :label="menuTypeList[dataForm.dtype] + $t('menu.name')" prop="name" >
          <el-input v-model="dataForm.name" :placeholder="menuTypeList[dataForm.dtype] + $t('menu.name')"></el-input>
        </el-form-item>
        <el-form-item :label="$t('menu.lastMenu')" prop="parentName">
            <popup-tree-input 
              :data="popupTreeData" :props="popupTreeProps" :prop="dataForm.parentName==null||dataForm.parentName==''?this.getKey('common.parentMenu'):dataForm.parentName" 
              :nodeKey="''+dataForm.parentId" :currentChangeHandle="handleTreeSelectChange">
            </popup-tree-input>
        </el-form-item>
        <el-form-item v-if="dataForm.dtype !== 0" :label="$t('menu.authorizationMark')" prop="perms">
          <el-input v-model="dataForm.perms" placeholder="如: sys:user:add, sys:user:edit, sys:user:delete"></el-input>
        </el-form-item>
        <el-form-item v-if="dataForm.dtype === 1" :label="$t('menu.menuRoute')" prop="url">
          <el-row>
            <el-col :span="22">
                <el-input v-model="dataForm.url" :placeholder="$t('menu.menuRoute')"></el-input>
            </el-col>
            <el-col :span="2" class="icon-list__tips">
                <el-tooltip placement="top" effect="light" style="padding: 10px;">
                  <div slot="content">
                    <p>URL格式：</p>
                    <p>1.常规业务开发的功能URL，如用户管理，Views目录下页面路径为 /Sys/User, 此处填写 /sys/user。</p>
                    <p>2.嵌套外部网页，如通过菜单打开百度网页，此处填写 http://www.baidu.com，http:// 不可省略。</p>
                    <p>示例：用户管理：/sys/user 嵌套百度：http://www.baidu.com 嵌套网页：http://127.0.0.1:8000</p></div>
                  <i class="el-icon-warning"></i>
                </el-tooltip>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item v-if="dataForm.dtype !== 2" :label="$t('menu.sort')" prop="orderNum">
          <el-input-number v-model="dataForm.orderNum" controls-position="right" :min="0" :label="$t('menu.sort')"></el-input-number>
        </el-form-item>
        <el-form-item v-if="dataForm.dtype !== 2" :label="$t('menu.icon')" prop="icon">
          <el-row>
            <el-col :span="22">
              <!-- <el-popover
                ref="iconListPopover"
                placement="bottom-start"
                trigger="click"
                popper-class="mod-menu__icon-popover">
                <div class="mod-menu__icon-list">
                  <el-button
                    v-for="(item, index) in dataForm.iconList"
                    :key="index"
                    @click="iconActiveHandle(item)"
                    :class="{ 'is-active': item === dataForm.icon }">
                    <icon-svg :name="item"></icon-svg>
                  </el-button>
                </div>
              </el-popover> -->
              <el-input v-model="dataForm.icon" v-popover:iconListPopover :readonly="false" placeholder="菜单图标名称（如：fa fa-home fa-lg）" class="icon-list__input"></el-input>
            </el-col>
            <el-col :span="2" class="icon-list__tips">
              <fa-icon-tooltip />
            </el-col>
          </el-row>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button :size="size"  @click="dialogVisible = false">{{$t('action.cancel')}}</el-button>
        <el-button :size="size"  type="primary" @click="submitForm()">{{$t('action.comfirm')}}</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import KtButton from "@/views/Core/KtButton";
import TableTreeColumn from "@/views/Core/TableTreeColumn";
import PopupTreeInput from "@/components/PopupTreeInput";
import FaIconTooltip from "@/components/FaIconTooltip";
export default {
  components: {
    PopupTreeInput,
    KtButton,
    TableTreeColumn,
    FaIconTooltip
  },
  data() {
    return {
      size: "small",
      loading: false,
      filters: {
        name: ""
      },
      tableTreeDdata: [],
      dialogVisible: false,
    
      dataForm: {
        id: 0,
        dtype: 1,
        name: "",
        parentId: 0,
        parentName: "",
        url: "",
        perms: "",
        orderNum: 0,
        icon: "",
        iconList: []
      },
      dataRule: {
        name: [{ required: true, message: "菜单名称不能为空", trigger: "blur" }]
      },
      popupTreeData: [],
      popupTreeProps: {
        label: "name",
        children: "children"
      }
    };
  },
  computed: {
		dataFormRules() {
			const dataFormRules= {name:[{ required: true, message: this.getKey("user.userInput"), trigger: 'blur' }]
			};
			return dataFormRules;
      },
    menuTypeList(){
     const menuTypeList=[this.getKey("common.catalog"),this.getKey("common.menu"),this.getKey("common.button")];
     return  menuTypeList;
    }
	},	
  methods: {
    // 获取数据
    findTreeData: function() {
      this.loading = true;
      this.$api.menu.findMenuTree().then(res => {
        this.tableTreeDdata = res.data;
        this.popupTreeData = this.getParentMenuTree(res.data);
        this.loading = false;
      });
    },
    // 获取上级菜单树
    getParentMenuTree: function(tableTreeDdata) {
      let parent = {
        parentId: 0,
        name: this.getKey("common.parentMenu"),
        children: tableTreeDdata
      };
      return [parent];
    },
    // 显示新增界面
    handleAdd: function() {
      this.dialogVisible = true;
      this.dataForm = {
        id: 0,
        dtype: 1,
        typeList: ["目录", "菜单", "按钮"],
        name: "",
        parentId: 0,
        parentName: "",
        url: "",
        perms: "",
        orderNum: 0,
        icon: "",
        iconList: []
      };
    },
    // 显示编辑界面
    handleEdit: function(row) {
      this.dialogVisible = true;
      Object.assign(this.dataForm, row);
    },
    // 删除
    handleDelete(row) {
      this.$confirm(this.getKey('action.isDelete'), this.getKey('action.tips'), {
        type: "warning"
      }).then(() => {
        let params = this.getDeleteIds([], row);
        this.$api.menu.batchDelete(params).then(res => {
          this.findTreeData();
          this.$message({ message: this.getKey('action.deleteSuccess'), type: "success" });
        });
      });
    },
    // 获取删除的包含子菜单的id列表
    getDeleteIds(ids, row) {
      ids.push({ id: row.id });
      if (row.children != null) {
        for (let i = 0, len = row.children.length; i < len; i++) {
          this.getDeleteIds(ids, row.children[i]);
        }
      }
      return ids;
    },
    // 菜单树选中
    handleTreeSelectChange(data, node) {
      this.dataForm.parentId = data.id;
      this.dataForm.parentName = data.name;
    },
    // 图标选中
    iconActiveHandle(iconName) {
      this.dataForm.icon = iconName;
    },
		getKey: function (arg) {
			return this.$t(arg)
		},
    // 表单提交
    submitForm() {
      this.$refs["dataForm"].validate(valid => {
        if (valid) {
          this.$confirm(this.getKey('action.isConfirm'), this.getKey('action.tips'), {}).then(() => {
            this.editLoading = true;
            let params = Object.assign({}, this.dataForm);
            this.$api.menu.save(params).then(res => {
              this.editLoading = false;
              if (res.code == 200) {
                this.$message({ message: this.getKey('action.operateSucess'), type: "success" });
                this.$refs["dataForm"].resetFields();
                this.dialogVisible = false;
              } else {
                this.$message({
                  message: this.getKey('action.operateFail') + res.msg,
                  type: "error"
                });
              }
              this.findTreeData();
            });
          });
        }
      });
    }
  },
  mounted() {
    this.findTreeData();
  },
   watch:{
    dialogVisible(to,from){
       if (this.$refs['dataForm'] !== undefined && this.dialogVisible==false) {     
            this.$refs["dataForm"].resetFields();
          }
    }
  }

};
</script>

<style scoped>
</style>