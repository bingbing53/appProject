<template >
  <div style="background-color:#f5f5f5;">
    <van-row class="baseMargin">
      <van-image height="20" fit="contain" :src="require('../../assets/img/house.png')"></van-image>
      <span style="align-self: center;">房屋信息</span>
    </van-row>
    <div class="card" v-if="!isEdit">
      <van-cell title="房屋地址" :value="houseData.remark" />
      <van-cell title="房屋面积" :value="houseData.houseArea==null?'0㎡':houseData.houseArea+'㎡'" />
      <van-cell title="产权人" :value="houseData.houseOwnername" />
      <van-cell title="联系方式" :value="houseData.contactPhone" />
      <van-cell title="是否出租" :value="houseData.isRent=='1'||houseData.isRent==1?'是':'否'" />
      <van-row class="buttonRow">
        <!-- <van-button type="info" size="small" style="width:80px;margin-right:10px">保存</van-button> -->
        <van-button type="default" size="small" style="width:80px;" v-on:click="editHouse">编辑</van-button>
      </van-row>
    </div>
    <div class="card" v-else>
      <!-- <van-field label="房屋地址" v-model="houseData.remark" placeholder="请输入地址" input-align="right"/> -->
      <van-cell title="房屋地址" :value="houseData.remark" clickable v-on:click="clickToSelectAddress"/>
      <van-field label="房屋面积" v-model="houseData.houseArea" placeholder="请输入㎡数" input-align="right"/>
      <van-field label="产权人" v-model="houseData.houseOwnername" placeholder="请输入产权人姓名" input-align="right"/>
      <van-field label="联系方式" v-model="houseData.contactPhone" placeholder="请输入联系方式" input-align="right"/>
      <van-field label="是否出租" name="switch" input-align="right">
        <template #input>
          <van-switch v-model="switchCheckedRent" size="20" />
        </template>
      </van-field>
      <van-row class="buttonRow">
        <van-button
          type="info"
          size="small"
          style="width:80px;margin-right:10px"
          v-on:click="saveEdit"
        >保存</van-button>
        <van-button type="default" size="small" style="width:80px;" v-on:click="cancelEdit">取消</van-button>
      </van-row>
    </div>
    <van-row class="baseMargin">
      <van-image height="20" fit="contain" :src="require('../../assets/img/people.png')"></van-image>
      <span style="align-self: center;">同住人信息</span>
    </van-row>

    <!-- <div class="card">
      <van-row>
        <van-col :span="10" class="cardTitle" style="margin:10px;">同住人信息查询</van-col>
        <van-col :span="11" class="cardTitle" style="margin:10px;text-align:right;">
          <van-image
            height="15"
            width="25"
            fit="contain"
            :src="require('../../assets/img/people.png')"
          />
          <van-image
            height="15"
            width="25"
            fit="contain"
            :src="require('../../assets/img/edit.png')"
          />
          <van-image
            height="15"
            width="25"
            fit="contain"
            :src="require('../../assets/img/delete.png')"
          />
        </van-col>
      </van-row>
      <van-grid :column-num="3">
        <van-grid-item v-for="value in 6" :key="value" icon="photo-o" text="文字" />
      </van-grid>
    </div>-->
    <div class="card">
      <van-row>
        <van-col :span="10" class="cardTitle" style="margin:10px;">同住人信息查询</van-col>
      </van-row>
      <div class="shadow" v-for="value in personData" :key="value['id']">
        <van-row style="width:100%;display: flex;">
          <van-col span="4">
            <van-image
              height="50"
              width="50"
              fit="contain"
              :src="value['sex']=='1'?require('../../assets/img/avatar_female_small.png'):require('../../assets/img/avatar_male_small.png')"
            />
          </van-col>
          <van-col span="10" class="cardTitle" style="align-self: center;">{{value['personName']}}</van-col>
          <van-col span="10" class="cardTitle" style="text-align:right;align-self: center;">
            <van-image
              height="15"
              width="25"
              fit="contain"
              :src="require('../../assets/img/edit.png')"
               v-on:click="editPerson(value)"
            />
            <van-image 
              height="15"
              width="25"
              fit="contain"
              :src="require('../../assets/img/delete.png')"
              v-on:click="deletePerson(value)"
            />
          </van-col>
        </van-row>
      </div>
    </div>
  </div>
</template>
<script>
import getDataList from "@/api/census/census";
import { Dialog } from 'vant';
export default {
  data() {
    return {
      isEdit: false,
      houseData: {},
      oldHouseData: {},
      personData: [],
      switchCheckedRent: false
    };
  },
  mounted() {
    this.getHouseData(this.$route.query.id);
    this.getPersonData(this.$route.query.id);
  },
  activated(){
     if(window.localStorage.getItem("address_str")!=null&&window.localStorage.getItem("address_str")!=''){
        this.isEdit = true;
        this.houseData.remark=window.localStorage.getItem("address_str");
        window.localStorage.setItem("address_str",'');
      }
  },
  beforeRouteLeave(to, from, next) {
    console.log(to.name);
    console.log(from.name);
    console.log(next.name);
    if (to.name === "censusAddress"||to.name === 'censusDetail') {
      from.meta.keepAlive = true; //当我们进入到C时开启B的缓存
      next();
    } else {
      // from.meta.keepAlive = false;
      // to.meta.keepAlive = false; 
      this.$destroy();
      next(); //当我们前进的不是C时我们让B页面刷新
    }
  },
  methods: {
    async getHouseData(id) {
      let data = await getDataList.getHouseDetail(id);
      console.log(data);
      this.houseData = JSON.parse(data);
      console.log(this.houseData);
      if(this.houseData.isRent == '1' ||this.houseData.isRent ==1){
        this.switchCheckedRent = true;
      }
     
    },
    async getPersonData(id) {
      let data = await getDataList.getPersonList(id);
      console.log(data);
      this.personData = JSON.parse(data);
      console.log(this.personData);
    },
    editHouse() {
      this.isEdit = true;
      this.oldHouseData = this.houseData;
    },
    cancelEdit() {
      this.isEdit = false;
      this.houseData = this.oldHouseData;
    },
    saveEdit() {
      this.isEdit = false;
      if (this.switchCheckedRent) {
        this.houseData.isRent = 1;
      } else {
        this.houseData.isRent = 0;
      }
      this.postUpdataHouseData();
    },
    async postUpdataHouseData() {
      let data = await getDataList.postHouseDataByHouseId({
        houseId: this.$route.query.id,
        houseArea: this.houseData.houseArea,
        houseOwnername: this.houseData.houseOwnername,
        contactPhone: this.houseData.contactPhone,
        isRent: this.houseData.isRent
      });
      console.log("updata:", data);
    },
    async deletePerson(value) {
      Dialog.confirm({
        title: `确认`,
        message: `确认删除${value['personName']}么`
      })
        .then(() => {
          // on confirm
          console.log('确认删除');
          this.deletePersonData(value['id']);
        })
        .catch(() => {
          // on cancel
          console.log('取消删除');
        });
    },
    async deletePersonData(id){
          let data = await getDataList.deletePersonDataByPersonId(id);
          console.log(data);
    },
    editPerson(value){
      this.$router.push({
          path: `/censusDetail`,
          query: {
            id:value['id'],
            idcard:value['idcard']
          }
      })
    },
    clickToSelectAddress() {
      console.log("clickToSelectAddress");
      this.$router
        .push({
          path: `/censusAddress`,
          query: {}
        })
        .then(val => {
          // console.log("back");
        });
    }
  }
};
</script>
<style scoped>
.baseMargin {
  margin-top: 10px;
  display: flex;
}
.card {
  background-color: white;
  border-radius: 20px;
  margin: 3%;
  box-shadow: 0 0 20px #eeeeee;
  padding: 10px;
  /* padding: 10px 0 10px 0; */
}
.buttonRow {
  text-align: center;
  margin-top: 10px;
}
.cardTitle {
  font-size: 28px;
  color: #999999;
}
.shadow {
  border-radius: 20px;
  box-shadow: #eeeeee;
  padding: 3%;
  display: flex;
}
</style>