<template>
  <f7-page>
    <div  >
      <div class="tit">请将身份证置于框内拍摄</div>
      <div>
        <div class="photo" @click="uploadIDCards(0)">
           <div  v-for="(item,index) in imgList" :key="index" > 
            <img :src="item"   width="210" height="145"  class="images1"/>
           </div> 
           <div >        
            <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
            <div class="tip">点击拍照/上传人像面</div>
           </div>
        </div>
      </div>
      <div>   
        <div class="photo"  @click="uploadIDCardss(0)" >
           <div  v-for="(item,index) in imgLists" :key="index"> 
            <img :src="item"   width="210" height="145" class="images2"/>
           </div> 
           <div>
            <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
            <div class="tip">点击拍照/上传国徽面</div>
           </div>
        </div>
      </div>
    </div>
       <van-button type="file" class="tit2"  @click="preservation" >保存</van-button>
  </f7-page>
</template>

<script>
// import {photoIDCard} from "@/api/api_estate.js";
import {
  uploadBase64Image
} from "@/api/api_common.js";
    export default {
        name:"photoIDCard",
        data(){
          return {
            imgList:[],
            imgLists:[],
            imageArr:[]
          }
        },
        created(){

        },
        methods:{    
           async preservation(){
            let that = this;
            var resultArr = [];
            if (this.imgList.length > 0) {
                wx.loading("图片上传中");
                console.log(imgList);
                for (var i = 0; i < this.imgList.length; i++) {
                  var result = await uploadBase64Image({
                    upfile: this.imgList[i]
                  }).catch(err => {
                    wx.toast("上传失败");
                    wx.closeLoading();
                    return;
                  });
                  if (result.status == 200) {
                    resultArr.push(result.data["url"]);
                  }
                }
                wx.closeLoading();
                this.form.image = JSON.stringify(resultArr);
              }
              idcard(this.form)
              .then(res => {
                  this.imgList = [];
                  wx.toast("提交成功");
                  this.$f7router.navigate(`/estate/applyDoorAuth`);
                })
                .catch(err=>{
                  wx.toast("提交失败，请稍后重试")
                })
           },
            async preservation(){
            let that = this;
            var resultArr = [];
            if (this.imgLists.length > 0) {
                wx.loading("图片上传中");
                for (var i = 0; i < this.imgLists.length; i++) {
                  var result = await uploadBase64Image({
                    upfile: this.imgLists[i]
                  }).catch(err => {
                    wx.toast("上传失败");
                    wx.closeLoading();
                    return;
                  });
                  if (result.status == 200) {
                    resultArr.push(result.data["url"]);
                  }
                }
                wx.closeLoading();
                this.form.image = JSON.stringify(resultArr);
              }
              idcard(this.form)
              .then(res => {
                  this.imgLists = [];
                  wx.toast("提交成功");
                  this.$f7router.navigate(`/estate/applyDoorAuth`);
                })
                .catch(err=>{
                  wx.toast("提交失败，请稍后重试")
                })
           },
              uploadIDCards(value){        
              // this.$f7router.navigate(`/estate/applyDoorAuth`);  
              let that = this; 
              if(that.imgList.length==0)
                wx.uploadIDCard({
                    //source: "camera",
                    success: function(res) {
                    that.imgList.push(res);   
                    console.log(res)          
                  }
                });  
              },
             uploadIDCardss(){         
                let that = this; 
                if(that.imgLists.length==0){
                  wx.uploadIDCard({
                    source: "camera",
                    success: function(res) {
                      that.imgLists.push(res);             
                    }
                  });
                }           
              },
              //  preservation(value){
              //   var param=new FormData();
              //   param.append(this.imgList);
              //   param.append(this.imgLists);
              //   this.$axios({
              //     methods:"get",
              //     url:"/estate/applyDoorAuth",
              //     data:param
              //   })
              //   .then(response=>{
              //     this.$message({
              //       message:"上传成功",
              //       type:"success"
              //     })
              //   })
              //   .catch(error=>{
              //     this.$message.error("上传失败，请稍后重试")
              //   })
              // },
          },
         
      }
      
</script>
<style scoped>
.tit{
  text-align: center;
  margin: 1rem;
}
.tit2{
  text-align: center;
  width: 12rem;
  margin: 1.2rem auto;
  font-size: .7rem;
  margin-left: 23.5%;
  font-size: 16px;
  background: #03a9f4;
  border: none;
}
.photo{
  width: 13rem;
  height: 9rem;
  border-radius: .3rem;
  background: #dddddd;
  margin: .6rem auto;
  position: relative;
}
.camerabox{
  width: 100%;
  -webkit-border-radius:5px;
  -moz-border-radius:5px;
  border-radius: 5px;
  height: 100%;
  display: none;
}
.fileInpBtn{
  position: absolute;
  left: 2;
  top: 0;
  cursor: pointer;
  width: 100%;
  height: 100%;
  /* filter:alpha(opacity:0); */
  opacity: 0;
  border-color:orange;
  z-index:10;
  border: solid red 1px;

}
.cameraPicture{
  position: absolute;
  color: #03a9f4;
  font-size: 3rem;
  top: 15%;
  left:40%;
}
.tip{
  position: absolute;
  bottom: 15%;
  text-align: center;
  width: 100%;
  /* color: #03a9f4; */
}
.imgs{
  float: right;
}
.images1{
  position: relative;
  z-index:10; 
}
.images2{
  position: relative;
  z-index:10; 
}
</style>


