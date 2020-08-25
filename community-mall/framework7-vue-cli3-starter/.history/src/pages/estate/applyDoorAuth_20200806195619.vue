<template>
  <f7-page>
    <div>
       <van-cell-group>
         <div>
            <van-cell title="上传身份证" 
              @click="go(item)" 
            />
         </div>
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
    import { ImagePreview } from "vant";
    import{photoIDCard} from "@/api/api_estate.js";
    //Vue.use(ImagePreview);
    export default {
      name:"applyDoorAuth",
        data(){
            return {
              msg:"111",
            }
        },
        created(){
          //this.getidcards();
        },
        methods:{    
          async init(){
            this.handleData(res);
          } ,   
           go(images,position) {
            this.$f7router.navigate(`/estate/photoIDCard`);
            ImagePreview({
              images,
              startPosition: position,          
            })
          },
          async init(){
            let _this=this;
            photo({})
             .then(res=>{
               this.handleData(res);
             })
          },
          handleData(res){
            let that = this;
            let result = res.data;
            if (result.records.length > 0) {
              result.records.forEach(function(item) {
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