<template>
  <div class="page-container">


    <!--新增编辑界面-->
    <el-dialog :title="operation?'订单新增':'订单编辑'"
               width="80%"
               :visible.sync="dialogVisible"
               @opened="getDetials"
               :close-on-click-modal="false"
               :before-close="handleClose">


      <el-form :model="subDataForm"
               label-width="200px"
               :rules="dataFormRules"
               ref="dataForm"
               :size="size"
               label-position="right">
          <el-form-item label="ID"
                    prop="id"
                    v-if="true">
          <el-input v-model="subDataForm.id"
                  :disabled="true"
                  auto-complete="off">
          </el-input>
        </el-form-item>
        <el-row>
          <el-col :span="12">
            <el-form-item label="订单号"
                          prop="soNo">
              <el-input v-model="subDataForm.soNo"
                        :auto-complete="off">
              </el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
              <el-form-item label="订单主Id"
                          prop="srcSoBill">
              <el-input v-model="subDataForm.srcSoBill"
                        :auto-complete="off">

              </el-input>
            </el-form-item>
          </el-col>
        </el-row>

         <el-row>
          <el-col :span="12">
            <el-form-item label="供应商名称"
                          prop="customName">
              <search-select :itemlist="this.gysTypes"
                             style="width: 100%;"
                             placeholder="输入框"
                             :state="subDataForm.customName"
                             @itemChange="itemclick" :key="componentKey">
              </search-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
              <el-form-item label="供应商Id"
                          prop="customId">
              <el-input v-model="subDataForm.customId"
                        :auto-complete="off">
              </el-input>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="12">
            <el-form-item label="供应商编码"
                          prop="customCode">
              <el-input v-model="subDataForm.customCode"
                        :auto-complete="off">
              </el-input>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>

      <div slot="footer"
           class="dialog-footer">
        <el-button :size="size"
                   type="primary"
                   @click.native="submitForm"
                   :loading="editLoading">{{$t('action.submit')}}</el-button>
        <el-button :size="size"
                   @click.native="handleAddDetailEdit">增加明细 </el-button>
        <el-button :size="size"
                   @click.native="handleHiddenin">{{$t('action.cancel')}}</el-button>
      </div>
    <div>
        <div class="app-container">
          <el-table v-loading="listLoading"
                    :data="list"
                    border
                    fit
                    highlight-current-row
                    style="width: 100%" height="250" size="mini">
            //物料名称
            <el-table-column class-name="status-col"
                             :label="$t('field.itemName')"
                             min-width="80px"
                             prop="itemName"
                             align="center"
                             fixed="right"
                             header-align="center"
                             :formatter="itemFilter">
            </el-table-column>
            //完成数量
            <el-table-column class-name="status-col"
                             :label="'完成数量'"
                             min-width="80px"
                             prop="count"
                             align="center"
                             fixed="right"
                             header-align="center"
                             :formatter="itemFilter">
            </el-table-column>
            //规格
            <el-table-column :label="'规格'"
                             prop="itemSpec"
                             align="center"
                             width="120px"
                             fixed="right">
              <template slot-scope="{row}">
                <template v-if="row.edit">
                  <el-input v-model="row.itemSpec"
                            class="edit-input"
                            size="mini" />
                </template>
                <span style="cursor: pointer;"
                      v-else>{{ row.itemSpec }}</span>
              </template>
            </el-table-column>
            //计划数量
            <el-table-column width="120px"
                             :label="$t('field.planCount')"
                             align="center"
                             fixed="right"
                             header-align="center">
              <template slot-scope="{row}">
                <template v-if="row.edit">
                  <el-input v-model="row.count"
                            class="edit-input"
                            size="mini" />
                </template>
                <span style="cursor: pointer;"
                      v-else>{{ row.count }}</span>
              </template>
            </el-table-column>
            //单位
            <el-table-column width="120px"
                             :label="'单位'"
                             align="center"
                             fixed="right"
                             header-align="center">
              <template slot-scope="{row}">
                <template v-if="row.edit">
                  <el-input v-model="row.packUnit"
                            class="edit-input"
                            size="mini" />
                </template>
                <span style="cursor: pointer;"
                      v-else>{{ row.packUnit }}</span>
              </template>
            </el-table-column>
            //编辑按钮
            <el-table-column align="center"
                             :label="$t('action.edit')"
                             width="120px"
                             fixed="right">
              <template slot-scope="{row}">
                <el-button v-if="row.edit"
                           type="success"
                           :size="size"
                           @click="confirmEdit(row)"
                           icon="el-icon-circle-check-outline"> {{$t('action.comfirm')}}
                </el-button>
                <el-button  v-else
                           type="primary"
                           :size="size"
                           icon="el-icon-edit"
                           @click="row.edit=!row.edit"> {{$t('action.edit')}}
                </el-button>
              </template>
            </el-table-column>
            //删除按钮
            <el-table-column :label="$t('action.operation')"
                             width="120"
                             fixed="right"
                             header-align="center"
                             align="center" >
              <template slot-scope="scope">

                <kt-button icon="fa fa-trash"
                           :label="$t('action.delete')"
                           perms="sys:user:delete"
                           :size="size"
                           type="danger"
                           @click="handleDelete(scope.$index, scope.row)" />
              </template>
            </el-table-column>

          </el-table>
        </div>
    </div>
    </el-dialog>


     <item-select :itemDialogVisible="itemDialogVisible"
                 @handleSelect="handleSelect"
                 @itemHidden="itemHidden"
                 :fromCorpId="this.subDataForm.fromCorpId"
                 :key="componentKey">
    </item-select>



  </div>
</template>

<script>
import KtTableList from "@/views/Core/KtTableList"
import KtButton from "@/views/Core/KtButton"
import { format } from "@/utils/datetime"
import ItemSelect from "@/views/Basic/Material/ItemSelect"
import SearchSelect from "@/views/Core/SearchSelect"
export default {
  name: 'EditWareHouseIn',
  components: {
    KtTableList,
    KtButton,
    ItemSelect,
    SearchSelect
  },
  filters: {

  },
  props: {
    subDataForm: {
      type: Object
    },
    dialogVisible: {
      type: Boolean
    },
    operation: {
      type: Boolean
    }
  },
  data () {
    return {
      size: 'mini',
      listLoading: false,
      list: [],
      pageResult: {},
      editLoading: false,
      pageRequest: { pageNum: 1, pageSize: 1000 },
      itemDialogVisible: false,
      dicts: this.$store.state.dict.dicts,
      componentKey: 0,
      gysTypes: []
    }

  },
  computed: {
        dataFormRules() {
			  const dataFormRules= {
        soNo:[{ required: true, message: this.getKey("订单号不能为空"), trigger: 'blur' }],
        srcSoBill:[{ required: true, message: this.getKey("订单主Id不能为空"), trigger: 'blur' }],
        customName:[{ required: true, message: this.getKey("供应商名称不能为空"), trigger: 'blur' }],
        customId:[{ required: true, message: this.getKey("供应商Id不能为空"), trigger: 'blur' }],
        customCode:[{ required: true, message: this.getKey("供应商编码不能为空"), trigger: 'blur' }]
			};
			return dataFormRules;
			}
  },
  methods: {
    //编辑后确定
    confirmEdit (row) {
      this.$api.sales.updateDetials(row).then((res) => {
        if (res.code == 200) {
              this.getDetials();
            } else {
              this.$message({ message: this.$t('action.operateFail') + res.msg, type: 'error' })
              this.getDetials();
            }
        })
    },
     	getKey: function (arg) {
			return this.$t(arg)
		},
    //删除
    handleDelete: function (index, row) {
      this.$confirm('确认删除选中记录吗？', '提示', {
				type: 'warning'
			}).then(() => {
          this.$api.sales.deleteDetial({id: row.id, soId: row.soid}).then((res) => {
            if (res.code == 200) {
                  this.getDetials();
                } else {
                  this.$message({ message: this.$t('action.operateFail') + res.msg, type: 'error' })
                  this.getDetials();
                }
          })
      }).catch(() => {
			})


    },

    handleSelect: function (data) {
      this.$api.sales.saveDetials({
        soNo: this.subDataForm.soNo, id: this.subDataForm.id, items: data      }).then((res) => {
        this.itemHidden();
        this.getDetials();
      })
    },
    // 获取分页数据
    itemclick: function (data) {
      this.componentKey += 1;
      if (data.length!=0){
        this.subDataForm.customName = data.name
        this.subDataForm.customId = data.ncId
        this.subDataForm.customCode = data.code
        this.subDataForm.fromCorpId = data.id
      }else{
        this.subDataForm.customName = ""
        this.subDataForm.customId = 0
        this.subDataForm.customCode = 0
        this.subDataForm.fromCorpId = 0
      }

    },
    itemFilter: function (row, column, cellValue, index) {
        let propt = column.property;
        let val = row[column.property];
        let dict = this.$store.state.dict.item
        if (dict == undefined) {
          return row[column.property]
        }
        for (let i = 0; i < dict.length; i++) {
          if (dict[i].id == val) {
            return dict[i].name;
          }
        }
        return row[column.property]
    },
    // 获取分页数据
    getDetials: function () {
      if (this.subDataForm == undefined || this.subDataForm.id == undefined || this.subDataForm.id == 0) {
        return;
      }
      this.listLoading = true
      this.$api.sales.getDetials(this.subDataForm).then((res) => {
        debugger
        const items = res.data
        console.log(this.subDataForm);
        this.list = items.map(v => {
          this.$set(v, 'edit', false)
          return v
        })
        this.listLoading = false
      })
    },
      handleClose: function (done) {
      this.$emit('receiptHidden', {})
      done();
    },
      handleHiddenin: function (params) {
      this.$emit('receiptHidden', {})
    },

    //增加明细
    handleAddDetailEdit: function () {
      this.componentKey += 1;
      if (this.subDataForm.id == 0) {
        this.$message({ message: "请先新增并提交订单", type: 'error' })
      } else {
        if (this.subDataForm.status == 1) {
          this.itemDialogVisible = true
        }
        else {
          this.$message({ message: "订单非待执行状态无法添加明细", type: 'error' })
        }
      }
    },
    itemHidden: function () {
      this.itemDialogVisible = false;
    },
    findgysTypes: function () {
      this.$api.corewhgro.findPage().then((res) => {
        this.gysTypes = res.data.content
      })
    },

    submitForm: function () {
      if (this.subDataForm.status == 2 || this.subDataForm.status == 3) {
        this.$message({ message: "订单非待执行状态无法修改", type: 'error' })
      } else {
        this.$refs.dataForm.validate((valid) => {
          if (valid) {
            this.$confirm(this.$t('action.isConfirm'), this.$t('action.tips'), {}).then(() => {
              this.subDataForm.status = 1;
              this.editLoading = true
              let params = Object.assign({}, this.subDataForm)
              this.$api.sales.saveWhSoOut(params).then((res) => {
                this.editLoading = false
                this.subDataForm.id = res.data.id;
                this.subDataForm.soNo = res.data.soNo;
                if (res.code == 200) {
                  this.$message({ message: this.$t('action.operateSucess'), type: 'success' })
                } else {
                  this.$message({ message: this.$t('action.operateFail') + res.msg, type: 'error' })
                }
              })
            })
          }
        })
      }
    }



  },

  created () {
    this.findgysTypes()
  }
}
</script>

<style scoped>
</style>
