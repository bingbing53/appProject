<template>
  <a-modal
    :title="title"
    :width="400"
    style="top: 0px;"
    :visible="visible"
    :maskClosable="false"
    @ok="handleOk"
    @cancel="handleCancel"
    cancelText="否"
    okText="是"
  >
    <div>
      <p>未读取到身份证信息，请检查您的设备驱动是否安装？</p>
    </div>
    <a-modal v-model="load_visible" title="设备驱动软件下载"   cancel-text="取消" ok-text="确认" @ok="hideModal" >

      <a-text>
        读卡器驱动程序下载安装：</br></br>
        步骤一：下载读卡器驱动程序
        <a-button href="https://image.shequyijia.cn/pic/app/idcardRead.zip"  style="margin-left:10px;">下载</a-button></br></br>
        步骤二：保存已下载的文件并解压</br></br>
        步骤三：执行“点击安装.bat”文件安装驱动程序</br></br>
      </a-text>
    </a-modal>
  </a-modal>
</template>
<script>
  export default {
    data() {
      return {
        title: '身份证信息读取结果',
        visible: false,
        load_visible:false,
      }
    },
    methods: {
      handleOk() {
        alert("请点击电脑“开始”按钮，找到“神思SS628100型读卡服务”并启动。\n注意该服务不能多次启动，如启动多个服务，系统将无法正常读卡\n需将所有已启动服务关闭后，再重新启动一次。")
        this.visible = false;
      },
      handleCancel() {
        this.load_visible = true;
        this.visible = false;
      },
      hideModal(){
        this.load_visible = false;
      }
    }
  }
</script>

<style>

</style>