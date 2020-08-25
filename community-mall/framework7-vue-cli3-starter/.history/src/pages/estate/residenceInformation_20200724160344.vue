<template>
  <f7-page>
    <div>
      <div class="tit">请将准确填写以下居住信息</div>
    </div>
    <van-cell-group class="myGroup">
        <van-field
                required
                clearable
                label="居住户型"
                placeholder="请输入居住户型"
        />
        <van-field  required label="住房面积" clearable placeholder="请输入住房面积（平方米）" />
    </van-cell-group>
    <div>
      <van-row>
        <van-col class="address">居住地址</van-col>
        <van-col class="change">二级认证更改 > </van-col>
      </van-row>
    </div>
    <div>
        <van-button  type="info"   class="tit2">保存</van-button>
    </div>
  </f7-page>
</template>

<script>
import {residenceInformation} from "@/api/api_estate.js";
    export default {
        name:"residenceInformation",
        data(){
            return {

            }
        },
        created(){

        },
        methods:{
          uploadIDCard(){     
              this.$f7router.navigate(`/estate/applyDoorAuth/`);               
          }
        }
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
.address{
    margin-left: 14px;
    font-size: 14.5px;
    margin-top: 7px;
}
.change{
    margin-left: 150px;
}
</style>


