<template>
  <a-drawer
    :title="title"
    :maskClosable="true"
    width=650
    placement="right"
    :closable="true"
    @close="close"
    :visible="visible"
    style="height: calc(100% - 55px);overflow: auto;padding-bottom: 53px;">

    <a-form>
      <a-form-item>
          <a-checkbox-group v-model="checkedMessageList">
              <a-row v-for="item in allMessageList">
                <a-col :span="24" style="margin-bottom: 10px;margin-top: 10px;font-size: 16px;">{{item.modules}}</a-col>
                <a-col v-for="col in item.template" :span="12"><a-checkbox :value="col.id">{{col.templateName}}</a-checkbox></a-col>
              </a-row>
          </a-checkbox-group>
      </a-form-item>
    </a-form>

    <div class="drawer-bootom-button">
      <a-popconfirm title="确定放弃编辑？" @confirm="close" okText="确定" cancelText="取消">
        <a-button style="margin-right: .8rem">取消</a-button>
      </a-popconfirm>
      <a-button @click="handleSubmit" type="primary" :loading="loading">提交</a-button>
    </div>

  </a-drawer>
</template>
<script>
  import {queryTreeListForRole,queryRolePermission,saveRolePermission} from '@/api/api'
  import {getAction, postAction, deleteAction} from '@/api/manage'
  export default {
    name: "MessageModal",
    components:{
    },
    data(){
      return {
        roleId:"",
        checkedMessageList:[],
        allMessageList:[],
        title:"角色消息权限配置",
        visible: false,
        loading: false,
      }
    },
    methods: {
      show(roleId){
        this.roleId=roleId
        this.visible = true;
      },
      reset () {
        this.checkedMessageList = [];
        this.allMessageList = [];
        this.loading = false
      },
      close () {
        this.reset()
        this.$emit('close');
        this.visible = false;
      },
      handleCancel () {
        this.close()
      },
      handleSubmit(){
        let that = this;
        let params =  {
          roleId:that.roleId,
          smsTemplateId:that.checkedMessageList.join(","),
        };
        that.loading = true;
        console.log("请求参数：",params);
        postAction('/message/sysMessageTemplate/updateRoleTemplate',params).then((res)=>{
          if(res.success){
            that.$message.success(res.message);
            that.loading = false;
            that.close();
          }else {
            that.$message.error(res.message);
            that.loading = false;
            that.close();
          }
        })
      },
    },
  watch: {
    visible () {
      if (this.visible) {
        let params =  {
          roleId:this.roleId,
        };
        getAction('/message/sysMessageTemplate/queryTreeList', params).then((res) => {
          if (res.success) {
              this.allMessageList = res.result.allTemplate;
              this.checkedMessageList = res.result.checkedIds;
          }
        })
      }
    }
  }
  }

</script>
<style lang="scss" scoped>
  .drawer-bootom-button {
    position: absolute;
    bottom: 0;
    width: 100%;
    border-top: 1px solid #e8e8e8;
    padding: 10px 16px;
    text-align: right;
    left: 0;
    background: #fff;
    border-radius: 0 0 2px 2px;
  }

</style>