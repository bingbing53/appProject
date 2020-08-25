<template>
  <f7-page style="background:#fff!important;">
    <div>
      <van-row>
        <van-col :span="24">
          <div class="pd-10 broder_b">
            <span class="c-666 mr-10">退款金额：</span>
            <span class="c-red">{{returnData.price}} 元</span>
          </div>
        </van-col>
        <van-col :span="24">
          <div class="pd-10 broder_b">
            <span class="c-666 mr-10">退回账户:</span>
            <span>{{returnData.priceFrom}}</span>
          </div>
        </van-col>
        <van-col :span="24">
          <div class="pd-10 broder_b">
            <span class="c-666 mr-10">到账时间:</span>
            <span>{{returnData.time}}</span>
          </div>
        </van-col>
      </van-row>
      <div class="bgcg pb-10"></div>
      <div class="pd-10">
        <p class="pt-10 pb-10 broder_b">退款流程</p>
        <div>
          <van-steps direction="vertical" :active="0">
            <van-step>
              <h3>【城市】物流状态1</h3>
              <p>2016-07-12 12:40</p>
            </van-step>
            <van-step>
              <h3>【城市】物流状态2</h3>
              <p>2016-07-11 10:00</p>
            </van-step>
            <van-step>
              <h3>快件已发货</h3>
              <p>2016-07-10 09:30</p>
            </van-step>
          </van-steps>
        </div>
      </div>
    </div>
  </f7-page>
</template>

<script>
export default {
  data() {
    return {
      returnData: {
        price: "50",
        priceFrom: "招商银行信用卡0000",
        time: "已到账"
      }
    };
  }
};
</script>

<style>
</style>
