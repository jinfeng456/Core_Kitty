<template> 
  <div class="headbar" :style="{'background':themeColor}" 
    :class="$store.state.app.collapse?'position-collapse-left':'position-left'">
    <!-- 导航收缩 -->
    <span class="hamburg">
      <el-menu class="el-menu-demo" :background-color="themeColor" text-color="#fff" :active-text-color="themeColor" mode="horizontal">
        <el-menu-item index="1" @click="onCollapse"><hamburger :isActive="collapse"></hamburger></el-menu-item>
      </el-menu>
    </span>
    <!-- 导航菜单 -->
    <span class="navbar">
      <el-menu :default-active="activeIndex" class="el-menu-demo" 
          :background-color="themeColor" text-color="#fff" active-text-color="#ffd04b" mode="horizontal" @select="selectNavBar()">
        <el-menu-item index="1" @click="$router.push('/')"><i class="fa fa-home fa-lg"></i>  </el-menu-item>
        <el-menu-item index="2" @click="openWindow('d/r.htm')">垛机</el-menu-item>
        <el-menu-item index="3" @click="openWindow('d/s1.htm')">一期</el-menu-item>
        <el-menu-item index="4" @click="openWindow('d/s2.htm')">二期</el-menu-item>
        <el-menu-item index="5" @click="openWindow('d/s3.htm')">三期</el-menu-item>
        
      </el-menu>
    </span>
    <!-- 工具栏 -->
    <span class="toolbar">
      <el-menu class="el-menu-demo" :background-color="themeColor" :text-color="themeColor" :active-text-color="themeColor" mode="horizontal">
        <el-menu-item index="1">
          <!-- 主题切换 -->
          <theme-picker class="theme-picker" :default="themeColor" @onThemeChange="onThemeChange"></theme-picker>
        </el-menu-item>
        <el-menu-item index="2" v-popover:popover-lang>
          <!-- 语言切换 -->
          <li style="color:#fff;" class="fa fa-language fa-lg"></li>
          <el-popover ref="popover-lang" placement="bottom-start" trigger="click" v-model="langVisible">
            <div class="lang-item" @click="changeLanguage('zh_cn')">简体中文</div>
            <div class="lang-item" @click="changeLanguage('en_us')">English</div>
          </el-popover>
        </el-menu-item>
        <el-menu-item index="3" v-popover:popover-message>
          <!-- 我的私信 -->
          <el-badge :value="message.length" :max="99" class="badge" type="success">
            <li style="color:#fff;" class="fa fa-envelope-o fa-lg"></li>
          </el-badge>
          <el-popover ref="popover-message" placement="bottom-end" trigger="click">
            <message-panel  :data="message"></message-panel>
          </el-popover>        
        </el-menu-item>     
        <el-menu-item index="5" v-popover:popover-personal>
          <!-- 用户信息 -->
          <span class="user-info">{{user.name}}</span>
          <el-popover ref="popover-personal" placement="bottom-end" trigger="click" :visible-arrow="false">
            <personal-panel :user="user"></personal-panel>
          </el-popover>
        </el-menu-item>
      </el-menu>
    </span>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import Hamburger from "@/components/Hamburger"
import ThemePicker from "@/components/ThemePicker"
import LangSelector from "@/components/LangSelector"
import Action from "@/components/Toolbar/Action"
import MessagePanel from "./MessagePanel"
import PersonalPanel from "./PersonalPanel"
export default {
  components:{
        Hamburger,
        ThemePicker,
        LangSelector,
        Action,
        MessagePanel,
        PersonalPanel
  },
  data() {
    return {
      user: {
        name: "Louis",
        avatar: "",
        role: "超级管理员"
      },
      activeIndex: '1',
      langVisible: false,
      message:[],
      filters: {
				isWarning:true
      },
      pageRequest: { pageNum: 1, pageSize: 8 }

    }
  },
  methods: {
    openWindow(url) {
      window.open(url)
    },
    selectNavBar(key, keyPath) {
      console.log(key, keyPath)
    },
    // 折叠导航栏
    onCollapse: function() {
      this.$store.commit('onCollapse')
    },
    // 切换主题
    onThemeChange: function(themeColor) {
      this.$store.commit('setThemeColor', themeColor)
    },
    // 语言切换
    changeLanguage(lang) {
      lang === '' ? 'zh_cn' : lang
      this.$i18n.locale = lang
      this.langVisible = false
    }
  },
  mounted() {
    this.sysName = "东阳光库房管理系统"
    var user = sessionStorage.getItem("user")
    if (user) {
      this.user.name = user
      this.user.avatar = require("@/assets/user.png")
    }
 
	this.$api.login.indexData().then((res) => {

				this.message = res.data
      }).then(data!=null?data.callback:'') 
  
  //  this.filters.pageNum=this.pageRequest.pageNum
	//  this.filters.pageSize=this.pageRequest.pageSize
  //  this.$api.coreStock.QueryCoreDetailPage(this.filters).then((res) => {
  //       //this.pageResult = res.data
  //       this.message = res.data
  //     }).then(data!=null?data.callback:'')
  },

 
      
  computed:{
    ...mapState({
      themeColor: state=>state.app.themeColor,
      collapse: state=>state.app.collapse
    })
  }
}
</script>

<style scoped lang="scss">
.headbar {
  position: fixed;
  top: 0;
  right: 0;
  z-index: 1030;
  height: 60px;
  line-height: 60px;
  border-color: rgba(180, 190, 190, 0.8);
  border-left-width: 1px;
  border-left-style: solid;
}
.hamburg, .navbar {
  float: left;
}
.toolbar {
  float: right;
}
.lang-item {
  font-size: 16px;
  padding-left: 8px;
  padding-top: 8px;
  padding-bottom: 8px;
  cursor: pointer;
}
.lang-item:hover {
  font-size: 18px;
  background: #b0d6ce4d;
}
.user-info {
  font-size: 20px;
  color: #fff;
  cursor: pointer;
  img {
    width: 40px;
    height: 40px;
    border-radius: 10px;
    margin: 10px 0px 10px 10px;
    float: right;
  }
}
.badge {
  line-height: 18px;
}
.position-left {
  left: 200px;
}
.position-collapse-left {
  left: 65px;
}
</style>