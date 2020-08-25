const path = require('path')

function resolve(dir) {
  return path.join(__dirname, dir)
}

// vue.config.js
module.exports = {
  publicPath:'/',
  outputDir:'dist',
  /*
    Vue-cli3:
    Crashed when using Webpack `import()` #2463
    https://github.com/vuejs/vue-cli/issues/2463
   */
  // 如果你不需要生产环境的 source map，可以将其设置为 false 以加速生产环境构建。
  productionSourceMap: false,
  /*
  pages: {
    index: {
      entry: 'src/main.js',
      chunks: ['chunk-vendors', 'chunk-common', 'index']
    }
  },
  */
  configureWebpack: config => {
    // 生产环境取消 console.log
    if (process.env.NODE_ENV === 'production') {
      config.optimization.minimizer[0].options.terserOptions.compress.drop_console = true
    }
  },

  chainWebpack: (config) => {
    config.resolve.alias
      .set('@$', resolve('src'))
      .set('@api', resolve('src/api'))
      .set('@assets', resolve('src/assets'))
      .set('@comp', resolve('src/components'))
      .set('@views', resolve('src/views'))
      .set('@layout', resolve('src/layout'))
      .set('@static', resolve('src/static'))
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
      }
    }
  },

  devServer: {
    open:true,
    port: 4001,
    proxy: {
     /* '/api': {
        target: 'https://mock.ihx.me/mock/5baf3052f7da7e07e04a5116/antd-pro', //mock API接口系统
        ws: false,
        changeOrigin: true,
        pathRewrite: {
          '/jeecg-boot': ''  //默认所有请求都加了jeecg-boot前缀，需要去掉
        }
      },*/
      '/community-user': {
        // target: 'http://localhost:8080', //请求本地 需要jeecg-boot后台项目
        target: 'https://api.dev.shequyijia.cn', //请求本地 需要jeecg-boot后台项目
        ws: false,
        changeOrigin: true,
      },
      '/community-biz': {
        target: 'https://api.dev.shequyijia.cn', //请求本地 需要jeecg-boot后台项目
        // target: 'http://localhost:8084', //请求本地 需要jeecg-boot后台项目
        ws: false,
        changeOrigin: true,
      },
    }
  },

  lintOnSave: undefined
}