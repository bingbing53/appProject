<template>
  <div>
    <div>
      <div class="pd-10 bgcw2">
        <div class="Bline pb-10">
          <p class="Wline Bline pb-10 pt-10 f-b sort_view">
            <span class="blueLeftline">I</span>&nbsp;
            <span>第一步：选择工作种类</span>
          </p>
          <div style="clear: both"></div>
        </div>
        <div class="line"></div>
        <div class="pd-10">
          <van-row gutter="4">
            <van-col
              v-for="(item,index) in dictionary.workHisType"
              :key="index"
              span="6"
              class="text-c c-666 f-16"
            >
              <div
                :class="[bage.pos === index ? 'bageClick bage' : 'bage', '']"
                @click="clickBage(index,item)"
              >{{item.typename}}</div>
            </van-col>
          </van-row>
        </div>
      </div>

      <div class="bgcy pt-10"></div>
      <div class="pd-10 bgcw2">
        <div class="Bline pb-10">
          <p class="Wline Bline pb-10 pt-10 f-b sort_view">
            <span class="blueLeftline">I</span>&nbsp;
            <span>第二步：录入工作描述</span>
          </p>
          <div style="clear: both"></div>
        </div>
        <div class="line"></div>
        <div class="pd-10">
          <div class="f-14">
            <van-field class="border_none" maxlength="100" placeholder="输入主题内容" v-model="form.topic" style="padding:2.66vw 2vw" />
          </div>
          <div class="mt-10 f-14">
            <van-field
              class="border_textarea f-14"
              placeholder="请输入简要工作描述"
              maxlength="1000"
              v-model="form.content"
            />
          </div>
        </div>
      </div>

      <div class="bgcy pt-10"></div>
      <div class="pd-10 bgcw2">
        <div class="Bline pb-10 mb-10">
          <p class="Wline Bline pb-10 pt-10 f-b sort_view">
            <span class="blueLeftline">I</span>&nbsp;
            <span>第三步：上传现场图片（最多三张）</span>
          </p>
        </div>
        <div>
          <van-uploader v-model="fileList" multiple :max-count=count :after-read="changeImage" @delete="delImage" />          
        </div>
      </div>
      <div class="bgcy pt-10"></div>
      <div class="pd-10 bgcw2">
        <div class="Bline pb-10 mb-10">
          <p class="Wline Bline pb-10 pt-10 f-b sort_view">
            <span class="blueLeftline">I</span>&nbsp;
            <span>第四步：关联民意</span>
          </p>
        </div>
        <div>
            <van-cell v-show="blowitem == false"  @click="opinionShow" title="选择和该记录关联的民意" class="c-bbb" is-link />
            <div v-show="blowitem" @click="opinionShow">
                <van-row class="pt-5 pl-10 pr-10 Bline ml-10 mr-10 mt-10">
                  <van-col span="22">
                    <div class="pt-5 pb-5">
                      <h4 class="f-b c-333">{{blowJson.title}} <span class="f-blue f-13 ">{{blowJson.departname}}</span> </h4>
                    <div class="c-999 pb-5 pt-5 f-14 mt-5 mb-5 textflow"> <span class="c-999">民意内容：</span>  <span>{{blowJson.content}}</span></div>
                    <span class="c-999 f-12">{{blowJson.create_date}}</span>
                    </div>
                  </van-col>
                   <van-col span="2">
                     <div class="mt-10 pt-10 text-r"><van-icon name="arrow" color="#969799" /></div>
                   </van-col>
                </van-row>
            </div>
            <div>
                <div v-show="opinion" class="text-c" style="position:fixed;bottom:0px;left:0px;right:0px;z-index:9999;background:#fff;border-top:1px solid #eee;height:13.3vw;line-height:13.3vw;">
                  <div @click="opinion = false" class="c-999 f-b"> 取 消 </div>
                </div>
              <van-popup v-model="opinion"  position="right" :style="{width:'100%',height:'100%'}">
                <van-list
                  v-model="opinionList.loading"
                  :finished="opinionList.finished"
                  finished-text="没有更多了"
                  @load="getopinionList"
                >
                  <van-row class="pt-5 pl-10 pr-10 Bline ml-10 mr-10" v-for="(item,index) in opinionList.rows" :key="index">
                    <van-col span="22">
                      <div class="pt-5 pb-5">
                        <h4 class="f-b c-333">{{item.title}} <span class="f-blue f-13 ">{{item.departname}}</span> </h4>
                      <div class="c-999 pb-5 pt-5 f-14 mt-5 mb-5"> <span class="c-999">民意内容：</span>  <span>{{item.content}}</span></div>
                      <span class="c-999 f-12">{{item.create_date}}</span>
                      </div>
                    </van-col>
                    <van-col span="2">
                      <div class="line_height pt-10">
                        <van-radio-group v-model="radio">
                          <!-- <van-radio :name="index" @change="checked_opinion(item.missionId)"></van-radio> -->
                          <van-radio :name="index" @click="radio_checked($event,item)"></van-radio>
                        </van-radio-group>
                      </div>
                    </van-col>

                  </van-row>
                </van-list>
            </van-popup>
            </div>
          
        </div>
      </div>

      <div class="text-c pd-10 bgcw2">
        <van-row>
          <van-col :span="24">
            <van-button class="van_button_my" size="large" type="info" @click="saveForm">保存</van-button>
          </van-col>
        </van-row>
      </div>
    </div>
  </div>
</template>
<script>
import eventBus from '@/api/eventBus.js';
import work from "@/api/work/workhistory";
import opinion from "@/api/PublicOpinion/PublicOpinion";
import { Dialog } from "vant"; 
import { Toast } from "vant"; 
import { setTimeout } from "timers";
export default {
  data() {
    return {
      radio:-1,
      resultList: [],
      dictionary: {
        workHisType: []
      },
      form: {
        topic: "",
        content: "",
        image:[]
      },
      bage: { pos: -1, item: {} },
      fileList: [],
      newimageArr: [],
      count:3,
      opinionList: {
        rows: [],
        isLoading: false,
        loading: false,
        finished: false,
        totalPage: 0,
        pageNumber: 1
      },
      opinion:false,
      missionId:"",


      commList:[],

      blowJson:{},
      blowitem:false,
    };
  },
  methods: {
    radio_checked(e,item){
      this.blowitem = true;
      this.blowJson = item;
      this.missionId = item.missionId;
       if(!this.missionId){
        let _this = this;
        Dialog.confirm({
          message: "您未选择民意，是否确定？"
          })
          .then(() => {
          _this.form.missionId = this.missionId;
          _this.opinion = false;
          })
          .catch(() => {});
        
      }else{
        this.form.missionId = this.missionId;
        this.opinion = false;
      }

    },
    //获取字典表工作种类
    async getDictionaryList(name) {
      let res = await work.getDictionary(name);
      res = JSON.parse(res);

      let _this = this;
      //   this.dictionary.workHisType = [];
      res.workHisType.forEach(function(item, index) {
        _this.dictionary.workHisType.push(item);
      });
      this.dictionary.workHisType.forEach(function(item, index) {
        _this.resultList.push({ pageNo: 1, rows: [], hasMore: true });
      });
    },
    //点击工作种类
    clickBage(index, item) {
      this.bage.pos = index;
      this.bage.item = item;
    },
    // 删除图片
    delImage(file){
        let _this = this;
          this.newimageArr.forEach(function(item,index){
            if(item == file.content){
                _this.newimageArr.splice(index,1)
            }
        })
        if(this.form.image){
        if(typeof this.form.image == 'string'){
            this.form.image = JSON.parse(this.form.image)
        }
            this.form.image.forEach(function(item,index){
                item = _this.common.showPicture(item);
                if(item == file.content){
                    _this.form.image.splice(index,1)
                }
            })
        }
        // console.log(this.form.image)
        this.form.image = JSON.stringify(this.form.image)
     

    },
    changeImage() {
      //获取上传的图片数组
      if (this.fileList.length <=  this.count) {
        let _this = this;
        _this.newimageArr = [];
        this.fileList.forEach(function(item, index) {
          // console.log(item);
          if(item.file.size >= 1500000){
              let c = _this.common.reduceImage(item,function(data){
              _this.newimageArr.push(data);
            });
          }else{
             _this.newimageArr.push(item.content);
          }
         
        });
      }else{

      }
    },
    //提交表单前判断是否有上传图片
    async saveForm() {
      this.form.workType = this.bage.item.typecode;

      //验证必填项
      if (this.form.workType == undefined || this.form.workType == "") {
        Dialog({ message: "请选择工作种类" });
        return;
      }
      if (this.form.topic == "") {
        Dialog({ message: "请输入主题内容" });
        return;
      }
      if (this.form.content == "") {
        Dialog({ message: "请输入工作描述" });
        return;
      }
      //没有图片上传 直接提交表单
      if (this.newimageArr.length == 0) {
        this.submitForm();
      } else {
        //先上传图片再提交表单
        //上传图片 数组
        let i= this.newimageArr.length;
            while(i--) {
            　　if (this.newimageArr[i].substring(0, 4)== "http") {
                    this.newimageArr.splice(i, 1);
            　　}
            }
            // return;
        let resimgarr = await opinion.uploadImage(this.newimageArr);
        // console.log("返回的图片:"+JSON.stringify(resimgarr))
          resimgarr = JSON.parse(resimgarr);
          // console.log( typeof this.form.image)
          if(this.form.image  == ""){
              this.form.image = [];
          }
           if(typeof this.form.image  == 'string'){
              this.form.image = JSON.parse(this.form.image);
          }
         
          for (let i in resimgarr) {
            this.form.image.push(resimgarr[i].url);
          }
           this.form.image = JSON.stringify(this.form.image);
           this.submitForm();
      }
    },
    //提交表单
    async submitForm() {
      if( typeof this.form.image == 'object'){
        this.form.image = JSON.stringify(this.form.image)
      }
      // console.log(JSON.stringify(this.form));

      // return;
      let resForm = await work.submitForm(this.form);
      // this.$router.push({
      //   path: `/workhistory`
      // });
         Toast.success({
                    message:"提交成功",
                    position:"bottom",
                    duration:1000
                })
          eventBus.$emit('choiceHospital','success');
        this.$router.back()
    },
    opinionShow(){
      this.opinion = true;
    },
    //查看民意列表
   async getopinionList(){
     let _this = this;
     let res = await work.opinionList(this.opinionList.pageNumber);
     res = JSON.parse(res);
    //  console.log(JSON.stringify(res));
     res.list.forEach(function(item, index) {
        if (_this.commList != null && _this.commList.length > 0) {
          _this.commList.forEach(function(ooo, qqq) {
            if (item.sys_org_code === ooo.org_code) {
              item.departname = ooo.departname;
            }
          });
        }

        _this.opinionList.rows.push(item);
      });
      this.opinionList.totalPage = res.totalPage;
      this.opinionList.loading = false;
      if (res.totalPage <= res.currentPage) {
        this.opinionList.finished = true;
      } else {
        this.opinionList.pageNumber++;
      }
    
    },
    async getCommList() {
      var _this = this;
      let res = await work.getCommList();
      res = JSON.parse(res);
      _this.commList = res;
    },
    async getrelateOpinion(id){
      let res = await work.relateOpinion(id);
      res = JSON.parse(res);
      this.blowitem = true;
      this.blowJson = res;
      
    }
   
    
  },
  mounted() {
    this.getCommList();
  },
  created() {
    this.getDictionaryList("workHisType");
    let _this = this;
    //这里的延时是先让字典表加载完成后 ，再判断编辑选中的是哪一个
    setTimeout(function() {
      if (_this.$route.query.data) {
        if(_this.$route.query.data.mission_id){
          _this.getrelateOpinion(_this.$route.query.data.mission_id);
        }
        let form = _this.$route.query.data;
        // console.log(JSON.stringify(form));
        // _this.count += 3;
        _this.dictionary.workHisType.forEach(function(item, index) {
          if (item.typecode === form.work_type) {
            _this.bage.pos = index;
            _this.bage.item = item;
          }
        });

        if (form.imageArr && form.imageArr.length > 0) {
          form.imageArr.forEach(function(item, index) {
            _this.fileList.push({ content: form.imageArr[index], file: {} });
          });
          _this.count = _this.fileList.length + 3;

        }
        _this.form = form;
      }
    }, 500);
  }
};
</script>
<style scoped>
.bage {
  border-radius: 15px;
  border: solid 1px #eee;
  padding: 3px 14px 3px 14px;
  margin-bottom: 10px;
  text-align: center;
  font-size: 3.4666vw;
  line-height: 1;
}
.bageClick {
  background: #3396fb;
  color: #fff;
  text-align: center;
}
.line_height{
  height: 100%;
  line-height: 1;
}
.textflow{
	white-space: nowrap;
	overflow: hidden; 
	text-overflow:ellipsis;
}
.van-popup{
  padding-bottom:13.33vw;
  padding-top:4.32vw;
}

</style>


