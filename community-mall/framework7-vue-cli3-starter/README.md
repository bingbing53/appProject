# Framework7 Vue CLI 3 Template

## Project setup
```
yarn
```

### Using Vue UI

```
yarn ui
```

### Compiles and hot-reloads for development
```
yarn run serve
```

### Compiles and minifies for production
```
yarn run build
```

### Run your tests
```
yarn run test
```

### Lints and fixes files
```
yarn run lint
```

//设置淘宝镜像
npm install -g cnpm --registry=https://registry.npm.taobao.org


兼容性问题

1.去掉了vuex

2.vue.config.js
  
    transpileDependencies: ['webpack-dev-server/client','framework7','framework7-vue','dom7','template7','ssr-window'],
    chainWebpack: config => {
        config.entry.app = ['@babel/polyfill', './src/main.js'];
    }

3.main.js 加入

    import '@babel/polyfill';
    import Es6Promise from 'es6-promise'
    Es6Promise.polyfill()
    
4.main.js 引入
    import 'core-js/modules/es.object.assign';
    
    引入 core-js
        