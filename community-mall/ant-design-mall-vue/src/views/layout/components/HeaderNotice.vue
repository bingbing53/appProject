<template>
    <span @click="fetchNotice" class="header-notice">
      <el-badge :value="msgTotal">
        <i class="el-icon-bell"></i>
      </el-badge>
    </span>
</template>

<script>
  import { listCementByUser } from '@/api/message'
  export default {
    name: "HeaderNotice",
    components: {
    },
    data () {
      return {
        loadding: false,
        url:{
          listCementByUser:"/sys/annountCement/listByUser",
          editCementSend:"/sys/sysAnnouncementSend/editByAnntIdAndUserId",
          queryById:"/sys/annountCement/queryById",
        },
        hovered: false,
        announcement1:[],
        announcement2:[],
        msg1Count:"0",
        msg2Count:"0",
        msg1Title:"通知(0)",
        msg2Title:"",
        stopTimer:false,
      }
    },
    computed:{
      msgTotal () {
        return parseInt(this.msg1Count)+parseInt(this.msg2Count);
      }
    },
    mounted() {
      this.loadData();
      this.timerFun();
    },
    methods: {
      timerFun() {
        this.stopTimer = false;
        let myTimer = setInterval(()=>{
          // 停止定时器
          if (this.stopTimer == true) {
            clearInterval(myTimer);
            return;
          }
          this.loadData()
        },60000)
      },
      loadData (){

        try {
          listCementByUser({'modules':'mall'}).then((res) => {
              if (res.success) {
                this.announcement1 = res.result.anntMsgList;
                this.msg1Count = res.result.anntMsgTotal;
                this.msg1Title = "通知(" + res.result.anntMsgTotal + ")";
                this.announcement2 = res.result.sysMsgList;
                this.msg2Count = res.result.sysMsgTotal;
                this.msg2Title = "系统消息(" + res.result.sysMsgTotal + ")";
              }
          }).catch((err) => {
            this.stopTimer = true;
          })
        } catch (err) {
          this.stopTimer = true;
        }
      },
      fetchNotice () {
        if (this.loadding) {
          this.loadding = false
          return
        }
        this.loadding = true
        setTimeout(() => {
          this.loadding = false
        }, 200)

        this.$router.push({path:'/annoncement',query:{}})

      },
    }
  }
</script>

<style lang="css">
  .header-notice-wrapper {
    top: 50px !important;
  }
</style>
<style lang="scss" scoped>
  .header-notice{
    cursor: pointer;
    display: inline-block;
    transition: all 0.3s;
    margin-right: 30px;
    line-height: 30px;
    float: right;
    margin-top: 10px;
    span {
      vertical-align: initial;
    }
  }
</style>
