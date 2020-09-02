import Vue from "vue";
import Vuex from "vuex";
import axios from "axios";
import { getProposalType } from "@/api/proposal";
Vue.use(Vuex);

const getters = {};

export default new Vuex.Store({
  state: {
    classificationId: null, //分类id
  },
  getters,
  mutations: {
    //  同步修改分类id
    setClassificationId(state, data) {
      state.classificationId = data;
    },
  },
  actions: {
    //   获取分类详情
    getClassification(id) {
      return new Promise((resolve, reject) => {
        getProposalType(id)
          .then((res) => {
            console.log(res, "vuex111111");
            // commit('setClassificationId',id)
            resolve(res);
          })
          .catch((error) => {
            reject(error);
          });
      });
    },
    //初始化
    init({ commit }) {},
  },
});
