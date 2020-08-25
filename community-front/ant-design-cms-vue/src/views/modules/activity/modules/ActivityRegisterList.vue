<template>
  <a-drawer
      :title="title"
      :width="500"
      placement="right"
      :closable="false"
      @close="close"
      :visible="visible"
  >

    <a-spin :spinning="confirmLoading">

      <a-list
        itemLayout="vertical"
        size="large"
        :pagination="pagination"
        :dataSource="dataSource"
        :loading="loading"
      >
        <a-list-item slot="renderItem" slot-scope="item, index" key="item.id" style="padding: 0;padding-top: 10px;">
          <a-row>
            <a-col :span="4" style="text-align: center;margin-top: 10px;">
              <a-avatar :src="item.headImage" size="large"/>
            </a-col>
            <a-col :span="18">
              昵称：{{item.nickName}}
              <a-tag v-if="item.register == '2'">未签</a-tag>
              <a-tag color="green" v-if="item.register == '1'">已签</a-tag>
              <a-tag color="red" v-if="item.register == '0'">缺勤</a-tag>
              <br>
              手机号：{{item.mobile}}<br>
              真实姓名：{{item.realName}}<br>

            </a-col>
          </a-row>
          <br>
        </a-list-item>
      </a-list>

    </a-spin>
  </a-drawer>
</template>

<script>
  import { httpAction,getAction } from '@/api/manage'
  import pick from 'lodash.pick'
  import moment from "moment"

  export default {
    name: "ActivityRegister",
    data () {
      return {
        title:"已报名列表",
        visible: false,
        model: {},
        labelCol: {
          xs: { span: 24 },
          sm: { span: 5 },
        },
        wrapperCol: {
          xs: { span: 24 },
          sm: { span: 16 },
        },
        confirmLoading: false,
        activityId:'',
        url: {
          list: "/cms/activityRegister/getRegisterList",
          imageServer:window._CONFIG['imageViewURL']
        },
        dataSource: [],
        pagination: {
          pageSize: 5,
          pageNo: 1,
          onChange: page => {
            this.pagination.pageNo = page
            this.getActivityList()
          }
        },
        loading: false,
      }
    },
    created () {
    },
    methods: {
      show (id) {
        this.visible = true;
        this.activityId = id;
        this.getList();
      },
      getList(){
        this.confirmLoading = true;
        let param = {
          id:this.activityId,
          pageNo: this.pagination.pageNo,
          pageSize: this.pagination.pageSize,
        }
        getAction(this.url.list, param).then(res => {
          if (res.success) {
            if(!!res.result && res.result.length > 0){
              for(var i = 0;i<res.result.length;i++){
                res.result[i].headImage = this.getImageView(res.result[i].headImage);
              }
            }
            this.dataSource = res.result
            this.pagination.total = res.result.length;
            this.confirmLoading = false
          }
        })
      },
      getImageView(image) {
        if(!image) return '';
        if(image.indexOf('http') == 0){
          return image;
        }else {
          return this.url.imageServer + '/' + image
        }
      },
      close () {
        this.$emit('close');
        this.visible = false;
      },
      handleCancel () {
        this.close()
      },
    }
  }
</script>

<style lang="less" scoped>
/** Button按钮间距 */
  .ant-btn {
    margin-left: 30px;
    margin-bottom: 30px;
    float: right;
  }
</style>