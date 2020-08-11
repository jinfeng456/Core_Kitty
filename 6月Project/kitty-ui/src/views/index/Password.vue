<template>
    <div class="app-container">
        <el-tabs v-model="activeName">
            <el-tab-pane :label="$t('user.userPassWord')" name="rulesPane" >
                <el-form ref="rulesForm" :rules="formRules" :model="rulesForm" label-width="200px">
                    <el-form-item :label="$t('user.userOriginalPassword')" prop="oldPassWord">
                        <el-input v-model="rulesForm.oldPassWord" style="width:300px" maxlength="50" type="password" auto-complete="new-password" clearable/>
                    </el-form-item>
                    <el-form-item :label="$t('user.newPassWord')" prop="newPassWord">
                        <el-input v-model="rulesForm.newPassWord" style="width:300px" maxlength="50"  type="password" auto-complete="new-password" clearable/>
                    </el-form-item>
                    <el-form-item :label="$t('user.confirmPassWord')" prop="confirmPassWord">
                        <el-input v-model="rulesForm.confirmPassWord" style="width:300px" maxlength="50" type="password" auto-complete="new-password" clearable/>
                    </el-form-item>
                   
                    <el-form-item>
                        <el-button type="primary" @click.native="onSubmit" :loading="editLoading">{{$t('action.submit')}}</el-button>
                        <el-button type="primary" @click="reset">{{$t('action.reset')}}</el-button>
                    </el-form-item>
                </el-form>
            </el-tab-pane>
		<el-tab-pane :label="$t('user.acceptancePassword')" name="rulesPane1">
                <el-form ref="rulesForm1" :rules="formRules1" :model="rulesForm1" label-width="200px">
                    <el-form-item :label="$t('user.checkOldPassWord')" prop="oldPassWord1">
                        <el-input v-model="rulesForm1.oldPassWord1" style="width:300px" maxlength="50" type="password" auto-complete="new-password" clearable/>
                    </el-form-item>
                    <el-form-item :label="$t('user.newPassWord')" prop="newPassWord1">
                        <el-input v-model="rulesForm1.newPassWord1" style="width:300px" maxlength="50"  type="password" auto-complete="new-password" clearable/>
                    </el-form-item>
                    <el-form-item :label="$t('user.confirmPassWord')" prop="confirmPassWord1">
                        <el-input v-model="rulesForm1.confirmPassWord1" style="width:300px" maxlength="50" type="password" auto-complete="new-password" clearable/>
                    </el-form-item>
                   
                    <el-form-item>
                        <el-button type="primary" @click="onSubmit1" :loading="editLoading">{{$t('action.submit')}}</el-button>
                        <el-button type="primary" @click="reset1">{{$t('action.reset')}}</el-button>
                    </el-form-item>
                </el-form>
            </el-tab-pane>
		
        </el-tabs>
        
    </div>
</template>

<script>
   

    export default{
        data() {
        let validatorIdNumber =  (rule, value, callback) =>{
	    var passwordreg = /(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).{6,16}/
        if(!value) {
            return callback(new Error ('请输入新密码'))
        }
        else if(!passwordreg.test(value)){
             callback(new Error('密码必须由数字、字母、特殊字符组合,请输入6-16位'))
        }
		else if(value===this.rulesForm.oldPassWord){
			return callback(new Error('新密不能与原始密码相同'))
		}
		else {
           callback()
        }
    }
    let validatorPhoneNumber =  (rule, value, callback)=> {
		
	
        if(!value){
            return callback(new Error('请输入确认密码'))
		}
		else if(value!==this.rulesForm.newPassWord){
			return callback(new Error('与新密码不一致！'))
		}
		else {
             callback()
        }
    }
    let validatorIdNumber1 =  (rule, value, callback) =>{
        var passwordreg = /(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).{6,16}/
 
        if(!value) {
            return callback(new Error ('请输入新密码'))
        }
        else if(!passwordreg.test(value)){
             callback(new Error('密码必须由数字、字母、特殊字符组合,请输入6-16位'))
        }
		else if(value===this.rulesForm1.oldPassWord1){
			return callback(new Error('新密不能与原始密码相同'))
		}
		else {
           callback()
        }
    }
    let validatorPhoneNumber1 =  (rule, value, callback)=> {
	
        if(!value){
            return callback(new Error('请输入确认密码'))
		}
		else if(value!==this.rulesForm1.newPassWord1){
			return callback(new Error('与新密码不一致！'))
		}
		else {
             callback()
        }
    }
            return {
                rulesForm: {
                    oldPassWord:'',
                    newPassWord:'',
                    confirmPassWord:'',
                   
                },
                formRules: {
                    oldPassWord:[{required: true,message: '请输入原始密码',trigger: 'blur'}],
                    newPassWord:[{required: true,trigger: 'blur',validator: validatorIdNumber}],
                    confirmPassWord: [{required: true,trigger: 'blur', validator: validatorPhoneNumber}]
                },
                 rulesForm1: {
                    oldPassWord1:'',
                    newPassWord1:'',
                    confirmPassWord1:'',
                   
                },
                 formRules1: {
                    oldPassWord1:[{required: true,message: '请输入原始密码',trigger: 'blur'}],
                    newPassWord1:[{required: true,trigger: 'blur',validator: validatorIdNumber1}],
                    confirmPassWord1: [{required: true,trigger: 'blur', validator: validatorPhoneNumber1}]
                },
                editLoading: false,
                activeName:'rulesPane'
            }
        },
        methods:{
            onSubmit () {
                this.$refs['rulesForm'].validate(valid => {
                  
                    if(valid){
                      
                        this.$confirm(this.$t('action.isConfirm'), this.$t('action.tips'), {}).then(() => {
                           this.editLoading = true
               
                             this.$api.user.updateUserPassWord({'passWord':this.rulesForm.newPassWord,
                     'oldWord':this.rulesForm.oldPassWord}).then((res) => {
                               
							this.editLoading = false
							if(res.code == 200) {
								this.$message({ message: this.$t('action.operateSucess'), type: 'success' })
								this.$refs['rulesForm'].resetFields()
								
							} else {
								this.$message({message:this.$t('action.operateFail') + res.msg, type: 'error'})
                            }
                            
							this.findPage(null)
						})
                         
						})
		

                       
                    }else{
                        this.$message({message:this.$t('action.operateFail1'), type: 'error'})
                        return false
                    }
                })
            },
             onSubmit1 () {
                this.$refs['rulesForm1'].validate(valid => {
                  
                    if(valid){
                      
                        this.$confirm(this.$t('action.isConfirm'), this.$t('action.tips'), {}).then(() => {
                           this.editLoading = true
                         
                             this.$api.user.updateCheckPassWord({'passWord1':this.rulesForm1.newPassWord1,
                     'oldWord1':this.rulesForm1.oldPassWord1}).then((res) => {
                            
							this.editLoading = false
							if(res.code == 200) {
								this.$message({ message: this.$t('action.operateSucess'), type: 'success' })
								 this.$refs['rulesForm1'].resetFields()
								
							} else {
								this.$message({message:this.$t('action.operateFail') + res.msg, type: 'error'})
                            }
                           
							this.findPage(null)
						})
                         
						})
		

                       
                    }else{
                        this.$message({message:this.$t('action.operateFail1'), type: 'error'})
                        return false
                    }
                })
            },
            reset (){
                this.$refs['rulesForm'].resetFields()
            },
            reset1 (){
                this.$refs['rulesForm1'].resetFields()
            }
        },
      
   
    }
</script>

<style scoped>

</style>