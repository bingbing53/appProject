import Vue from "vue";
import VueRouter from "vue-router";
import Home from "../views/home/Home.vue";
import HomeHeader from "../views/home/homeHeader.vue";
import HomeFooter from "../views/home/homeFooter.vue";
import Register from "../views/register.vue"
import RegisterEstates from "../views/registerEstates.vue"
import RegisterSociety from "../views/registerSociety.vue"
import RegisterBusiness from "../views/registerBusiness.vue"
import Login from "../views/login/login.vue"
import DownLoad from "../views/downLoad.vue"
import SelectDepart from "../views/login/selectDepart.vue"

Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    name: "home",
    component: Home
  },
  {
    path: "/homeHeader/",
    name: "homeHeader",
    component: HomeHeader
  },
  {
    path: "/homeFooter/",
    name: "homeFooter",
    component: HomeFooter
  },
  {
    path: "/registerBusiness/",
    name: "registerBusiness",
    component: RegisterBusiness
  },
  {
    path: "/RegisterSociety/",
    name: "RegisterSociety",
    component: RegisterSociety
  },
  {
    path: "/registerEstates/",
    name: "registerEstates",
    component: RegisterEstates
  },
  {
    path: "/register/",
    name: "register",
    component: Register
  },
  {
    path: "/about",
    name: "about",
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () =>
      import(/* webpackChunkName: "about" */ "../views/About.vue")
  },
  {
    path: "/login/",
    name: "login",
    component: Login
  },
  {
    path: "/downLoad",
    name: "downLoad",
    component: DownLoad
  },
  {
    path: "/selectDepart",
    name: "selectDepart",
    component: SelectDepart
  },
];

const router = new VueRouter({
  mode: "hash",
  base: process.env.BASE_URL,
  routes
});

export default router;
