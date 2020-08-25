const path = require('path');
module.exports = {
  runtimeCompiler: true,
  devServer: {
    open: true,
    host: "",
    port: '',
    https: false,
    hotOnly: false,
    proxy: {
      '/community-cms': {
        // target: 'https://mongo.qicaidonghu.cn/server/rest', // 测试
        target: 'https://api.dev.shequyijia.cn/', // 生产
        changeOrigin: true,
        secure: false,
      },
      '/community-user': {
          // target: 'https://mongo.qicaidonghu.cn/server/rest', // 测试
          target: 'https://api.dev.shequyijia.cn/', // 生产
          changeOrigin: true,
          secure: false,
      },
      '/community-estate': {
          // target: 'https://mongo.qicaidonghu.cn/server/rest', // 测试
          target: 'https://api.dev.shequyijia.cn/', // 生产
          changeOrigin: true,
          secure: false,
      }
    }
  },
  css: {
    
    loaderOptions: {
      less: {
        modifyVars: {
          /* less 变量覆盖，用于自定义 ant design 主题 */

          /*
          'primary-color': '#F5222D',
          'link-color': '#F5222D',
          'border-radius-base': '4px',
          */
        },
        javascriptEnabled: true,
        test: / \.（woff | woff2 | eot | ttf）$ /, loader: ' url-loader?limit = 100000 ',
    }
      },
      
  },
  // chainWebpack: config => {
      // 生产环境取消 console.log
    // if (process.env.NODE_ENV === 'production') {
    //   config.optimization.minimizer[0].options.terserOptions.compress.drop_console = true
    // }
  // }

  transpileDependencies: ['webpack-dev-server/client','framework7','framework7-vue','dom7','template7','ssr-window'],
  chainWebpack: config => {
      config.entry.app = ['@babel/polyfill', './src/main.js'];
  }

}
