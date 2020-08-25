const autoprefixer = require('autoprefixer');
const pxtoviewport = require('postcss-px-to-viewport');
const designconvert = require('postcss-design-convert');
const path = require("path");
const resolve = dir => path.join(__dirname, dir);
const Timestamp = new Date().getTime();
module.exports = {
    configureWebpack: { // webpack 配置
      output: { // 输出重构  打包编译后的 文件名称  【模块名称.版本号.时间戳】
        filename: `[name].${process.env.VUE_APP_Version}.${Timestamp}.js`,
        chunkFilename: `[name].${process.env.VUE_APP_Version}.${Timestamp}.js`
      },
    },
    publicPath:'/work',
    outputDir:'dist/work',
  chainWebpack: config => {
    // 添加别名
    config.resolve.alias
      .set("@", resolve("src"))
      .set("images", resolve("src/assets/images"))
      .set("styles", resolve("src/assets/styles"))
      .set("common", resolve("src/assets/common"))
      .set("views", resolve("src/views"))
      .set("components", resolve("src/components"))
      .set("api", resolve("src/api"));
  },
  // assetsPublicPath:'/',
  // 关闭sourcemap
  productionSourceMap: false,
  devServer: {
    open: true,
    host: "",
    port: '',
    https: false,
    hotOnly: false,
    proxy: {
      '/api': {
        target: 'https://mongo.qicaidonghu.cn/server/rest', // 测试
        // target: 'https://www.qicaidonghu.cn/server/rest', // 生产
        changeOrigin: true,
        secure: false,
        pathRewrite: {
          '^/api': ''
        }
      }
    }
  },
  css: {
    loaderOptions: {
      postcss: {
        plugins: [
          autoprefixer(),
          pxtoviewport({
            viewportWidth: 750,
            viewportHeight: 1334,
            unitPrecision: 2,
            viewportUnit: "vw",
            selectorBlackList:['.ignore','.hairlines'],
            minPixelValue: 1,
            mediaQuery: false
          }),
          designconvert({
            multiple: 2,
            units: ["vw"],
            selector: /^\.van-/
          })
        ]
      }
    }
  }
};
