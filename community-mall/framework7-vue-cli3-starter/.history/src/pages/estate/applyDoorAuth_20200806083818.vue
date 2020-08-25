<template>
  <f7-page>
    <div @refresh="onRefresh">
       <van-cell-group >
        <van-cell title="上传身份证" 
         
         :finished="feedBackList.finished"
          @click="go" 
         />
     </van-cell-group>
       <van-cell-group>
        <van-cell title="人脸信息"   @click="face"/>
      </van-cell-group>
       <van-cell-group>
        <van-cell title="居住信息"   @click="residence"/>
      </van-cell-group>
       <van-cell-group>
        <van-cell title="居住证明材料"  @click="certificate"/>
      </van-cell-group>
      <van-button plain hairline type="primary"  class="propertyAudit" color="#ff0000">提交物业审核</van-button>
    </div>
  </f7-page>
</template>

<script>
    import {applyDoorAuth} from "@/api/api_estate.js";
    import{photoIDCard} from "@/api/api_estate.js";
    export default {
      name:"applyDoorAuth",
        data(){
            return {
              msg:"111",
              feedBackList:{
                pageNo:1,
                loading:false,
                finished:false
              }
            }
        },
        created(){
          //this.getLenList();
        },
        methods:{
          onRefresh(){
           this.feedBackList.totalPage = 0;
           this.feedBackList.pageNo = 1;
           this.init(); //加载数据
          },
           async init() {
            let _this = this;
            let res = await photoIDCard(this.feedBackList.pageNo);
            this.feedBackList.records = [];
            this.handleData(res);
            this.feedBackList.totalPage = res.data.pages;
            this.feedBackList.isLoading = false; //关闭下拉刷新效果
            this.feedBackList.finished = false;
            if (res.data.pages <= res.data.current) {
              this.feedBackList.finished = true;
            } else {
              this.feedBackList.pageNo++;
            }
          },
           go() {
            this.$f7router.navigate(`/estate/photoIDCard`);
            let that=this;
            let pageNo=this.feedBackList.pageNo;
            photoIDCard({pageNo:this.feedBackList.pageNo})
              .then(res => {
              this.handleData(res);
              this.feedBackList.totalPage = res.pages;
              this.feedBackList.loading = false;
              if (res.data.pages <= res.data.current) {
                this.feedBackList.finished = true;
              } else {
                this.feedBackList.pageNo++;
              }
            }).catch(err=>{
               this.$commonUtils.jumpLogin(err);
                this.allowInfinite = true;
                if (this.feedBackList.isLoading) {
                  wx.toast("刷新成功");
                  this.feedBackList.isLoading = true;
                }
            })
          },
          handleData(res) {
            let that = this;
            let result = res.data;
            if (result.records.length > 0) {
              result.records.forEach(function(item, index) {
                let images = [];
                if (!!item.image) {
                  try {
                    let imageJson = JSON.parse(item.image);
                    imageJson.forEach(function(image) {
                      images.push(that.$commonUtils.formatPicture(image));
                    });
                  } catch (e) {}
                }
                item["images"] = images;
                that.feedBackList.records.push(item);
              });
            }
          },
          face(){
            this.$f7router.navigate(`/estate/faceInformation`);
          },
          residence(){
             this.$f7router.navigate(`/estate/residenceInformation`);
          },
          certificate(){
            this.$f7router.navigate(`/estate/proofOfResidence`);
          },
        }
    }
</script>
<style scoped>
.propertyAudit{
  width: 150px;
  margin-top: 150px;
  margin-left: 110px;
}
</style>