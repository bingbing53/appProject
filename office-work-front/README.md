# 社区办公

## 介绍

- UI框架：vantUI（按需引入）；
- css:项目中的样式可以写css也可以写sass；
- 路由：目前采用的是一级路由静态路由，（新增路由的方式:添加.vue 文件—在router.js文件中引入—添加到路由数组中）；
- 路由跳转：目前采用 this.$router.push的方法 写入对应的path，穿参也可在这里传；

## 前端页面

- article - 文章详情
- download - 下载页面
- invest - 调查模板
-  publicopinion - 民情民意
- socialgroup - 社工小组
- work - 工作记录

## 请求封装

采用的flyio，用法和axios一样，

- 文件目录：@src/assets/common/Axios.js

- 组件与接口封装: 每个组件文件都有相关对应的js请求文件，组件文件所在位置如下图1，接口请求文件所在位置如下图2![image-20200619142749187](C:\Users\王永生\AppData\Roaming\Typora\typora-user-images\image-20200619142749187.png)

  ```
   
  ```

   ![image-20200619150740552](C:\Users\王永生\AppData\Roaming\Typora\typora-user-images\image-20200619150740552.png)   

- **注意**

  1. 代码中有相关注释，当项目在本地启动的时候，把‘电脑环境’代码打开，当项目提交时候，把’电脑环境‘注释掉，把'APP环境'代码打开

  2. ’电脑环境‘中的token是写死的，如果token失效可以找后台人员要一个token放进去，’APP‘环境中的token可以自动获取，不用管它；

  3. 现在组件中都是采用 async  await 的方式，返回一个promise

  4. 请求地址：（测试）：https://mongo.qicaidonghu.cn/server/rest（生产）https://www.qicaidonghu.cn/server/rest【**提交代码的时候，如果是提交测试，地址要统一改为测试地址，如果提交生产，地址要统一改为生产地址，包括请求地址和图片前缀地址，相关更改可在文件vue.config.js和common.js文件中更改**】

## 公共js—common.js

- showPicture方法：服务器压缩图片的方法，并给图片加前缀，使用的时候传入图片的地址即可，参数size：1开启压缩，size不传就是不压缩；**showPicture方法在项目打包提交代码的时候如果是测试要改为测试的地址，如果是生产要改为生产的地址**  ；*注意：这个方法在很多系统中都有用到，凡是前端从后台请求完成数据渲染时候，如果有图片基本上都会在图片上调用这个方法。*

- token 方法： 存放token；

- reduceImage方法：上传图片进行图片压缩，封装成了回调函数，支持多个图片，返回base64格式；使用如下图：<img src="C:\Users\王永生\AppData\Roaming\Typora\typora-user-images\image-20200619152303035.png" alt="image-20200619152303035" style="zoom: 50%;" />

  

## 下拉刷新上拉加载

现在所需要使用到下拉刷新和上拉加载的每个组件中，都要有三个相关函数；这个参考的是vant官方文档的list组件的方式

- load函数，页面加载的时候调用，

- refresh函数，页面下拉的时候调用，

- init 函数，在下拉刷新的函数refresh中调用，

  ## 

## 注意

1. 项目提交的时候，先检查axios.js和common.js 文件中是否把地址（生产、测试）改对应了   , 然后npm build 或者 yarn build  最后 git 提交。
2. 