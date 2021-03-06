import { getAllDicts  } from '@/http/moudules/sys/dict'
import { findAll  } from '@/http/moudules/Basic/Matertial/item'
const state = {
  dicts: {},
  item:[],
  init: false
}

const mutations = {
  SET_DICT: (state, data) => {
   
    if(state.init){
      return;
    }
   
    state.init=true
    for(let i=0,len=data.length; i<len; i++) {
      let item= data[i];
      if(state.dicts[item.dtype]!=undefined){
        state.dicts[item.dtype].push(item);
      }else{
        state.dicts[item.dtype]=[];
        state.dicts[item.dtype].push(item);
      }
    }	
  }, 
  SET_ITEM: (state, res) => {
    state.item=res;
  }


}

const actions = {
  // user login
  getAllDicts({ commit }) {

    if(this.state.dict.init){
      return new Promise((resolve, reject) => { resolve() })
    }else{
      return new Promise((resolve, reject) => {
        getAllDicts().then((res) => {
          commit('SET_DICT', res.data)
          resolve()
        }).catch(error => {
          reject(error)
        })
      })

    }
    
  },  
  getAllItem({ commit }) {
    if(this.state.dict.init){
      return new Promise((resolve, reject) => { resolve() })
    }
      return new Promise((resolve, reject) => {
        findAll().then((res) => {
          commit('SET_ITEM', res.data)
          resolve()
        }).catch(error => {
          reject(error)
        })
      })

    
    
  }
}

export default {

  state,
  mutations,
  actions
}
