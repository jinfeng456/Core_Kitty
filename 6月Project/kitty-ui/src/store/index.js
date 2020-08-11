import Vue from 'vue'
import vuex from 'vuex'

Vue.use(vuex);

import app from './modules/app'
import tab from './modules/tab'
import iframe from './modules/iframe'
import user from './modules/user'
import menu from './modules/menu'
import dict from './modules/dict'

const store = new vuex.Store({
    modules: {
        app: app,
        tab: tab,
        iframe: iframe,
        user: user,
        menu: menu,
        dict:dict
    },
    mutations: {
        saveToken(state, data) {
            state.token = data;
            window.localStorage.setItem("Token", data);
        },
        saveTokenExpire(state, data) {
            state.tokenExpire = data;
            window.localStorage.setItem("TokenExpire", data);
        },
        saveTagsData(state, data) {
            state.tagsStoreList = data;
            sessionStorage.setItem("Tags",data)
        },
        SET_LANGUAGE: (state, language) => {
            state.language = language
            Cookies.set('language', language)
        },
  
    }
})

export default store