<template>
  <div>
    <div v-for="(item,index) in address">
      <!-- {{item.filedName}} -->
    </div>
    <div class="pd-10 bgcw2" v-show="showAddress == 1">
      <div class="f-16 pb-10 mt-20 text-c" v-if="investType == '2'">家庭居住地址录入</div>
      <div class="f-16 pb-10 mt-20 text-c" v-if="investType == '3'">房屋产权地址录入</div>
      <!-- 选择地址 -->
      <div class="mb-50">
        <van-cell-group>
          <van-field v-model="address[0].value"  placeholder="选择社区" disabled @click="address0_pop" />
          <van-field v-model="address[1].value"  placeholder="选择小区" disabled @click="address1_pop" />
          <van-field v-model="address[2].value"  placeholder="选择楼宇" disabled @click="address2_pop" />
          <van-field v-model="address[3].value"  placeholder="请输入单元号" />
          <van-field v-model="address[4].value"  placeholder="请输入房间号" />
        </van-cell-group>

      <van-popup v-model="address0" position="right" :style="{ height: '100%',width:'55%' }">
        <div class="select_out">
          <div class="select_inner pd-10">
            <div v-for="(item,index) in address[0].range">
              <span class="pd-5 mt-5 mb-5 text-c select_span f-14" :class="{select_spaned:index == index_selectspan}" @click="address0_click(index,item.name,item.code,0)">
                {{item.name}}
              </span>
            </div>
          </div>
        </div>
      </van-popup>
      <van-popup v-model="address1" position="right" :style="{ height: '100%',width:'55%' }">
        <div class="select_out">
          <div class="select_inner pd-10">
            <div v-for="(item,index) in address[1].range">
              <span class="pd-5 mt-5 mb-5 text-c select_span f-14" :class="{select_spaned:index == index_selectspan}" @click="address1_click(index,item.name,item.code,1)">
                {{item.name}}
              </span>
            </div>
          </div>
        </div>
      </van-popup>
      <van-popup v-model="address2" position="right" :style="{ height: '100%',width:'55%' }">
        <div class="select_out">
          <div class="select_inner pd-10">
            <div v-for="(item,index) in address[2].range">
              <span class="pd-5 mt-5 mb-5 text-c select_span f-14" :class="{select_spaned:index == index_selectspan}" @click="address2_click(index,item.name,item.code,2)">
                {{item.name}}
              </span>
            </div>
          </div>
        </div>
      </van-popup>


      </div>
      <!-- 填写地址 -->
      <van-button round type="info"  size="large"  v-if="investType == '2'" @click="startSurvey" class="familymess">填写家庭成员信息</van-button>
      <van-button round type="info"  size="large"  v-if="investType == '3'" @click="startSurvey" class="familymess">填写房产信息</van-button>
    </div>

    <!--房屋属性-->
    <div class="pd-10 bgcw2" v-show="showAddress == 2">
      <div class="f-16 pb-10 mt-20 text-c">填写房产信息</div>
      <div v-for="(item,index) in houseInfo">
        <!-- 房屋信息右弹出 下拉-->
         <div class="f-16 pb-10 mt-10">
          <span class="indexspan">{{index+1}}</span>
          {{item.label}}
        </div>
        <van-cell-group>
          <van-field v-model="houseInfo[index].value" disabled  @click="propertyPop(index)" />
        </van-cell-group>
        <div v-if="item.field_type === 'dropdown'" style="margin-bottom: 20px">
          <van-popup v-model="showPropertyInfo" position="right" :style="{ height: '100%',width:'55%' }">
            <div class="select_out">
              <div class="select_inner pd-10">
                <div v-for="(itempro,indexpro) in houseInfo[houseIndex].field_options.options">
                  <span class="pd-5 mt-5 mb-5 text-c select_span f-14" :class="{select_spaned:indexpro == index_selectspan}"  @click="pickPropertyInfo(indexpro,itempro.label,itempro.code.indexpro,houseIndex)">
                    {{itempro.label}}
                  </span>
                </div>
              </div>
            </div>
          </van-popup>
        </div>

      </div>

      

      <van-button round type="info" size="large" v-if="investType == '3'" @click="showAddress = 0;" class="familymess">填写产权人信息</van-button>
    </div>
    <!-- 调查信息start -->
    <div class="bgcw2" v-if="showAddress == 0">
      <div v-for="(item,index) in detailList">
        <div v-if="index === showIndex && pcount > 1" class="text-c c-999 f-16 pd-10">调查成员{{index+1}}</div>
        <div v-if="index === showIndex" class=" pt-15 pb-15">
         
          <div v-if="!!detailList[showIndex].tempFile" class="text-c choise mb-20 choiseID">
            <van-uploader v-model="fileList[index].arrimg" :max-count="1" :after-read="choiseImage" />
              <!-- <img :src="detailList[showIndex].tempFile" mode="widthFix" width="280" height="240" /> -->
          </div>
          <div v-if="detailList[showIndex].tempFile === ''" class="text-c choise pt-30 mb-20">
            <van-uploader v-model="fileList[index].arrimg" :max-count="1" :after-read="choiseImage" class="uploaderHeader"  />
            <br />
            <span class="c-999 f-14">添加身份证照片</span>
          </div>
          <p class="f-12 mb-5 f-orange text-c pb-5" v-show="showTip == true">
            <br />
            <van-icon name="warning-o" />为保证身份证照片识别率高,请竖持手机拍摄
          </p>
          <div class="bgcy"></div>
          <div class="pd-10" v-for="(itemPerson,indexPerson) in detailList[showIndex].fields">
              <div v-if="itemPerson.label == '居住地址'" class="f-16 pb-10 mt-10 pr-10" @click="pickAddress">
                <span class="indexspan">{{itemPerson.position}}</span> 
                  {{itemPerson.label}} 
                <span v-if="itemPerson.required === true" class="f-red">*</span>
                <span class="c-999 right">  <van-icon name="arrow" /></span>
              </div>
              <div v-else-if="itemPerson.label == '房屋地址' || itemPerson.label == '家庭地址'" style="display:none">
              </div>
              <div v-else class="f-16 pb-10 mt-10 pr-10">
                <span class="indexspan">{{itemPerson.position}}</span> {{itemPerson.label}}
                <span v-if="itemPerson.required === true" class="f-red">*</span>
                <van-button type="primary" size="small" v-if="itemPerson.name === 'idcard'" class="right"  @click="searchPerson(indexPerson)">搜索</van-button>
                <div class="clear"></div>
              </div>
              <div v-if="itemPerson.field_type === 'image'" class="text-c">
                <img v-if="detailList[showIndex].tempHeadImage != undefined && detailList[showIndex].tempHeadImage != ''" :src="detailList[showIndex].tempHeadImage" mode="widthFix" style="width:40%;">
                <div v-else class="placeimage"> <van-icon name="manager-o" /> </div>
              </div>
              <!-- 输入框 -->
              <div v-if="itemPerson.field_type === 'text'">
                <div v-if="itemPerson.field_options.integer_only">
                  <van-cell-group>
                    <van-field v-model="detailList[showIndex].fields[indexPerson].value" :placeholder="itemPerson.field_options.description"  :maxlength="itemPerson.field_options.maxlength" />
                  </van-cell-group>
                </div>
                <div v-else>
                  <van-cell-group>
                    <van-field v-model="detailList[showIndex].fields[indexPerson].value" :placeholder="itemPerson.field_options.description" :maxlength="itemPerson.field_options.maxlength"/>
                  </van-cell-group>
                </div>
              </div>
              <!--单选-->
                  <div v-show="itemPerson.field_type === 'radio'" style="margin-bottom: 20px">
                    <van-radio-group
                      v-model="itemPerson.field_options[indexPerson]"
                      @change="radioChange($event,indexPerson,index)"
                    >
                      <div class="bgcw2" v-for="(radio,radioIndex) in itemPerson.field_options.options" :key="radioIndex">
                        <van-radio
                          class="border_style mt-5"
                          v-if="radio.code != null && radio.code != 'undefiend' && radio.code != ''"
                          :name="radio"
                          :value="radio.code"
                          :checked="detailList[showIndex].fields[indexPerson].code === radio.code"
                        >{{radio.label}}</van-radio>
                        <van-radio
                          class="border_style mt-5"
                          v-if="radio.code == null || radio.code == 'undefiend' || radio.code == ''"
                          :value="radio.label"
                          :name="radio"
                          :checked="detailList[showIndex].fields[indexPerson].code === radio.code"
                        >{{radio.label}}</van-radio>
                      </div>
                    </van-radio-group>
                  </div>
                  <!-- 多选框 -->
                  <div v-if="itemPerson.field_type === 'checkboxes'" style="margin-bottom: 20px">
                    <!-- <van-checkbox-group
                     
                    > -->
                      <van-checkbox                       
                        class="border_style mt-5 bgcw2"
                        v-for="(checkbox,checkboxIndex) in itemPerson.field_options.options"
                        :key="checkboxIndex"
                        :name="checkbox.label"
                        v-model="checkbox.checked"
                       @change="checkboxChange(checkbox.checked,checkbox.label,indexPerson,index)"
                      >{{checkbox.label}}</van-checkbox>
                    <!-- </van-checkbox-group> -->
                  </div>
                  <!-- 右侧弹出选择 下拉 -->
                  <div v-if="itemPerson.field_type === 'dropdown'" style="margin-bottom: 20px">
                    <van-cell-group>
                      <van-field v-model="detailList[index].fields[indexPerson].value" placeholder="点击选择"  disabled @click="selectPop(indexPerson)" />
                    </van-cell-group>
                    <van-popup v-model="selectShow" position="right" :style="{ height: '100%',width:'55%' }">
                        <div class="select_out">
                          <div class="select_inner pd-10">
                              <div class="" v-for="(itemSelect,indexSelect) in detailList[showIndex].fields[select_all_Index].field_options.options"> 
                                  <span class="pd-5 mt-5 mb-5 text-c select_span f-14" :class="{select_spaned:indexSelect == index_selectspan}"  @click="selectItem(indexSelect,itemSelect.label,itemSelect.code,select_all_Index,index)">{{itemSelect.label}}</span> 
                              </div>
                          </div>
                        </div>
                    </van-popup>
                  </div>
                  <!-- 选择地址右弹出 -->
                  <div v-if="itemPerson.label == '居住地址'">
                    <!-- <p class="f-14 mt-10 pd-10 c-999" >点击选择居住地址 <span class="right">  </span> </p> -->
                    <div class="pl-10 pr-10 f-14" v-if="!!detailList[showIndex].fields[indexPerson].addressPersonal[5].value"> </div>
                    <div v-else class="pl-10 pr-10 f-14 pt-10 pb-10">
                      <p v-if="!!detailList[showIndex].fields[indexPerson].addressPersonal[0].value">
                        {{detailList[showIndex].fields[indexPerson].addressPersonal[0].value}}
                        <span style="color:#999;font-size:11px;">社区</span>
                        {{detailList[showIndex].fields[indexPerson].addressPersonal[1].value}}
                        <span style="color:#999;font-size:11px;">小区</span>
                        {{detailList[showIndex].fields[indexPerson].addressPersonal[2].value}}
                        <span style="color:#999;font-size:11px;">楼</span>
                        {{detailList[showIndex].fields[indexPerson].addressPersonal[3].value}}
                        <span style="color:#999;font-size:11px;">单元</span>
                        {{detailList[showIndex].fields[indexPerson].addressPersonal[4].value}}
                        <span style="color:#999;font-size:11px;">房间</span>
                      </p>
                    </div>
                      <van-popup v-model="addressShow" position="right" :style="{ height: '100%',width:'100%' }">
                        <div class="pd-10 mg-10">
                          <van-cell-group >
                            <van-field disabled v-model="detailList[showIndex].fields[indexPerson].addressPersonal[0].value" placeholder="点击选择社区" class="mt-10 mb-10 pt-10 pb-10"  @click="personal0_pop(indexPerson,0)"/>
                            <van-field disabled v-model="detailList[showIndex].fields[indexPerson].addressPersonal[1].value" placeholder="点击选择小区" class="mt-10 mb-10 pt-10 pb-10"  @click="personal1_pop(indexPerson,1)"/>
                            <van-field disabled v-model="detailList[showIndex].fields[indexPerson].addressPersonal[2].value" placeholder="点击选择楼宇" class="mt-10 mb-10 pt-10 pb-10"  @click="personal2_pop(indexPerson,2)"/>
                            <van-field v-model="detailList[showIndex].fields[indexPerson].addressPersonal[3].value" placeholder="请输入单元号" class="mt-10 mb-10 pt-10 pb-10" />
                            <van-field v-model="detailList[showIndex].fields[indexPerson].addressPersonal[4].value" placeholder="请输入房间号" class="mt-10 mb-10 pt-10 pb-10" />
                          </van-cell-group>
                          <p class="f-10 f-red mt-30"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;找不到地址请手动填写</p>
                          <van-cell-group>
                            <van-field v-model="detailList[showIndex].fields[indexPerson].addressPersonal[5].value" placeholder="请输入详细地址" class="mt-10 mb-10 pt-10 pb-10" />
                          </van-cell-group>
                          <div class="mt-30">
                            <van-row type="flex" justify="center"> 
                              <van-col span="6"><van-button plain hairline type="primary"  size="small" @click="addressShow = false">取消</van-button></van-col>
                              <van-col span="6"><van-button plain hairline type="primary"  size="small" @click="addressShow = false">保存</van-button></van-col>
                            </van-row>
                          </div>
                        <van-popup v-model="addressDetail0_Show" position="right" :style="{ height: '100%',width:'55%' }">
                            <div class="select_out">
                              <div class="select_inner pd-10">
                                <div class="" v-for="(itemAddress,indexAddress) in detailList[showIndex].fields[indexPerson].addressPersonal[0].range">
                                    <span class="pd-5 mt-5 mb-5 text-c select_span f-14" @click="addressItem0_Personal(indexPerson,indexAddress,itemAddress.name,itemAddress.code,itemAddress.id)">{{itemAddress.name}} </span>
                                </div>
                              </div>
                            </div>
                        </van-popup>
                        <van-popup v-model="addressDetail1_Show" position="right" :style="{ height: '100%',width:'55%' }">
                            <div class="select_out">
                              <div class="select_inner pd-10">
                                <div class="" v-for="(itemAddress,indexAddress) in detailList[showIndex].fields[indexPerson].addressPersonal[1].range">
                                    <span class="pd-5 mt-5 mb-5 text-c select_span f-14" @click="addressItem1_Personal(indexPerson,indexAddress,itemAddress.name,itemAddress.code)">{{itemAddress.name}} </span>
                                </div>
                              </div>
                            </div>
                        </van-popup>
                        <van-popup v-model="addressDetail2_Show" position="right" :style="{ height: '100%',width:'55%' }">
                            <div class="select_out">
                              <div class="select_inner pd-10">
                                <div class="" v-for="(itemAddress,indexAddress) in detailList[showIndex].fields[indexPerson].addressPersonal[2].range">
                                    <span class="pd-5 mt-5 mb-5 text-c select_span f-14" @click="addressItem2_Personal(indexPerson,indexAddress,itemAddress.name,itemAddress.code)">{{itemAddress.name}} </span>
                                </div>
                              </div>
                            </div>
                        </van-popup>
                        </div>
                      </van-popup>
                  </div>
                  <!-- 多行文本 -->
                  <div v-if="itemPerson.field_type === 'paragraph'">
                    <div style="border:0.266vw solid #f5f5f5">
                    <van-field v-model="detailList[showIndex].fields[indexPerson].value"  type="textarea" :placeholder="itemPerson.field_options.description" :maxlength="itemPerson.field_options.maxlength" rows="5" autosize/>
                    </div>
                  </div>
                  <!--分页符-->
                  <div v-if="itemPerson.field_type === 'section_break'"></div>
                
          </div>
        </div>
      </div>
      <!-- 调查信息end -->
      <!-- 签名 -->
      <div class="mt-10 pd-10" v-show="detailList[showIndex].sign == 0 && detailList[showIndex].signature === '1' " >
        <van-button size="small" @click="startSign">开始签名</van-button>
        <van-popup v-model="showPickersign" position="right" :style="{ width: '100%',height:'100%'}" @opened="showcanves">
          <div style="width:100%" class="text-c mt-50">
            <canvas
              id="canvas"
              width="300"
              height="300"
              @touchstart="canvasDown($event)"
              @touchmove="canvasMove($event)"
              @mouseup="canvasUp($event)"
              @touchend="canvasLeave($event)"
              ref="canvas"
            >抱歉，您的浏览器不支持canvas元素</canvas>
          </div>
          <div class="text-c">
            <van-button
              plain
              hairline
              type="primary"
               size="small"
              @click="showPickersign = false"
              class="mr-5"
            >取消</van-button>
            <van-button plain hairline type="primary"  size="small" @click="clear" class="mr-5">清除</van-button>
            <van-button plain hairline type="primary"  size="small" @click="saveSign">保存</van-button>
          </div>
        </van-popup>
        <div style="margin:10px auto;text-align:center" v-if="canvasPic[showIndex] != null && canvasPic[showIndex] != ''">
            <img class="canvasimg" :src="canvasPic[showIndex]"/>
        </div>
      </div>
      <!-- 下一页 上一页 编辑 提交 -->
      <div class="bgcy"></div>
      <div class="pd-10 text-l">
        <van-row class="mb-20">
          <van-col span="19">
            <van-button size="small" v-if="addressFirst === '1' && showIndex == 0 && investType == '2'"  @click="showAddress = 1">编辑家庭地址</van-button>
            <van-button size="small" v-if="addressFirst === '1' && showIndex == 0 && investType == '3'"  @click="showAddress = 1">编辑产权地址</van-button>
            <van-button size="small" v-if="showIndex > 0 && pcount > 1" @click="showIndex = showIndex - 1">上一页</van-button> &nbsp;&nbsp;
            <van-button size="small" v-if="showIndex < pcount-1 && pcount > 1" @click="nextPage">下一页</van-button>
          </van-col>
          <van-col span="5">
             <van-button type="info" size="small"  @click="formUpload">提交</van-button>
          </van-col>
        </van-row>
          
      </div>
    </div>


  </div>
</template>
<script>
import upload from "@/api/PublicOpinion/PublicOpinion";
import detail from "@/api/invest/investDetail";
import { Dialog } from "vant";
import Exif from 'exif-js';
export default {
  data() {
    return {
      id: "", //调查模板的id
      investType: "0", //调查类型
      detailList: [{ sign: 0, signature: 0 }], //模板数组
      showIndex: 0, //调查的第几个人
      pcount: 1,
      showAddress: 0,
      addressFirst: "1", //第一页显示地址信息
      address: [  //房屋产权获取地址
        { range: [], list: [],value:"" },
        { range: [], list: [],value:"" },
        { range: [], list: [],value:"" },
        { value: "" },
        { value: "" }
      ],
      addressPersonalIndex: -1,
      otherAddress:[],

      checked_checkbox: [],//复选框数组
      selectShow:false,//下拉框的pop
      addressShow:false,//居住地址的pop

      addressDetail0_Show:false,//社区小区楼宇弹出 个人居住地址
      addressDetail1_Show:false,
      addressDetail2_Show:false,

      showPickersign: false,//签名弹出
      select_all_Index:1,//下拉框使用的index
      houseIndex: 1,//房屋信息下拉框使用的index
      index_selectspan:-1,

      canvasPic: [],
      canvas: null,
      ctx: "",
      canvesURL: "",

      fileList: [],
      showTip: true, //当身份证上传完成后，下面的提示隐藏

      houseInfo: [],

      showPropertyInfo:false, // 房屋产权信息pop

      address0:false,
      address1:false,
      address2:false,
      idcardArr:[],//要上传的身份证数组


    };
  },
  methods: {
    //去下一页
    nextPage() {
      this.showIndex = this.showIndex + 1;
      if (this.addressPersonalIndex > 0 && this.investType === "2" ){
        // this.getAddressPersonalList(this.addressPersonalIndex, 0);
      }
    },
    async getInvestigationDetail() {
      // let addressPersonalIndex = -1;
      let res = await detail.gettemDetail(this.id);
      res = JSON.parse(res);
      this.investType = res.type;
      let _this = this;
      let temp = res;
      let fields = JSON.parse(res.content);
      temp.fields = [];
      let position = 0;
      fields.fields.forEach(function(item, index) {
          //如果是房屋地址或者家庭地址  
          if (item.field_type === "address-family" || item.field_type === "address-property") {
              let fieldNames = item.field_name;
              fieldNames.forEach(function(fieldNameItem, filedNameIndex) {
                _this.address[filedNameIndex] = {
                  filedName: fieldNameItem,
                  value: "",
                  index: "",
                  list: [],
                  range: []
                };
              });
              
              _this.showAddress = 1;
              _this.addressFirst = "1";
          } else if (item.field_type === "address-personal") { //如果是居住地址（模板带编号的）
              position++;
              let fieldNames = item.field_name;
              item.addressPersonal = new Array();
              fieldNames.forEach(function(fieldNameItem, filedNameIndex) {
                item.addressPersonal[filedNameIndex] = {
                  filedName: fieldNameItem,
                  value: "",
                  index: "",
                  list: [],
                  range: []
                };
              });
              _this.addressPersonalIndex = index;
          } else {
              item.field_type = item.field_type.split("-")[0];
              item.name = item.field_name.split("-")[0];
              item.value = "";

              if(item.name != "droitType" && item.name != "houseUse" && item.name != "isRent" && item.name != "liveType")
                 position++;

              //如果是下拉
              if (item.field_type === "dropdown") {
                item.value = item.field_options.options[0].label;
                item.code = item.field_options.options[0].code;

                if (item.nameArr == undefined) {
                  item.nameArr = [];
                }
                if (item.field_options.options != undefined) {
                  item.field_options.options.forEach(function(option, pos) {
                    item.nameArr.push(option.label);
                  });
                }
              }
          }
        item.position = position;
        temp.fields.push(item);
      });
      temp.sign = 0;
      temp.signPic = "";
      temp.takePhoto = "0";
      temp.tempFile = "";
      let pcount = 1;
      if (!!res.pcount && res.pcount > 1) {
        pcount = res.pcount;//调查的人口数
      }
      this.detailList = [];
      this.houseInfo = [];
      for (let i = 0; i < pcount; i++) {
        this.otherAddress.push("");
        let json = JSON.parse(JSON.stringify(temp));
        let tempJson = JSON.parse(JSON.stringify(temp));
        let delArr = [];
        tempJson.fields.forEach(function(item, index) {
          if (
            item.name === "droitType" ||
            item.name === "houseUse" ||
            item.name === "isRent" ||
            item.name === "liveType"
          ) {
            if (i == 0) {
              _this.houseInfo.push(item);
            }
            delArr.push(index);
          }
        });
        delArr.forEach(function(item2, index2) {
          for (let j = 0; j < tempJson.fields.length; j++) {
            let item = tempJson.fields[j];
            if (
              item.name === "droitType" ||
              item.name === "houseUse" ||
              item.name === "isRent" ||
              item.name === "liveType"
            ) {
              json.fields.splice(j, 1);
              break;
            }
          }
        });

        //如果是房屋类型，只调查第一个人就可以
        this.detailList.push(json);
      }
      this.pcount = pcount;

      if (_this.address.length > 0) {
        //加载社区列表数据
        _this.getAddressPropertyList(0,'');
      }
      for(var i = 0;i< this.detailList.length;i++){
        this.fileList.push({"arrimg":[]})
      }
      // console.log(this.fileList)
      

      // console.log(JSON.stringify(this.address))
    },
    radioChange(e,indexPerson,index) {
      let _this = this;
      let code = "",
        label = "";
      this.detailList[index].fields[indexPerson].field_options.options.forEach(function(item, index) {
          if (item.code === e.code) {
              code = item.code;
              label = item.label;
          }
        }
      );
      if (label === "") {
        label = e.label;
        code = e.code;
      }
      this.detailList[index].fields[indexPerson].value = label;
      this.detailList[index].fields[indexPerson].code = code;
      // console.log(JSON.stringify(this.detailList[index]))
    },
    //多选改变监听
    checkboxChange(checked,label,indexPerson,index) {
      if(checked == true){
      this.detailList[index].fields[indexPerson].value += label+',';
      }else{
       let sss = this.detailList[index].fields[indexPerson].value.split(",");
        for(let i in sss){
          if(label == sss[i]){
            sss.splice(i,1);
          }
        }
         this.detailList[index].fields[indexPerson].value  = sss.toString();
      }

     
      //  console.log(JSON.stringify(this.detailList[index]))
    },
    //下拉框点击弹出
    selectPop(index){
        this.selectShow = true;
        this.select_all_Index = index;
    },
    //选中下拉框
    selectItem(indexSelect,label,code,select_all_Index,index){
      // console.log(label,code,select_all_Index,index);
      this.detailList[index].fields[select_all_Index].value = label;
      this.detailList[index].fields[select_all_Index].code = code;
      this.index_selectspan = indexSelect;
       this.selectShow = false;
    },
    //点击选择居住地址
    pickAddress(){
      this.addressShow = true;
    },
    //点击个人地址选择社区
    personal0_pop(index,code){
      this.getAddressPersonalList(0,"",index);
      this.addressDetail0_Show = true;

    },
    personal1_pop(name,code,index){
      // this.getAddressPersonalList(index,code);
      this.addressDetail1_Show = true;

    },
    personal2_pop(name,code,index){
      // this.getAddressPersonalList(index,code);
      this.addressDetail2_Show = true;

    },
    //房屋产权地址选择
    async getAddressPropertyList(type,code) {
      let _this = this;
      let paramId = "";
      let res = await detail.getAddressList(type,code);
      res = JSON.parse(res);

      this.address[type].list = res;
      this.address[type].range = [];
      // console.log(JSON.stringify( this.address[type].list))
      this.address[type].list.forEach(function(item, index) {
        if (type === 0) {
          _this.address[type].range.push({"name":item.departname,"code":item.org_code});
        } else if (type === 1) {
          _this.address[type].range.push({"name":item.village_name,"code":item.id});
        } else if (type === 2) {
          _this.address[type].range.push({"name":item.building_name,"code":item.id});
        }
      });
      // console.log(JSON.stringify( this.address[type]))
    },
    //个人居住地址选择
   async getAddressPersonalList(type,code,indexPerson){
       let res = await detail.getAddressList(type, code);
       res = JSON.parse(res);
       this.detailList[this.showIndex].fields[indexPerson].addressPersonal[type].list = res;
       this.detailList[this.showIndex].fields[indexPerson].addressPersonal[type].range = [];
       let _this = this;
       this.detailList[this.showIndex].fields[indexPerson].addressPersonal[type].list .forEach(function(item,index){
         if (type === 0) {
          _this.detailList[_this.showIndex].fields[indexPerson].addressPersonal[type].range.push({"name":item.departname,"code":item.org_code,"id":item.ID});
        } else if (type === 1) {
          _this.detailList[_this.showIndex].fields[indexPerson].addressPersonal[type].range.push({"name":item.village_name,"code":item.id});
        } else if (type === 2) {
          _this.detailList[_this.showIndex].fields[indexPerson].addressPersonal[type].range.push({"name":item.building_name,"code":item.id});
        }
       })
        // console.log(JSON.stringify(  this.detailList[this.showIndex].fields[indexPerson]))
    },
    //居住地址选中
    // addressItem(){
    //  this.detailList[index].fields[indexPerson].addressPersonal[0].value = label;

    // },
    //个人居住地址span 选择 社区
    addressItem0_Personal(indexPerson,indexAddress,name,code,id){
      this.detailList[this.showIndex].fields[indexPerson].addressPersonal[0].value = name;
      this.detailList[this.showIndex].fields[indexPerson].addressPersonal[0].index = indexAddress;
      this.detailList[this.showIndex].fields[indexPerson].addressPersonal[0].code = id;
      this.addressDetail0_Show = false;
      this.getAddressPersonalList(1,code,indexPerson);
    },
    addressItem1_Personal(indexPerson,indexAddress,name,code){
      this.detailList[this.showIndex].fields[indexPerson].addressPersonal[1].value = name;
      this.detailList[this.showIndex].fields[indexPerson].addressPersonal[1].index = indexAddress;
      this.detailList[this.showIndex].fields[indexPerson].addressPersonal[1].code = code;
      this.addressDetail1_Show = false;
      this.getAddressPersonalList(2,code,indexPerson);
    },
    addressItem2_Personal(indexPerson,indexAddress,name,code){
      this.detailList[this.showIndex].fields[indexPerson].addressPersonal[2].value = name;
      this.detailList[this.showIndex].fields[indexPerson].addressPersonal[2].index = indexAddress;
      this.detailList[this.showIndex].fields[indexPerson].addressPersonal[2].code = code;
      this.addressDetail2_Show = false;
    },
     //开始签名
    startSign() {
      this.showPickersign = true;
    },
    async saveSign() {
      //上传画布数据
      let file = canvas.toDataURL("image/jpg");
      let arr = [];
      arr.push(file);
      let resCanves = await upload.uploadImage(arr);
      // resCanves = JSON.parse(resCanves);
      resCanves = JSON.parse(resCanves);
      let _this = this;
      resCanves.forEach(function(itemCanvas, indexCanvas) {
        _this.canvasPic[_this.showIndex] = _this.common.showPicture(itemCanvas.url);
        _this.detailList[_this.showIndex].signPic = itemCanvas.url;
      });
      this.clearCanvas();
      this.showPickersign = false;
    },
    clearCanvas() {
      let c = document.getElementById("canvas");
      let cxt = c.getContext("2d");
      cxt.clearRect(0, 0, c.width, c.height);
    },
    showcanves() {
      if(this.canvas != null){
        return;
      }
      let canvas = document.getElementById("canvas");
      this.canvas = canvas; //指定canvas
        this.ctx = this.canvas.getContext("2d"); //设置2D渲染区域
        let width = this.canvas.width,height=this.canvas.height;
          if (window.devicePixelRatio) {
            this.canvas.style.width = width + "px";
            this.canvas.style.height = height + "px";
            this.canvas.height = height * window.devicePixelRatio;
            this.canvas.width = width * window.devicePixelRatio;
              this.ctx.scale(window.devicePixelRatio, window.devicePixelRatio);
          }
      this.ctx.lineWidth = 2; //设置线的宽度
      this.ctx.strokeStyle = "#000";
      this.stage_info = canvas.getBoundingClientRect();
    },
    canvasDown(e) {
      this.canvasMoveUse = true;
      const canvasX = e.changedTouches[0].clientX - this.canvas.offsetLeft;
      const canvasY = e.changedTouches[0].clientY - this.canvas.offsetTop ;
      this.ctx.beginPath(); // 移动的起点
      this.ctx.moveTo(canvasX, canvasY);
    },
    canvasMove(e) {
      if (this.canvasMoveUse) {
        // 只有允许移动时调用
        const t = e.target;
        let canvasX;
        let canvasY;
        canvasX = e.changedTouches[0].clientX - this.canvas.offsetLeft;
        canvasY = e.changedTouches[0].clientY - this.canvas.offsetTop;
        this.ctx.lineTo(canvasX, canvasY);
        this.ctx.stroke();
          window.onload=function(){
           var c1 = new MyCanvas();
           c1.drawLine([{ x: 200.5, y: 10 }, { x: 200.5, y: 200 }],{lineWidth:1,strokeStyle:'rgb(0,0,0)'}); //+0.5偏移
       }
      }
    },
    canvasUp(e) {
      this.canvasMoveUse = false;
    },
    canvasLeave(e) {
      this.canvasMoveUse = false;
    },
    clear() {
      this.ctx.clearRect(0, 0, this.ctx.canvas.width, this.ctx.canvas.height);
    },
   
    // 选择图片上传身份证
     choiseImage(file) {
      let _this = this;
      let idcardArr = [];
      this.detailList[this.showIndex].takePhoto = "1";
        // if(file.file.size >= 0){
           this.common.reduceImage(file,function(data){
              // console.log(data);
              idcardArr.push(data);
              _this.showIDcardInfo(idcardArr);
            });
    
        // }else{
        //   idcardArr.push(file.content);
        //   _this.showIDcardInfo(idcardArr);
        // }
    },
    //身份证回显信息
    async showIDcardInfo(idcardArr){
      let _this = this;
       let res = await upload.uploadImage(idcardArr,0);
           res = JSON.parse(res);
           
          try {
                let result = res;
                  _this.detailList[ _this.showIndex].tempFile = _this.common.showPicture(result.obj[0].url);
                  _this.detailList[_this.showIndex].headImage =result.attributes.cutImage;
                  _this.detailList[_this.showIndex].tempHeadImage = _this.common.showPicture(result.attributes.cutImage,"",false);
                  var idcard = result.attributes.idcard;
                  _this.detailList[_this.showIndex].fields.forEach(function(item,index) {
                    if (item.field_type != "address-family" && item.field_type != "address-property" && item.field_type != "address-personal") {
                      let typename = item.field_name.split("-");
                      if (typename[0] === "idcard") {
                        _this.detailList[_this.showIndex].fields[index].value = idcard.cards[0].id_card_number;
                      } else if (typename[0] === "personName") {
                        _this.detailList[_this.showIndex].fields[index].value = idcard.cards[0].name;
                      } else if (typename[0] === "sex") {
                        if (idcard.cards[0].gender === "男") {
                          _this.detailList[_this.showIndex].fields[index].code = "0";
                          _this.detailList[_this.showIndex].fields[index].value ="男";
                        }
                        if (idcard.cards[0].gender === "女") {
                          _this.detailList[_this.showIndex].fields[index].code = "1";
                          _this.detailList[_this.showIndex].fields[index].value ="女";
                        }
                      } else if (typename[0] === "rprDetailAddr") {
                        _this.detailList[_this.showIndex].fields[index].value = idcard.cards[0].address;
                      } else if (typename[0] === "nationality") {
                        let options = item.field_options.options;
                        options.forEach(function(option, position) {
                          if (option.label === idcard.cards[0].race + "族") {
                            _this.detailList[_this.showIndex].fields[index].value = option.label;
                            _this.detailList[_this.showIndex].fields[index].code = option.code;
                          }
                        });
                      }
                    }
                  });
              } catch (err) {
              Dialog({ message: "识别失败，请保证身份证清晰可辨" });
          }
      this.showTip = false;

    },
    //根据身份证搜索居民信息
     async searchPerson(index) {
      let _this = this;
      let idcard = this.detailList[this.showIndex].fields[index].value;
      // if (!CheckIdCard.checkIdCard(idcard)) {
      //   alert("提示信息：请输入正确的身份证号");
      //   return;
      // }
      let param = { idcard: idcard };
      let d = await detail.getPersonInfo(param);
      d = JSON.parse(d);
      if (d.length > 0) {
        let person = d[0];
        _this.detailList[_this.showIndex].fields.forEach(function(item, pos) {
          try {
            if (!!item.name) {
             
              if (!!person.personName) {
                if (item.label === "姓名"){
                  _this.detailList[_this.showIndex].fields[pos].value = person.personName;
                } else if(item.label ==="手机号"){
                  _this.detailList[_this.showIndex].fields[pos].value = person.mobilePhone;
                }else if(item.label === "身份证"){
                  _this.detailList[_this.showIndex].fields[pos].value = person.idcard;
                }else if(item.label === "性别"){
                  _this.detailList[_this.showIndex].fields[pos].code = person.sex;
                  if(person.sex == "0"){
                  _this.detailList[_this.showIndex].fields[pos].value ="女";
                  }
                  if(person.sex == "1"){
                  _this.detailList[_this.showIndex].fields[pos].value ="男";
                  }
                }else {
                  // let code = person[name];
                  // _this.detailList[_this.showIndex].fields[pos].value = person[name];
                  // item.field_options.options.forEach(function(options) {
                  //   if (options.code == code) {
                  //     _this.detailList[_this.showIndex].fields[pos].value = options.label;
                  //   }
                  // });
                }
              }
            }
          } catch (err) {
            console.log(err);
          }
        });
      } else {
        Dialog({ message: "未查询到此身份证信息，请手动填写" });
      }

      this.getPersonAddress(idcard);
    },
     //获取居民的居住地址
    async getPersonAddress(idcard) {
      let _this = this;
      let d = await detail.personAddress(idcard);
      d = JSON.parse(d);
      // console.log(JSON.stringify(d));
      if(JSON.stringify(d) != "{}"){
        let index;
        for (let i = 0; i < _this.detailList[_this.showIndex].fields.length; i++) {
          if (_this.detailList[_this.showIndex].fields[i].field_type === "address-personal") {
              index = i;
            break;
          }
        }
      _this.detailList[_this.showIndex].fields[index].addressPersonal[5].value =  "";
      _this.detailList[_this.showIndex].fields[index].addressPersonal[3].value = "";
      _this.detailList[_this.showIndex].fields[index].addressPersonal[4].value = "";
      _this.detailList[_this.showIndex].fields[index].addressPersonal[1].list = [];
      _this.detailList[_this.showIndex].fields[index].addressPersonal[1].range = [];
      _this.detailList[_this.showIndex].fields[index].addressPersonal[2].list = [];
      _this.detailList[_this.showIndex].fields[index].addressPersonal[2].range = [];

        if (!!d.otherAddress) {
          _this.detailList[_this.showIndex].fields[index].addressPersonal[5].value = d.otherAddress;
        } else {
          _this.detailList[_this.showIndex].fields[index].addressPersonal[3].value = d.unitNo;
          _this.detailList[_this.showIndex].fields[index].addressPersonal[4].value = d.houseNo;

          _this.detailList[_this.showIndex].fields[index].addressPersonal[0].list = d.communitys;
          _this.detailList[_this.showIndex].fields[index].addressPersonal[0].range = [];
          d.communitys.forEach(function(item, pos) {
            _this.detailList[_this.showIndex].fields[index].addressPersonal[0].range.push(item.departname);
            if (item.org_code === d.sysOrgCode){
              _this.detailList[_this.showIndex].fields[index].addressPersonal[0].value = item.departname;
              _this.detailList[_this.showIndex].fields[index].addressPersonal[0].index = pos;
              _this.detailList[_this.showIndex].fields[index].addressPersonal[0].code = item.ID;
            }
          });

          _this.detailList[_this.showIndex].fields[index].addressPersonal[1].list = d.villages;
          _this.detailList[_this.showIndex].fields[index].addressPersonal[1].range = [];
          d.villages.forEach(function(item, pos) {
            _this.detailList[_this.showIndex].fields[index].addressPersonal[1].range.push(item.village_name);
            if (item.id === d.villageId){
              
              _this.detailList[_this.showIndex].fields[index].addressPersonal[1].value = item.village_name;
              _this.detailList[_this.showIndex].fields[index].addressPersonal[1].code = item.id;
            }
          });

          _this.detailList[_this.showIndex].fields[index].addressPersonal[2].list = d.buildings;
          _this.detailList[_this.showIndex].fields[index].addressPersonal[2].range = [];
          d.buildings.forEach(function(item, pos) {
            _this.detailList[_this.showIndex].fields[index].addressPersonal[2].range.push(item.building_name);
            if (item.id === d.buindingId)
              _this.detailList[_this.showIndex].fields[index].addressPersonal[2].value = item.building_name;
              _this.detailList[_this.showIndex].fields[index].addressPersonal[2].code = item.id;
          });
        }
      }else{

      }
      
    },
     //开始调查
    startSurvey() {
      //调查类型
      if (this.investType === "3" && this.houseInfo.length > 0) {
        this.showAddress = 2;
      } else {
        this.showAddress = 0;
      }
    },
    pickPropertyInfo(indexpro,label, code, index, itemIndex) {
      this.houseInfo[index].value = label;
      this.houseInfo[index].code = code;
      this.showPropertyInfo = false;
      this.index_selectspan = indexpro;
    },
    propertyPop(index){
      this.showPropertyInfo = true;
      this.houseIndex = index;
    },
    address0_pop(){
      this.address0 = true;
      // this.getAddressPropertyList(0,"")
    },
     address1_pop(){
      this.address1 = true;
    },
     address2_pop(){
      this.address2 = true;
    },
    address0_click(itemIndex,name,code,index){
      this.address[index].value = name;
      this.address[index].index = itemIndex;
      this.address0 = false;
      this.getAddressPropertyList(1,code);
    },
     address1_click(itemIndex,name,code,index){
      this.address[index].value = name;
      this.address[index].index = itemIndex;
      this.address1 = false;
      this.getAddressPropertyList(2,code);
    },
     address2_click(itemIndex,name,code,index){
      this.address[index].value = name;
      this.address[index].index = itemIndex;
      this.address2 = false;
    },
     //提交form表单
    formUpload() {
      let _this = this;
      let message = "是否确认提交调查信息";
      if (this.pcount > 1 && this.showIndex < this.pcount - 1) {
        message += "，注意只提交前" + (this.showIndex + 1) + "页";
      }

      var signData = [];

      this.$dialog
        .confirm({ title: "提示", message: message })
        .then(() => {
          //判断数据的完整性
          for (let i = 0; i <= _this.showIndex; i++) {
            for (let j = 0, len2 = _this.detailList[i].fields.length;j < len2; j++) {
              if ( _this.detailList[i].fields[j].required && _this.detailList[i].fields[j].value === "") {
                    Dialog({ message: "请将" + _this.detailList[i].fields[j].label + "填写完成" });
                    _this.showIndex = i;
                    return;
              }
              if (_this.detailList[i].fields[j].name === "idcard") {
                if (!_this.detailList[i].fields[j].value) {
                      Dialog({ message: "身份证不正确"});
                      _this.showIndex = i;
                      return;
                  }
                }
            }
          }

          for (let i = 0; i <= _this.showIndex; i++) {
            for (let j = 0, len2 = _this.detailList[i].fields.length;j < len2;j++) {
              if ( _this.detailList[i].fields[j].required && _this.detailList[i].fields[j].field_type === "address-personal") {
                if ((_this.detailList[i].fields[j].addressPersonal[0].value =="" || _this.detailList[i].fields[j].addressPersonal[0].value == null) && (_this.detailList[i].fields[j].addressPersonal[5].value == "" ||  _this.detailList[i].fields[j].addressPersonal[5].value == null)) {
                    Dialog({message:"请将地址填写完成"});
                    _this.showIndex = i;
                    return;
                }
              }
            }
          }
          var formData = [];
          for (let i = 0; i <= _this.showIndex; i++) {
            let temp = [];
            for (let j = 0, len2 = _this.detailList[i].fields.length; j < len2; j++) {
              if (_this.detailList[i].fields[j].field_type === "address-property" || _this.detailList[i].fields[j].field_type === "address-family")
                continue;
              //个人地址
              // console.log(_this.detailList[i].fields[j].field_type)
              if ( _this.detailList[i].fields[j].field_type === "address-personal") {
                _this.detailList[i].fields[j].addressPersonal.forEach(function(addressItem,addressPos) {
                
                  if (addressItem.value != undefined) {
                    // if (addressItem.list.length > 0) {
                    //   let fieldValue = "",
                    //     filedCode = addressItem.list[addressItem.index].id;
                    //   if (addressPos == 0) {
                    //     fieldValue = addressItem.list[addressItem.index].departname;
                    //     filedCode  = addressItem.list[addressItem.index].ID;
                    //   } else if (addressPos == 1) {
                    //     fieldValue = addressItem.list[addressItem.index].village_name;
                    //   } else if (addressPos === 2) {
                    //     fieldValue = addressItem.list[addressItem.index].building_name;
                    //   }
                    //   temp.push({
                    //     fieldName: addressItem.filedName,
                    //     fieldValue: fieldValue,
                    //     fieldCode: filedCode
                    //   });
                    //   console.log(JSON.stringify(temp))
                    // } else {
                        // console.log(JSON.stringify(addressItem))
                     
                      if (addressItem.value != null && addressItem.value != ""){
                        // console.log(JSON.stringify(addressItem))
                            temp.push({
                              fieldName: addressItem.filedName,
                              fieldValue: addressItem.value,
                              fieldCode: addressItem.code
                            });
                      }
                        
                    // }
                  }
                });
                continue;
              }
              //  console.log(JSON.stringify(temp))
              let fieldName = _this.detailList[i].fields[j].field_name;
              let code = _this.detailList[i].fields[j].code;
              if (_this.detailList[i].fields[j].field_type === "image") {
                let value = "";
                value = _this.detailList[i].headImage;
                temp.push({
                  fieldName: fieldName,
                  fieldValue: value,
                  fieldCode: code
                });
                continue;
              }
              let value = _this.detailList[i].fields[j].value;
              temp.push({
                fieldName: fieldName,
                fieldValue: value,
                fieldCode: code
              });
            }
            formData.push(temp);
          }
          if (_this.address.length > 0) {
            _this.address.forEach(function(addressItem, addressPos) {
             
              if (addressItem.value != "" && addressItem.value != null) {
                if (addressItem.list.length > 0) {
                  let fieldValue = "";
                  let filedCode = addressItem.list[addressItem.index].id;
                  if (addressPos === 0) {
                    fieldValue = addressItem.list[addressItem.index].departname;
                    filedCode = addressItem.list[addressItem.index].ID;
                  } else if (addressPos === 1) {
                    fieldValue = addressItem.list[addressItem.index].village_name;
                    filedCode = addressItem.list[addressItem.index].id;
                  } else if (addressPos === 2) {
                    fieldValue = addressItem.list[addressItem.index].building_name;
                    filedCode = addressItem.list[addressItem.index].id;
                  }
                  formData[0].push({
                    fieldName: addressItem.filedName,
                    fieldValue: fieldValue,
                    fieldCode: filedCode
                  });
                } else {
                  formData[0].push({
                    fieldName: addressItem.filedName,
                    fieldValue: addressItem.value,
                  });
                }
              }
            });
              console.log(JSON.stringify( _this.houseInfo))
            _this.houseInfo.forEach(function(houseItem, housePos) {
              formData[0].push({
                fieldName: houseItem.field_name,
                fieldValue: houseItem.value,
                fieldCode: houseItem.code
              });
            });
          }
           //判断是否签名完毕

          if (_this.detailList[0].signature === "1") {
            for (var i = 0; i <= _this.showIndex; i++) {
              if (_this.detailList[i].signPic === "") {
                Dialog({message:"请签名完成后提交"});
                _this.showIndex = i;
                return;
              }
              signData.push(_this.detailList[i].signPic);
            }
          }
          // console.log("=======:" + _this.id);
          // console.log("=======:" + JSON.stringify(formData));
          // console.log("=======:" + JSON.stringify(signData));
          // return;

          let investigation = detail.formInfo(_this.id, formData, signData);
          this.$router.go(-1);

          
        })
        .catch(() => {});
    },

  },
  mounted() {
    this.id = this.$route.params.id;
    this.getInvestigationDetail();
  },
  


};
</script>
<style scoped>
  .indexspan{
    display: inline-block;
    width: 5.32vw;
    height: 5.32vw;
    background-color: #000000;
    color: #fff;
    line-height: 5.32vw;
    text-align: center;
    font-size: 3.733vw;
    border-radius: 50%;
    margin-right: 2.66vw;
  }
  .select_span{
    display:inline-block;
    border: 0.266vw solid #eeee;
    border-radius: 1.5vw;
    color:#444;
    width:28vw;
  }
  .select_spaned{
    display:inline-block;
    border-radius: 1.5vw;
    color:#fff;
    background: #1989fa;

  }
  #canvas {
  border: 1px solid #eee;
  border-radius: 10px;
  box-shadow: 2px 2px 5px #969696;
  margin-top: 20px;
  margin-bottom: 20px;
  margin-left: 20px;
  margin-right: 20px;
  width: 90%;
}
.canvasimg{
 border: 1px solid #eee;
  border-radius: 10px;
  box-shadow: 2px 2px 5px #969696;
  margin-top: 20px;
  margin-bottom: 20px;
  width: 80vw;
  height: 80vw;
}
.placeimage{
  width:31.92vw;
  height: 31.92vw;
  line-height: 31.92vw;
  border:0.266vw solid #eee;
  text-align: center;
  margin: 0 auto;
  font-size: 13.3vw;
  color: #ddd;

}

</style>


