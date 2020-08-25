<template> 
  <el-card class="form-container" shadow="never">
    <el-form :model="shop"
             ref="shopDetailForm"
             label-width="150px">
      <el-form-item label="店铺名称：" prop="departName">
        <el-input v-model="shopDetail.departName" class="input-width">
        </el-input>
      </el-form-item>
      <el-form-item label="店铺照片：" prop="logo">
        <multi-upload v-model="logo" max-count="1"></multi-upload>
      </el-form-item>
      <el-form-item label="店铺联系电话：" prop="mobile">
        <el-input v-model="shopDetail.mobile" class="input-width">
        </el-input>
      </el-form-item>
      <el-form-item label="经营地址：" prop="address">
        <el-input v-model="shopDetail.address" class="input-width">
        </el-input>
        <!--<div id="map"></div>-->

        <!--<el-button @click="showMap">设置地图</el-button>-->
        <!--<baidu-map-position ref="baiduMap"></baidu-map-position>-->

      </el-form-item>
      <el-form-item label="经营时间：">
          <el-time-select
            v-model="startTime"
            :picker-options="{
              start:'00:00',
              end:'23:30'
            }"
            value-format="HH:mm"
            placeholder="开始时间">
          </el-time-select>
          <el-time-select

            v-model="endTime"
            value-format="HH:mm"
            :picker-options="{
              start:'00:00',
              end:'23:30',
              minTime: startTime
            }"
            placeholder="结束时间">
          </el-time-select>
      </el-form-item>
      <el-form-item label="负责人姓名：" prop="contactName">
        <el-input v-model="shopDetail.contactName" class="input-width">
        </el-input>
      </el-form-item>
      <el-form-item label="负责人电话：" prop="contactPhone">
        <el-input v-model="shopDetail.contactPhone" class="input-width">
        </el-input>
      </el-form-item>
      <el-form-item label="负责人邮箱：" prop="contactEmail">
        <el-input v-model="shopDetail.contactEmail" class="input-width">
        </el-input>
      </el-form-item>
      <el-form-item>
        <el-button
          @click="confirm('shopDetailForm')"
          type="primary">提交</el-button>
      </el-form-item>
    </el-form>

  </el-card>
</template>
<script>
  import request from '@/utils/request'
  import SingleUpload from "../../../components/Upload/singleUpload";
  import MultiUpload from "../../../components/Upload/multiUpload";
  import BaiduMapPosition from "../../../components/map/BaiduMapPosition";
  const defaultShopDetail = {
    id: "",
    departName: "", // 机构/部门名称
    departNameEn: "",  // 英文名
    departNameAbbr: "",  // 缩写
    description: "", // 描述
    orgType: "",  // 机构类型
    orgCode: "", // 机构编码
    mobile: "", // 手机号
    fax: "", // 传真
    address: "", // 地址
    memo: "", // 备注
    status: "", // 状态
    delFlag: "", // 删除状态
    createBy: "", // 创建人
    createTime: "", // 创建日期
    updateBy: "", // 更新人
    updateTime: "", // 更新日期
    departType: "", // 部门类型
    departTypeCategory: "", // 部门详细分类
    longitude: "", // 
    latitude: "", // 
    areaCode: "", // 地区code
    logo: "", // 图标
    contactName:"",
    contactPhone:"",
    contactEmail:"",
    startTime:"",
    endTime:""
  };

  export default {
    name: 'shopDetail',
    components: {BaiduMapPosition, MultiUpload, SingleUpload},
    data() {
      return {
        shopDetail: Object.assign({}, defaultShopDetail),
        logo:[],
        startTime:'',
        endTime:''
      }
    },
    computed:{
      //商品的主图和画册图片
      logo:{
        get:function () {
          let pics=[];
          if(this.shopDetail.logo===undefined||this.shopDetail.logo==null||this.shopDetail.logo===''){
            return pics;
          }
          pics.push(this.shopDetail.logo);
          return pics;
        },
        set:function (newValue) {
          if (newValue == null || newValue.length === 0) {
            this.shopDetail.detail = '';
          } else {
            this.shopDetail.detail = newValue[0];
          }
        }
      }
    },
    created(){
      this.getDetail();
    },
    methods:{
      showMap(){

      },
      confirm(formName) {
        const self = this;
        self.$confirm('是否要提交修改?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {

          if(!!self.logo && self.logo.length > 0){
            self.shopDetail.logo = self.logo[0];
          }

          if(!!self.startTime){
            self.shopDetail.startTime = self.startTime;
          }
          if(!!self.endTime){
            self.shopDetail.endTime = self.endTime;
          }

          request({
            url: '/shop/update',
            method: 'post',
            data: self.shopDetail
          }).then(resp => {
            self.$message({
              type: 'success',
              message: '提交成功!',
              duration:1000
            });
            // window.location.reload();
          });
        });
      },
      getDetail(){
        request({
          url:'/shop/queryDetail',
          method:'get'
        }).then(response => {
          if(!!response.data.sysDepart){
            this.shopDetail = response.data.sysDepart;
            if(!!this.shopDetail.logo){
              this.logo = [this.shopDetail.logo];
            }
          }
          if(!!response.data.params && response.data.params.length > 0){
              for(var i = 0;i<response.data.params.length;i++){
                  if(response.data.params[i].paramCode == 'contactName'){
                    this.shopDetail.contactName = response.data.params[i].paramValue1;
                  }else if(response.data.params[i].paramCode == 'contactPhone'){
                    this.shopDetail.contactPhone = response.data.params[i].paramValue1;
                  }else if(response.data.params[i].paramCode == 'contactEmail'){
                    this.shopDetail.contactEmail = response.data.params[i].paramValue1;
                  }else if(response.data.params[i].paramCode == 'serveDate'){
                    this.shopDetail.startTime = response.data.params[i].paramValue1;
                    this.startTime = response.data.params[i].paramValue1;
                    this.shopDetail.endTime = response.data.params[i].paramValue2;
                    this.endTime = response.data.params[i].paramValue2;
                  }
              }
          }
        });
      }
    }
  }
</script>
<style scoped>
  .input-width {
    width: 50%;
  }

  .note-margin {
    margin-left: 15px;
  }
</style>
<style>
  .el-input-read-only input {
    border: none;
  }
</style>


