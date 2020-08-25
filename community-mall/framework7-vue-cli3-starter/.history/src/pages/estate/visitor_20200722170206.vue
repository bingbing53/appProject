<template>
  <f7-page bg-color="white" infinite
           :infinite-distance="50"
           :infinite-preloader="showPreloader"
           @infinite="getTempPwdList">
    <van-pull-refresh v-model="isLoading" @refresh="onRefresh">
      <f7-block>
          <div v-for="item in tempPwdList.records" @click="jumpUseDetail(item.id)">
              <div class="f-18 pb-10">{{item.names}}</div>
              <van-row>
                <van-col span="12">密码：{{item.tempPwd}}</van-col>
                <van-col span="12">使用次数：{{item.useCount}}次</van-col>
              </van-row>
              <p class="f-14">使用期限：{{item.startDatetime}}-{{item.endDatetime}}</p>
              <p class="f-14">电话：{{item.mobile}}</p>
              <p class="f-14">关系：{{item.memo}}</p>
              <p class="c-666 f-12 pt-5">创建时间 {{item.createTime}}</p>
              <div class="line mt-10 mb-10"></div>
          </div>
      </f7-block>
    </van-pull-refresh>
  </f7-page>
</template>

<script>
    import {visitorList} from "@/api/api_estate.js";
    export default {
        data(){
            return {
                tempPwdList:{
                    total:-1,
                    pages:1,
                    current:0,
                    records:[]
                },
                showPreloader: false,
                allowInfinite: true,
                isLoading:false
            }
        },
        created(){
          this.getTempPwdList();
          this.$commonUtils.setTitle('授权历史');
        },
        methods:{
            jumpUseDetail(id){
                this.$f7router.navigate(`/estate/visitorDetail/${id}/`)
            },
            getTempPwdList(){
                let that = this;
                if(!this.allowInfinite)
                    return;
                if(this.tempPwdList.pages <= this.tempPwdList.current)
                    return;
                this.allowInfinite = false;
                visitorList().then(res => {
                    this.allowInfinite = true;
                    var result = res.data;
                    result.records.forEach(function(item,index){
                        that.tempPwdList.records.push(item);
                    });
                    this.tempPwdList.total = result.total;
                    this.tempPwdList.pages = result.pages;
                    this.tempPwdList.current = result.current;
                    if(this.isLoading){
                        wx.toast('刷新成功');
                        this.isLoading = false;
                    }
                }).catch(err => {
                    this.allowInfinite = true;
                    if(this.isLoading){
                        wx.toast('刷新成功');
                        this.isLoading = true;
                    }
                })
            },
            onRefresh(){
                this.tempPwdList = {
                    total:0,
                    pages:1,
                    current:0,
                    records:[]
                };

                this.allowInfinite = true;
                this.showPreloader = false;

                this.getTempPwdList();
            }
        }
    }
</script>
<style scoped>

</style>