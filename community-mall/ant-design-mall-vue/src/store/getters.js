const getters = {
  sidebar: state => state.app.sidebar,
  device: state => state.app.device,
  token: state => state.user.token,
  avatar: state => state.user.avatar,
  name: state => state.user.name,
  roles: state => state.user.roles,
  addRouters: state => state.permission.addRouters,
  permissionList: state => state.user.permissionList,
  theme: state => state.app.theme,
  color: state => state.app.color,
  username: state => state.user.username,
  nickname: state => {state.user.realname = Vue.ls.get(USER_INFO).realname; return state.user.realname},
  welcome: state => state.user.welcome,
  userInfo: state => {state.user.info = Vue.ls.get(USER_INFO); return state.user.info},
}
export default getters
