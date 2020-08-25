<template>
  <div>
    <div class="pt-10 text-c f-16 pb-10 bgcw2">
        {{title}} 历史记录详情
    </div>

    <div v-if="addressArr.length > 0 || houseArr.length > 0" class="bgcw2">
      <div>
      <h5 class="left"><p class="Wline Bline pb-10 pt-10 sort_view pl-10"><span class="blueLeftline f-b mr-5">I</span>  <span>调查房屋信息</span></p></h5>
        <div style="clear: both"></div>
      </div>
      <div class="Bline"></div>
    </div>

    <div v-if="addressArr.length > 0" class="pd-10 bgcw2">
      房屋地址：
      <span v-for="address in addressArr">
        {{address.value}}<span v-if="address.name === 'commNo-'" style="color:#999;font-size:11px;">社区</span><span v-if="address.name === 'villageNo-'" style="color:#999;font-size:11px;">小区</span><span v-if="address.name === 'buildingNo-'" style="color:#999;font-size:11px;">楼</span><span v-if="address.name === 'unitNo-'" style="color:#999;font-size:11px;">单元</span><span v-if="address.name === 'houseNo-'" style="color:#999;font-size:11px;">房间</span>
      </span>
    </div>
    <div v-if="houseArr.length > 0" class="pd-10 bgcw2">
      <div v-for="house in houseArr">
        {{house.label}}：{{house.value}}
      </div>
    </div>

    <div v-for="(data,index) in resultData" :key="index" class="bgcw2">
      <div class="bgcy pt-10"></div>
      <div>
       <h5 class="pt-10 pb-10"><p class="Wline  pb-10 pt-10 sort_view pl-10"><span class="blueLeftline f-b mr-5">I</span> <span>调查人详情（成员{{index+1}}）</span></p></h5>
      </div>
      <div v-if="headArr.length>0" class="text-c">
          <img :src="headArr[index].value" mode="widthFix" style="width:40%;">
      </div>
      <van-cell-group>
        <div v-for="(item,pos) in data" :key="pos">
            <van-cell :title="item.label" :value="item.value" />
        </div>
      </van-cell-group>
      <div v-if="sign[index] != undefined" class="text-r pt-10 pr-10">
          <img :src="sign[index].image" mode="widthFix" style="width:40%;">
      </div>
    </div>

  </div>
</template>
<script>

import getInvestHistorylist from "@/api/invest/investDetail";
export default {
  data () {
    return {
      title:'',
      resultData:[[]],
      addressArr:[],
      houseArr:[],
      headArr:[],
      sign:[],
      uuid:""
    }
  },
  methods:{
     async getInvestHistoryData(){
      var _this = this;

      this.resultData = [[]];
      this.addressArr = [];
      this.houseArr = [];
      this.sign = [];
      this.headArr = [];
        let d = await  getInvestHistorylist.getInvestHistoryData(this.uuid);
       d = JSON.parse(d);
        this.title = d.invest.title;
        var fields = JSON.parse(d.invest.content);
        //所有的字段信息
        fields = fields.fields;
        //所有的调查记录
        var data = d.data;
        //所有的签名
        var sign = d.sign;

        fields.forEach(function(item,index){
          data.forEach(function(item2,index2){
              //产权房屋
              if(item.field_type === 'address-family' || item.field_type === 'address-property'){
                  var arr = item.field_name;
                  arr.forEach(function(address,pos){
                     if(address === item2.name){
                         _this.addressArr.push(item2);
                     }
                  });
              } else if(item.field_type === 'address-personal'){
                var arr = item.field_name;
                arr.forEach(function(address,pos){
                  if(address === item2.name) {
                    var name = address.split('-')[0];
                    if (name == 'commNo'){
                      item2.label = '居住社区';
                    }else if(name == 'villageNo'){
                      item2.label = '居住小区';
                    }else if(name == 'buildingNo'){
                      item2.label = '居住楼宇';
                    }else if(name == 'unitNo'){
                      item2.label = '单元号';
                    }else if(name === 'houseNo'){
                      item2.label = '房间号';
                    }else if(name === 'otherAddress'){
                      item2.label = '居住地址';
                    }
                    if (_this.resultData[item2.afew] === undefined) {
                      _this.resultData[item2.afew] = [];
                    }
                    _this.resultData[item2.afew].push(item2);
                  }
                });
              } else {
                if (item.field_name === item2.name) {
                  item2.label = item.label;

                  item.name = item.field_name.split('-')[0];
                  if (item.name === 'droitType' || item.name === 'houseUse' || item.name === 'isRent' || item.name === 'liveType') {
                    _this.houseArr.push(item2);
                  } else if(item.name === 'headImage'){
                     item2.value = _this.common.showPicture(item2.value,"",false);
                    _this.headArr[item2.afew] = item2;
                  }else {
                    if (_this.resultData[item2.afew] === undefined) {
                      _this.resultData[item2.afew] = [];
                    }
                    _this.resultData[item2.afew].push(item2);
                  }
                }
              }
          });
        });

        if(sign != undefined) {
            sign.forEach(function (item,index) {
                item.image = _this.common.showPicture(item.image);
                _this.sign.push(item);
            });
        }

     
    }
  },
  mounted(){
     this.uuid = this.$route.params.uuid;
     this.getInvestHistoryData();
  }
}

</script>
<style>
  .van-cell{
    line-height: 16px !important;
  }
</style>
