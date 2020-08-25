<template>
  <div>
    <div>
      <!-- <van-tabs v-model="active" swipeable sticky class="opinion opiniontabs"> -->
      <van-tabs v-model="active" swipeable sticky color='#4374f2' >
        <div class="opiniontop" >
          <div class="pt-10 bgcw2 " v-show="active != 0">
          <van-row>
            <van-col :span="20">
              <van-search v-model="keyword" :clearable="false" placeholder="请输入搜索关键词" />
            </van-col>
              <van-col :span="4" class="v_middle pt-10">
                <van-button type="default" size="small" class="v_middle" @click="sureSearch">搜索</van-button>
              </van-col>
          </van-row>
        </div>
          <div v-if="active != 0">
            <van-row> 
             <van-col span="24">
                <van-dropdown-menu>
                  <!-- <van-dropdown-item title="搜索" disabled /> -->
                  <van-dropdown-item v-model="sortValue" :options="option" @change="sort"/>
                  <van-dropdown-item title="筛选" ref="item">
                    <div class="pd-10 f-14">
                      <p>所属社区:</p>
                      <div>
                        <span class="screenItem pl-5 pr-5 pt-5 pb-5 f-10" v-for="(item,index) in unityList" :class="{ 'active_1': isactive_1 === index}" @click="sereenSelect_1(index,item.org_code)">{{item.departname}}</span>
                      </div>
                    </div>
                    <div class="pd-10 f-14">
                      <p>民意来源:</p>
                      <div>
                        <span class="screenItem pl-10 pr-10 pt-5 pb-5 f-10" v-for="(item,index) in willfromList" :class="{ 'active_2': isactive_2 === index}"   @click="sereenSelect_2(index,item.typecode)">{{item.typename}}</span>
                      </div>
                    </div>
                    <div class="pd-10 f-14">
                      <p>民意分类:</p>
                      <div>
                        <span class="screenItem pl-10 pr-10 pt-5 pb-5 f-10" v-for="(item,index) in willTypeList" :class="{ 'active_3': isactive_3 === index}"  @click="sereenSelect_3(index,item.code)">{{item.name}}</span>
                      </div>
                    </div>
                    <van-row>
                      <van-col span="12">
                          <van-button block @click="reset">重置</van-button>
                      </van-col>
                      <van-col span="12">
                          <van-button block type="info" @click="onConfirm">确认</van-button>
                      </van-col>
                    </van-row>
                  </van-dropdown-item>
                </van-dropdown-menu>
             </van-col>
            </van-row>
          </div>
        </div>
        <van-tab title="我的民意">
          <div class=" text-c pt-10 pb-10" style="position:relative;z-index:2">
            <van-button @click="torecord" type="info">录入民意</van-button>
          </div>
          <van-pull-refresh v-model="willRecordList.isLoading" @refresh="ondataRefresh">
            <van-list
               v-model="willRecordList.loading"
              :finished="willRecordList.finished"
              finished-text="没有更多了"
              @load="getWillCategrolyList"
            >
              <van-image-preview 
                  v-model="showmy"
                  :startPosition="startIdxmy"
                  :images="perimageArrmy"
                  :showIndex="false"
                ></van-image-preview>
              <!-- 加载的内容-->
              <div v-for="(item,index) in willRecordList.rows" :key="index">
                <div class="pl-10 pt-10 pr-10">
                  {{item.username}}
                  <div class="right">
                    <div class="c-333 f-16 right mr-10 pr-10 f-blue" @click="delMyopinion(item.id,index)">
                      <van-icon name="delete" color="#f44" custom-style="font-size:16px;" />
                    </div>
                    <div class="c-333 f-16 right mr-10 pr-10 f-blue" @click="toEdit(item.id)">
                      <van-icon name="edit" custom-style="font-size:16px;" />
                    </div>
                  </div>
                  <span
                    class="c-666 mr-10 f-14"
                    @click="makeCall(item.mobile)"
                  >{{item.mobile}}</span>
                  <div class="mt-10">
                    <van-tag plain class="pl-5 pr-5 f-12" v-if="item.name">{{item.name}}</van-tag>
                  </div>
                  
                </div>
                <div class="pl-10 mt-10 mb-5 pr-10 f-14">{{item.address}}</div>
                <div class="pd-10">
                  <div class="pt-5 f-14 litter">{{item.content}}</div>
                </div>
                <div class="pd-10">
                  <ul class="flex_box">
                    <li v-for="(imgItem,ppp) in item.imageArr" :key="ppp" class="imgarr_content">
                      <van-image
                        width="30.5vw"
                        height="24vw"
                        fit="cover"
                        :src="imgItem"
                        @click="previewImgmy(item.sourceImageArr[ppp],ppp)"
                      />
                    </li>
                  </ul>
                </div>
                <div class="pl-10 pb-10 c-666 f-14">{{item.title}} {{item.create_date}}</div>
                <div class="bgcy"></div>
              </div>
            </van-list>
          </van-pull-refresh>
        </van-tab>
        <van-tab title="未处理" style="margin-top:90px">
          <div class="pt-15 text-c c-666 f-13" v-if="active == 1">共有{{totalRow_1}}条民意</div>
          <div class="bgcy"></div>
          <van-pull-refresh v-model="willRecordListwei.isLoading" @refresh="ondataAllRefreshwei">
            <van-list
              v-model="willRecordListwei.loading"
              :finished="willRecordListwei.finished"
              finished-text="没有更多了"
              @load="getListAllwei"
            >
              <van-image-preview
                  v-model="showwei"
                  :startPosition="startIdxwei"
                  :images="perimageArrwei"
                  :showIndex="false"
              ></van-image-preview>
               <van-dialog
                    v-model="huifu"
                    title="回复"
                    show-cancel-button
                    @confirm="confirm_huifu(my_id)"
                    @cancel="dowm()"
                >
                  <div class="margin:10px">
                    <p><pre class="mg-5 pd-5">电话回复:</pre> <span class="ml-5 pd-5 f-13"> {{my_name}}</span> <span class="mg-5 pd-5 f-14 f-blue v_middle"  @click="copyUrl2"><input class="my_input2" readonly type="text" id="copyvalue" :value="my_mobile"></span> </p>
                  </div>
                  <br>
                  <div style="margin:10px">
                      <van-cell-group>
                          <van-field v-model="huifuvalue" type="textarea" rows="4" autosize placeholder="请输入回复内容" class="my_input" />
                      </van-cell-group>
                  </div>
                    <div class="margin:10px">
                    <p><pre class="mg-5 pd-5">快捷回复:</pre>  <span class="feedback pd-5 mg-5 f-12" v-for="(items,indexs) in fastBack" @click="fastContent(items)">{{items}}</span></p>
                    </div>
                </van-dialog>
              <div v-for="(item,index) in willRecordListwei.rows" :key="index">
                <div class="pl-10 pt-10 pr-10">
                  <div @click="show_iconBottom(item.id,item.mobile,item.username,item.blowState)" class="right">
                    <span class="c-666 f-14 mr-10" v-if="item.blowState != 2">处理中</span>
                    <van-icon name="arrow"  color="#666666" class="v_middle"/>
                 </div>
                  {{item.username}}
                  <span
                    class="c-666 mr-10 f-14"
                    @click="makeCall(item.mobile)"
                  >{{item.mobile}}</span>
                 <div class="mt-5">
                    <span class="f-12 mr-10 c-666">{{item.departName}}</span>
                    <van-tag plain class="pl-5 pr-5 f-12 mr-5" v-if="item.source">{{item.source}}</van-tag>
                    <van-tag plain class="pl-5 pr-5 f-12" v-if="item.name">{{item.name}}</van-tag>
                 </div>
               
                </div>
                <div class="pl-10 mt-10 mb-5 pr-10 f-14">{{item.address}}</div>

                <div class="pd-10">
                  <div class="pt-5 f-14 litter">{{item.content}}</div>
                </div>
                <div class="pd-10">
                  <ul class="flex_box">
                    <li v-for="(imgItem,ppp) in item.imageArr" :key="ppp" class="imgarr_content">
                      <van-image
                        width="30.5vw"
                        height="24vw"
                        fit="cover"
                        :src="imgItem"
                        @click="previewImgwei(item.sourceImageArr[ppp],ppp)"
                      />
                    </li>
                  </ul>
                </div>
                <div class="pl-10 pb-10 c-666 f-14">{{item.title}} {{item.create_date}}</div>
                
                <van-action-sheet v-model="show_bottom" :actions="actions" @select="onSelect" />
                <div class="bgcy"></div>
              </div>
            </van-list>
          </van-pull-refresh>

        </van-tab>
         <van-tab title="已处理" style="margin-top:90px">
            <div class="pt-15 text-c c-666 f-13" v-if="active == 2">共有{{totalRow_2}}条民意</div>
            <div class="bgcy"></div>
          <van-pull-refresh v-model="willRecordListyi.isLoading" @refresh="ondataAllRefreshyi">
            <van-list
              v-model="willRecordListyi.loading"
              :finished="willRecordListyi.finished"
              finished-text="没有更多了"
              @load="getListAllyi"
            >
              <van-image-preview
                  v-model="showyi"
                  :startPosition="startIdxyi"
                  :images="perimageArryi"
                  :showIndex="false"
              ></van-image-preview>
              <div v-for="(item,index) in willRecordListyi.rows" :key="index">
                <div class="pl-10 pt-10 pr-10">
                  {{item.username}}
                  <span
                    class="c-666 mr-10 f-14"
                    @click="makeCall(item.mobile)"
                  >{{item.mobile}}</span>
                  <div class="mt-5">
                    <span class="f-12 mr-10 c-666">{{item.departName}}</span>
                    <van-tag plain class="pl-5 pr-5 f-12 mr-5" v-if="item.source">{{item.source}}</van-tag>
                    <van-tag plain class="pl-5 pr-5 f-12" v-if="item.name">{{item.name}}</van-tag>
                 </div>
                </div>
                <div class="pl-10 mt-10 mb-5 pr-10 f-14">{{item.address}}</div>

                <div class="pd-10">
                  <div class="pt-5 f-14 litter">{{item.content}}</div>
                </div>
                <div class="pd-10">
                  <ul class="flex_box">
                    
                    <li v-for="(imgItem,ppp) in item.imageArr" :key="ppp" class="imgarr_content">
                      <van-image
                        width="30.5vw"
                        height="24vw"
                        fit="cover"
                        :src="imgItem"
                        @click="previewImgyi(item.sourceImageArr[ppp],ppp)"
                      />
                      
                     
                    </li>
                  </ul>
                </div>
                <div class="pl-10 pb-10 c-666 f-14">{{item.title}} {{item.create_date}}</div>
                <div class="pd-5">
                    <van-collapse v-model="huifuactive">
                      <van-collapse-item title="查看回复" :name=index>
                          <p v-html='item.feed_back'></p>
                      </van-collapse-item>
                    </van-collapse>
                </div>
                <div class="bgcy"></div>
                  
              </div>
            </van-list>
          </van-pull-refresh>


        </van-tab>
        <van-tab title="暂存" style="margin-top:90px">
          <div class="pt-15 text-c c-666 f-13" v-if="active == 3">共有{{totalRow_3}}条民意</div>
           <div class="bgcy"></div>
            <van-pull-refresh v-model="willRecordListAllcun.isLoading" @refresh="ondataAllRefreshcun">
            <van-list
              v-model="willRecordListAllcun.loading"
              :finished="willRecordListAllcun.finished"
              finished-text="没有更多了"
              @load="getListAllcun"
            >
              <van-image-preview
                  v-model="show"
                  :startPosition="startIdx"
                  :images="perimageArr"
                  :showIndex="false"
              ></van-image-preview>
              <div v-for="(item,index) in willRecordListAllcun.rows" :key="index">
                <div class="pl-10 pt-10 pr-10">
                  {{item.username}}
                  <span
                    class="c-666 mr-10 f-14"
                    @click="makeCall(item.mobile)"
                  >{{item.mobile}}</span>
                  <div class="mt-5">
                    <span class="f-12 mr-10 c-666">{{item.departName}}</span>
                    <van-tag plain class="pl-5 pr-5 f-12 mr-5" v-if="item.source">{{item.source}}</van-tag>
                    <van-tag plain class="pl-5 pr-5 f-12" v-if="item.name">{{item.name}}</van-tag>
                  </div>
                </div>
                <div class="pl-10 mt-10 mb-5 pr-10 f-14">{{item.address}}</div>

                <div class="pd-10">
                  <div class="pt-5 f-14 litter">{{item.content}}</div>
                </div>
                <div class="pd-10">
                  <ul class="flex_box">
                    
                    <li v-for="(imgItem,ppp) in item.imageArr" :key="ppp" class="imgarr_content">
                      <van-image
                        width="30.5vw"
                        height="24vw"
                        fit="cover"
                        :src="imgItem"
                        @click="previewImg(item.sourceImageArr[ppp],ppp)"
                      />
                    </li>
                  </ul>
                </div>
                <div class="pl-10 pb-10 c-666 f-14">{{item.title}} {{item.create_date}}</div>
                <div class="pd-5 f-14 mg-5" @click="unzancun_opinion(item.id)" style="background:#909399;color:#fff;border-radius:5px;width:24vw;text-align:center">
                  <span class="c-fff">取消暂存</span>
                </div>
                <div class="bgcy"></div>
              </div>
            </van-list>
          </van-pull-refresh>

        </van-tab>
         <van-tab title="无效" style="margin-top:90px">
          <div class="pt-15 text-c c-666 f-13" v-if="active == 4">共有{{totalRow_4}}条民意</div>
            <div class="bgcy"></div>
          <van-pull-refresh v-model="willRecordListAllfei.isLoading" @refresh="ondataAllRefreshfei">
            <van-list
              v-model="willRecordListAllfei.loading"
              :finished="willRecordListAllfei.finished"
              finished-text="没有更多了"
              @load="getListAllfei"
            >
              <van-image-preview
                  v-model="show"
                  :startPosition="startIdx"
                  :images="perimageArr"
                  :showIndex="false"
              ></van-image-preview>
              <div v-for="(item,index) in willRecordListAllfei.rows" :key="index">
                <div class="pl-10 pt-10 pr-10">
                  {{item.username}}
                  <span
                    class="c-666 mr-10 f-14"
                    @click="makeCall(item.mobile)"
                  >{{item.mobile}}</span>
                   <div class="mt-5">
                    <span class="f-12 mr-10 c-666">{{item.departName}}</span>
                    <van-tag plain class="pl-5 pr-5 f-12 mr-5" v-if="item.source">{{item.source}}</van-tag>
                    <van-tag plain class="pl-5 pr-5 f-12" v-if="item.name">{{item.name}}</van-tag>
                 </div>
                </div>
                <div class="pl-10 mt-10 mb-5 pr-10 f-14">{{item.address}}</div>

                <div class="pd-10">
                  <div class="pt-5 f-14 litter">{{item.content}}</div>
                </div>
                <div class="pd-10">
                  <ul class="flex_box">
                    
                    <li v-for="(imgItem,ppp) in item.imageArr" :key="ppp" class="imgarr_content">
                      <van-image
                        width="30.5vw"
                        height="24vw"
                        fit="cover"
                        :src="imgItem"
                        @click="previewImg(item.sourceImageArr[ppp],ppp)"
                      />
                    </li>
                  </ul>
                </div>
                <div class="pl-10 pb-10 c-666 f-14">{{item.title}} {{item.create_date}}</div>
                <div class="pd-5 f-14 mg-5" @click="huifu2_opinion(item.id)" style="background:#909399;color:#fff;border-radius:5px;width:12vw;text-align:center">
                  <span class="c-fff">恢复</span>
                </div>
                <div class="bgcy"></div>
              </div>
            </van-list>
          </van-pull-refresh>


        </van-tab>
      </van-tabs>
    </div>
  </div>
</template>
<script>
import CategrolyList from "@/api/PublicOpinion/PublicOpinion";
import opinion from "@/api/PublicOpinion/PublicOpinion";
import del from "@/api/PublicOpinion/PublicOpinion";
import work from "@/api/work/workhistory";
import { Dialog } from "vant";
import { setTimeout } from 'timers';
import { Toast } from 'vant'

export default {
  data() {
    return {
      fastBack:['已拨打电话反馈','已处理完成'],
      huifuactive:['0'],
      huifu:false,
      huifuvalue:'',
      active: 0,
      category: [],
      categotyList: [],
      images: [],
      imagesPos: 10,
      willRecordList: {
        pageNo: 1,
        rows: [],
        isLoading: false,
        loading: false,
        finished: false
      },
      willRecordListwei: {
        pageNo: 1,
        rows: [],
        isLoading: false,
        loading: false,
        finished: false
      },
      willRecordListAllfei: {
        pageNo: 1,
        rows: [],
        isLoading: false,
        loading: false,
        finished: false
      },
      willRecordListAllcun: {
        pageNo: 1,
        rows: [],
        isLoading: false,
        loading: false,
        finished: false
      },
       willRecordListyi: {
        pageNo: 1,
        rows: [],
        isLoading: false,
        loading: false,
        finished: false
      },
      perimageArr: [],
      perimageArrmy: [],
      perimageArryi:[],
      perimageArrwei:[],
       
      keyword:'',

      showmy: false,
      startIdxmy: 0,
      
      show: false,
      startIdx: 0,

      showwei:false,
      startIdxwei:0,

      showyi:false,
      startIdxyi:0,

      my_mobile:'',
      my_id:'',
      my_name:'',

      totalRow_1:0,
      totalRow_2:0,
      totalRow_3:0,
      totalRow_4:0,

      unityList:[],
      willfromList:[],
      willTypeList:[],
      sortValue: 0,
      option: [
        { text: '时间排序', value: 0 },
        { text: '社区排序', value: 1 }
      ],
      isactive_1:-1,
      isactive_2:-1,
      isactive_3:-1,
      screen:{
        willType:"",
        willfrom:"",
        orgCode:""
      },
      show_bottom:false,
      id_bottom:'',
      mobile_bottom:'',
      username_bottom:'',
      blowState_bottom:'',
      actions: [
        { name: '吹哨' },
        { name: '设置该民意无效' },
        { name: '暂存该民意' },
        { name: '直接回复处理结果' }
      ]
      

    };
  },
  methods: {
    show_iconBottom(id,mobile,username,blowState){
      this.show_bottom = true;
      this.id_bottom = id;
      this.mobile_bottom = mobile;
      this.username_bottom = username;
      this.blowState_bottom = blowState;
    },
     onSelect(item) {
      if(item.name == '吹哨' && this.blowState_bottom == 2){
        window.location.href = 'http://willRecord/blow?arg1='+ this.id_bottom;
      }else if(item.name == '吹哨' && this.blowState_bottom != 2){
          Toast('正在处理中');
      }else if(item.name == '设置该民意无效'){
        this.zuofeiOnes(this.id_bottom)
      }else if(item.name == '暂存该民意'){
          this.zancunOnes(this.id_bottom)
      }else if(item.name == '直接回复处理结果'){
          this.callbackOnes(this.id_bottom,this.mobile_bottom,this.username_bottom)
      }
      this.show_bottom = false;
    },
    sereenSelect_1(index,code){
      this.isactive_1 = index ;
      this.screen.orgCode =code;
    },
    sereenSelect_2(index,code){
      this.isactive_2 = index;
      this.screen.willfrom = code;
    },
    sereenSelect_3(index,code){
      this.isactive_3 = index;
      this.screen.willType = code;
    },
    sort(){
      console.log(this.sortValue);
      this.isTabActive()
    },
    reset(){
      this.isactive_1 = -1;
      this.isactive_2 = -1;
      this.isactive_3 = -1;
      this.screen.willType = "";
      this.screen.willfrom = "";
      this.screen.orgCode = "";
      this.$refs.item.toggle();
      this.isTabActive()
    },
     onConfirm() {
      this.$refs.item.toggle();
      // console.log(this.screen);
      console.log(this.active);
      this.isTabActive()

    },
    isTabActive(){
      if(this.active == 1){
        //未处理
        this.willRecordListwei.rows = [];
        this.willRecordListwei.pageNo = 1;
        this.getListAllwei();
      }else if(this.active == 2){
        //已处理
        this.willRecordListyi.rows = [];
        this.willRecordListyi.pageNo = 1;
        this.getListAllyi()
      }else if(this.active == 3){
        //暂存
        this.willRecordListAllcun.rows = [];
        this.willRecordListAllcun.pageNo = 1;
        this.getListAllcun()
      }else if(this.active == 4){
        //已无效
        this.willRecordListAllfei.rows=[];
        this.willRecordListAllfei.pageNo = 1;
          this.getListAllfei();
      }else{

      }
    },
    sureSearch(){
      this.isTabActive()
    },          
     copyUrl2(){
      var Url2=document.getElementById("copyvalue");
      Url2.select(); // 选择对象
      document.execCommand("Copy"); // 执行浏览器复制命令
      // alert("已复制好，可贴粘。");
       Toast('已复制好，可贴粘。')
    },
    fastContent(inner){
        console.log(inner);
        this.huifuvalue = inner;
    },
    //回复民意
    callbackOnes(id,mobile,name){
      this.huifu = true;
      this.my_mobile = mobile;
      this.my_id = id;
      this.my_name = name;

    },
    confirm_huifu(id){
     this.huifuvalue? this.huifuopinion(id,this.huifuvalue) : Toast('回复内容不能为空');
     this.huifuvalue = '';
     this.inityi();
     this.ondataAllRefreshwei();
    },
    dowm(){
       this.huifuvalue = '';
    },
    //回复民意接口
    async huifuopinion(id,value){
      let res = await opinion.callbackopinion(id,value);
       this.ondataAllRefreshwei();
      this.inityi();
    },
     zuofeiOnes(id){
      Dialog.confirm({
          title: '标题',
          message: '确认作废这条民意吗？'
        }).then(() => {
          // on confirm
          this.to_zuofeiOnes(id);
        }).catch(() => {
          // on cancel
        });
    },
    zancunOnes(id){
       Dialog.confirm({
          title: '标题',
          message: '确认暂存这条民意吗？'
        }).then(() => {
          // on confirm
          this.to_zancunOnes(id);
        }).catch(() => {
          // on cancel
        });
    },
    async to_zancunOnes(id){
        let res = await opinion.storageopinion(id)
      this.initcun();
       this.ondataAllRefreshwei();
    },
    async to_zuofeiOnes(id){
       let res = await opinion.deleopinion(id)
      this.initAllfei();
       this.ondataAllRefreshwei();
    },
    unzancun_opinion(id){
       Dialog.confirm({
          title: '标题',
          message: '确认取消暂存这条民意吗？'
        }).then(() => {
          // on confirm
          this.unzancun_opinion2(id);
        }).catch(() => {
          // on cancel
        });
    },
    async unzancun_opinion2(id){ 
       let res = await opinion.unstorageopinion(id);
       this.initcun();
       this.ondataAllRefreshwei();
    },
    huifu2_opinion(id){
      Dialog.confirm({
          title: '标题',
          message: '确认恢复这条民意吗？'
        }).then(() => {
          // on confirm
          this.to_huifu2_opinion(id);
        }).catch(() => {
          // on cancel
        });
        
    },
    async to_huifu2_opinion(id){
      let res = await opinion.recoverOpinion(id);
       this.initAllfei();
       this.ondataAllRefreshwei();
    },
    //去编辑
    toEdit(id){
        this.$router.push({
        path: `/detailopinion`,
        query:{
            id:id
        }
      });
    },
    //录入民意
    torecord(){
      this.$router.push({
        path: `/detailopinion`
      });
    },
    //图片预览
    previewImgmy(img, index) {
      this.perimageArrmy = [];
      this.startIdxmy = index;
      this.showmy = true;
      this.perimageArrmy.push(img);
    },
     previewImg(img, index) {
      this.perimageArr = [];
      this.startIdx = index;
      this.show = true;
      this.perimageArr.push(img);
    },
    previewImgwei(img, index) {
      this.perimageArrwei = [];
      this.startIdxwei = index;
      this.showwei = true;
      this.perimageArrwei.push(img);
    },
     previewImgyi(img, index) {
      this.perimageArryi = [];
      this.startIdxyi = index;
      this.showyi = true;
      this.perimageArryi.push(img);
    },
    //选择图片
    // *************************************我的民意start******************************************
    async init() {
      
      let res = await opinion.HistoryRecordList(
        this.willRecordList.pageNo
      );
      this.willRecordList.rows = [];
      res = JSON.parse(res);
      this.handleData(res,0);

      this.willRecordList.totalPage = res.totalPage;
      this.willRecordList.isLoading = false;
      this.willRecordList.finished = false;
      if (res.totalPage <= res.currentPage) {
          this.willRecordList.finished = true;
      } else {
        this.willRecordList.pageNo++;
      }
    },
    //下拉刷新
    ondataRefresh() {
      this.willRecordList.totalPage = 0;
      this.willRecordList.pageNo = 1;
      this.init(); //加载数据
    },
    async getWillCategrolyList() {
      let res = await opinion.HistoryRecordList(
        this.willRecordList.pageNo
      );
      res = JSON.parse(res);
      this.handleData(res, 0);

      this.willRecordList.totalPage = res.totalPage;
      this.willRecordList.isLoading = false;
      this.willRecordList.loading = false;

      if (res.totalPage <= res.currentPage) {
        this.willRecordList.finished = true;
      } else {
        this.willRecordList.pageNo ++;
      }
    },
    // *************************************我的民意end******************************************
    // *************************************已无效民意start**************************************
    async initAllfei() {
      let param={
        type:3,
        pageNo:this.willRecordListAllfei.pageNo,
        search:this.keyword
      }
      let res = await opinion.HistoryRecordListAll(param);
      this.willRecordListAllfei.rows = [];
      res = JSON.parse(res);
      this.handleData(res,2);
      this.totalRow_4 = res.totalRow;
      this.willRecordListAllfei.totalPage = res.totalPage;
      this.willRecordListAllfei.isLoading = false;
      this.willRecordListAllfei.finished = false;
      if (res.totalPage <= res.currentPage) {
        this.willRecordListAllfei.finished = true;
      } else {
        this.willRecordListAllfei.pageNo++;
      }
    },
    //下拉刷新
    ondataAllRefreshfei() {
      this.willRecordListAllfei.totalPage = 0;
      this.willRecordListAllfei.pageNo = 1;
      this.initAllfei(); //加载数据
    },
    async getListAllfei() {
       let param={
        type:3,
        pageNo:this.willRecordListAllfei.pageNo,
        search:this.keyword
      }
      let res = await opinion.HistoryRecordListAll(param);
      res = JSON.parse(res);
      this.handleData(res,2);
      this.totalRow_4 = res.totalRow;
      this.willRecordListAllfei.totalPage = res.totalPage;
      this.willRecordListAllfei.isLoading = false;
      this.willRecordListAllfei.loading = false;

      if (res.totalPage <= res.currentPage) {
        this.willRecordListAllfei.finished = true;
      } else {
        this.willRecordListAllfei.pageNo ++;
      }
    },
    // *************************************已无效民意end******************************************
     async initwei() {
       let param = {
         type:1,
         pageNo:this.willRecordListwei.pageNo,
         sort:this.sortValue,
         search:this.keyword
       }
         param = Object.assign(param,this.screen)
      let res = await opinion.HistoryRecordListAll(param);
      this.willRecordListwei.rows = [];
      res = JSON.parse(res);
      this.handleData(res,1);
      this.totalRow_1 = res.totalRow;
      this.willRecordListwei.totalPage = res.totalPage;
      this.willRecordListwei.isLoading = false;
      this.willRecordListwei.finished = false;
      if (res.totalPage <= res.currentPage) {
        this.willRecordListwei.finished = true;
      } else {
        this.willRecordListwei.pageNo++;
      }
    },
    //下拉刷新
    ondataAllRefreshwei() {
      this.willRecordListwei.totalPage = 0;
      this.willRecordListwei.pageNo = 1;
      this.initwei(); //加载数据
    },
    async getListAllwei() {
      let param = {
         type:1,
         pageNo:this.willRecordListwei.pageNo,
         sort:this.sortValue,
         search:this.keyword
       }
       param = Object.assign(param,this.screen)
      let res = await opinion.HistoryRecordListAll(param);
      res = JSON.parse(res);
      this.handleData(res,1);
      this.totalRow_1 = res.totalRow;
      this.willRecordListwei.totalPage = res.totalPage;
      this.willRecordListwei.isLoading = false;
      this.willRecordListwei.loading = false;

      if (res.totalPage <= res.currentPage) {
        this.willRecordListwei.finished = true;
      } else {
        this.willRecordListwei.pageNo ++;
      }
    },
    // *************************************未处理民意end******************************************
    // *************************************暂存民意start******************************************
     async initcun() {
       let param = {
         type:4,
         pageNo:this.willRecordListAllcun.pageNo,
         sort:this.sortValue,
         search:this.keyword
       }
         param = Object.assign(param,this.screen)
      let res = await opinion.HistoryRecordListAll(param);
      this.willRecordListAllcun.rows = [];
      res = JSON.parse(res);
      this.handleData(res,4);
      this.totalRow_3 = res.totalRow;
      this.willRecordListAllcun.totalPage = res.totalPage;
      this.willRecordListAllcun.isLoading = false;
      this.willRecordListAllcun.finished = false;
      if (res.totalPage <= res.currentPage) {
        this.willRecordListAllcun.finished = true;
      } else {
        this.willRecordListAllcun.pageNo++;
      }
    },
    //下拉刷新
    ondataAllRefreshcun() {
      this.willRecordListAllcun.totalPage = 0;
      this.willRecordListAllcun.pageNo = 1;
      this.initcun(); //加载数据
    },
    async getListAllcun() {
       let param = {
         type:4,
         pageNo:this.willRecordListAllcun.pageNo,
         sort:this.sortValue,
         search:this.keyword
       }
         param = Object.assign(param,this.screen)
      let res = await opinion.HistoryRecordListAll(param);
      res = JSON.parse(res);
      this.handleData(res,4);
      this.totalRow_3 = res.totalRow;
      this.willRecordListAllcun.totalPage = res.totalPage;
      this.willRecordListAllcun.isLoading = false;
      this.willRecordListAllcun.loading = false;

      if (res.totalPage <= res.currentPage) {
        this.willRecordListAllcun.finished = true;
      } else {
        this.willRecordListAllcun.pageNo ++;
      }
    },
    // *************************************暂存民意end********************************************
    async inityi() {
      let param = {
        type:2,
        pageNo:this.willRecordListyi.pageNo,
        sort:this.sortValue,
        search:this.keyword
      }
        param = Object.assign(param,this.screen)
      let res = await opinion.HistoryRecordListAll(param);
      this.willRecordListyi.rows = [];
      res = JSON.parse(res);
      this.handleData(res,3);
      this.totalRow_2 = res.totalRow;
      this.willRecordListyi.totalPage = res.totalPage;
      this.willRecordListyi.isLoading = false;
      this.willRecordListyi.finished = false;
      if (res.totalPage <= res.currentPage) {
        this.willRecordListyi.finished = true;
      } else {
        this.willRecordListyi.pageNo++;
      }
    },
    //下拉刷新
    ondataAllRefreshyi() {
      this.willRecordListyi.totalPage = 0;
      this.willRecordListyi.pageNo = 1;
      this.inityi(); //加载数据
    },
    async getListAllyi() {
        let param = {
        type:2,
        pageNo:this.willRecordListyi.pageNo,
        sort:this.sortValue,
        search:this.keyword
      }
        param = Object.assign(param,this.screen)
      let res = await opinion.HistoryRecordListAll(param);
      res = JSON.parse(res);
      this.handleData(res,3);
      this.totalRow_2 = res.totalRow;
      this.willRecordListyi.totalPage = res.totalPage;
      this.willRecordListyi.isLoading = false;
      this.willRecordListyi.loading = false;

      if (res.totalPage <= res.currentPage) {
        this.willRecordListyi.finished = true;
      } else {
        this.willRecordListyi.pageNo ++;
      }
    },

    // *************************************已处理民意end******************************************
    handleData(res, idx) {
      let redata = res.list;
      let _this = this;
      redata.forEach(function(item, index) {
        item.create_date = item.create_date.substring(0, 10);
        item.imageArr = [];
        item.sourceImageArr = [];
        if (item.image) {
          item.image = JSON.parse(item.image);
          item.image.forEach(function(img, p) {
            item.sourceImageArr.push(_this.common.showPicture(img,'',false));
            item.imageArr.push(_this.common.showPicture(img));
          });
        }
        if (idx == 0) {
          _this.willRecordList.rows.push(item);
        }
        if (idx == 1) {
          _this.willRecordListwei.rows.push(item);
        }
         if (idx == 2) {
          _this.willRecordListAllfei.rows.push(item);
        }
         if (idx == 3) {
          _this.willRecordListyi.rows.push(item);
        }
         if (idx == 4) {
          _this.willRecordListAllcun.rows.push(item);
        }
      });
    },
    //删除我的民意
    delMyopinion(id,index){
        let _this = this;
      Dialog.confirm({
        message: "确认删除这条记录吗？"
      })
        .then(() => {
          _this.sureDel(id, index);
        })
        .catch(() => {});
    },
     async sureDel(id,index) {
      let res = await del.delopinion(id);
      // Dialog({ message: "删除成功" });
      this.willRecordList.rows.splice(index, 1);
    },
    //获取全部社区数据
     async getAllUnityList(){
       let res = await opinion.getAllcummunity();
       this.unityList = res = JSON.parse(res);
       console.log(this.unityList.length)
     },
       //获取字典表的内容
    async getDictionary(name) {
      var _this = this;
      let res = await work.getDictionary(name);
      res = JSON.parse(res);
      if(res.willfrom)
      this.willfromList = res.willfrom;
    },
    //获取民意分类
    async getWillType(){
      let res = await opinion.getWillCategoryList();
      res = JSON.parse(res);
       this.willTypeList = res;
    }


  },
  mounted() {
    this.getAllUnityList();
    this.getDictionary("willfrom");
    this.getWillType();
    this.active = this.$route.query.type;
  },
  created() {
    
  }
};
</script>
<style scoped>
.bage {
  border-radius: 15px;
  border: solid 1px #eee;
  padding: 0.8vw;
  /* margin-bottom: 1.33vw; */
  text-align: center;
  font-size: 3.4666vw;
}
.list_bage{
  border-radius: 1.8vw;
  text-align: center;
  background: #3396fb;
}
.list_bage2{
background: #ff976a;
}
.bageClick {
  background: #3396fb;
  color: #fff;
  text-align: center;
}
.sort_view {
  text-indent: 0.5em;
  font-family: "黑体";
}
.van-tab .van-ellipsis {
  font-size: 4.26vw !important;
}
.flex_box {
  display: flex;
  justify-content: flex-start;
  align-items: center;
  flex-wrap:wrap;
}
.imgarr_content {
  margin-right: 0.53vw;
  margin-left: 0.53vw;
  margin-top: 0.53vw;
}
.feedback{
  display: inline-block;
  border: 1px solid #eee;
  border-radius: 0.8vw;
}
.my_input{
  background: #eee;
}
.my_input2{
  border: none;
  outline: none;
  background: #fff
}

.screenItem{
  display: inline-block;
  border:1px solid #ccc;
  margin:1.33vw;
  border-radius: 4px;
}
.active_1,.active_2,.active_3{
  color: #fff;
  background-color:#3396fb;
  border-color:#3396fb;
}
.searchArea{
    background-color: #fff;
      text-align: center;
      height: 12.86vw;
      line-height: 10.3vw;
      margin-top:0.276vw;
    }
    .litter{
      letter-spacing: 0.2vw;
      line-height: 1.2!important;
    }
</style>

