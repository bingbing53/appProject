<template>
  <a-drawer :width="600" placement="right" :visible="visible" :closable="false" @close="close">
    <!-- 主表单区域 -->
    <a-tabs @change="callback" type="card">
      <a-tab-pane tab="预约详情" key="1">
        <div style="padding:0px 30px">
          <a-row style="margin-bottom:20px;padding-bottom:10px;border-bottom:1px solid #eee;">
            <a-col :span="12" class="pd-10">
              <div class="text_c">
                <span class="c_style">用户名:</span>
                <span>{{model.userName}}</span>
              </div>
            </a-col>
            <a-col :span="12" class="pd-10">
              <div class="text_c"></div>
              <span class="c_style">手机号:</span>
              <span>{{model.userMobile}}</span>
            </a-col>
            <a-col :span="24" class="pd-10">
              <div class="text_c"></div>
              <span class="c_style">用户住址:</span>
              <span>{{model.userAddress}}</span>
            </a-col>
          </a-row>
          <a-row style="margin-bottom:20px;padding-bottom:10px;border-bottom:1px solid #eee;">
            <a-col :span="12" class="pd-10">
              <div class="text_c"></div>
              <span class="c_style">预约类型:</span>
              <span>{{model.orderType_dictText}}</span>
            </a-col>
            <a-col :span="12" class="pd-10">
              <div class="text_c"></div>
              <span class="c_style">预约时间:</span>
              <span>{{model.orderServiceDate}}</span>
            </a-col>
            <a-col :span="24" class="pd-10">
              <div class="text_c"></div>
              <span class="c_style">服务状态:</span>
              <span>{{model.status_dictText}}</span>
            </a-col>
            <a-col :span="24" class="pd-10">
              <div class="text_c"></div>
              <span class="c_style">预约内容:</span>
              <span>{{model.content}}</span>
            </a-col>
            <a-col :span="24" class="pd-10">
              <div v-for="(item,index) in model.image" :key="index" class="pd-10">
                <img :src="imageView(item)" alt width="100" height="100" />
              </div>
            </a-col>
          </a-row>
          <a-row style="margin-bottom:20px;padding-bottom:10px;border-bottom:1px solid #eee;">
            <a-col :span="12" class="pd-10">
              <div class="text_c"></div>
              <span class="c_style">评分:</span>
              <span>{{model.judge}}</span>
            </a-col>
            <a-col :span="12" class="pd-10">
              <div class="text_c"></div>
              <span class="c_style">评价内容:</span>
              <span>{{model.judgeContent}}</span>
            </a-col>
          </a-row>
        </div>
      </a-tab-pane>
      <a-tab-pane tab="预约进度" key="2">
        <div style="padding:30px;">
          <a-timeline>
            <a-timeline-item v-for="(item,index) in dataSource" :key="index">
              <p>
                {{item.stateDes}}
                <span style="font-size:12px;">{{item.stateDate}}</span>
              </p>
            </a-timeline-item>
          </a-timeline>
        </div>
      </a-tab-pane>
    </a-tabs>
  </a-drawer>
</template>

<script>
import { httpAction, getAction } from '@/api/manage'
import JDate from '@/components/jeecg/JDate'
import pick from 'lodash.pick'
import moment from 'moment'
export default {
  name: 'OrderModal',
  components: {
    JDate
  },
  data() {
    return {
      visible: false,
      model: {},
      url: {
        add: '/serve/order/add',
        edit: '/serve/order/edit',
        orderStateList: '/serve/order/queryOrderStateByMainId',
        imgerver: window._CONFIG['imageViewURL'],
        stateList: '/serve/order/listOrderStateByMainId'
      },
      dataSource: []
    }
  },
  methods: {
    callback(key) {
      console.log(key)
    },
    add() {
      this.edit({})
    },
    imageView(url) {
      return window._CONFIG['imageViewURL'] + '/' + url
    },
    edit(record) {
      console.log(JSON.stringify(record))
      if (record.image && record.image.length > 3) record.image = record.image.split(',')
      this.model = Object.assign({}, record)
      //初始化明细表数据
      console.log(this.model.id)
      this.visible = true
    },
    close() {
      // this.$emit('close');
      this.visible = false
    },
    //获取预约进度
    getserveStep() {
      getAction(this.url.stateList, { mainId: this.model.id }).then(res => {
        if (res.success) {
          this.dataSource = res.result
        } else {
          this.dataSource = null
        }
      })
    }
  }
}
</script>

<style scoped>
.ant-btn {
  padding: 0 10px;
  margin-left: 3px;
}

.ant-form-item-control {
  line-height: 0px;
}

/** 主表单行间距 */
.ant-form .ant-form-item {
  margin-bottom: 10px;
}

/** Tab页面行间距 */
.ant-tabs-content .ant-form-item {
  margin-bottom: 0px;
}

.text_c {
  /* text-align: center; */
}
.pd-10 {
  padding: 5px;
}
.c_style {
  color: #999 !important;
  margin-right: 10px;
}
</style>