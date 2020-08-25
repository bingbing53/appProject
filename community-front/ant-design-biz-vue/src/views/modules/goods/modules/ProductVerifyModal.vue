<template>
  <a-modal
    title="审核"
    :width="500"
    :visible="visible"
    :maskClosable="false"
    :confirmLoading="confirmLoading"
    @cancel="handleCancel"
    cancelText="关闭">

    <a-textarea placeholder="请输入审核不通过原因" v-model="detail" :rows="4" />

    <template slot="footer">
      <a-button key="back" @click="submitForm('2')" type="danger">审核不通过</a-button>
      <a-button key="submit" type="primary" @click="submitForm('1')">审核通过</a-button>
    </template>

  </a-modal>
</template>

<script>
    import {getAction,postAction} from "@/api/manage";
    export default {
      name: "ProductVerifyModal",
      data () {
        return {
          visible: false,
          productId:'',
          confirmLoading:false,
          url:{
            verify:'/mall/pmsProduct/verifyProduct',
          },
          detail:''
        }
      },
      methods:{
        submitForm(type){
          if(type == '2' && this.detail.trim() == ''){
            this.$message.warning('请输入审核不通过原因');
            return;
          }
          this.confirmLoading = true;
          let form = {
            productId:this.productId,
            detail:this.detail,
            status:type
          };
          postAction(this.url.verify,form).then(res => {
              if(res.success){
                this.confirmLoading = false;
                this.visible = false;
                this.$message.success('审核成功');
                this.$emit('ok');
              }else{
                this.$message.warning(res.message);
              }
          });

        },
        open(id){
          this.visible = true;
          this.productId = id;
        },
        handleCancel(){
          this.visible = false;
        }
      }
    }
</script>

<style scoped>

</style>