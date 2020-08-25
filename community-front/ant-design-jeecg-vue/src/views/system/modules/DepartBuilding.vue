<template>
  <a-card :visible="visible">
    <a-form :form="form">
      <a-form-item
        :labelCol="labelCol"
        :wrapperCol="wrapperCol"
        label="机构名称">
        <a-input style="border:0px;" placeholder="" v-decorator="['departName', {}]"/>
      </a-form-item>
    </a-form>

    <a-layout id="components-layout-demo-responsive">
      <a-layout-sider
        breakpoint="lg"
        collapsedWidth="0"
        theme="light"
      >

        <a-menu
          mode="inline"
          @click="villageSelected"
          :selectedKeys="villageSelectedKeys"
        >
          <a-menu-item :key="pos" v-for="(item,pos) in villages">
            <a-icon type="build" />
            <span class="nav-text">{{item.villageName}}</span>
          </a-menu-item>
        </a-menu>

      </a-layout-sider>

      <a-layout>
        <a-layout-content v-if="houseList.length <= 0">
          <div v-if="villages.length > villagePos && !!villages[villagePos] && !!villages[villagePos].buildingList">
            <a-card :title="villages[villagePos].villageName+'楼宇列表'">
              <a-card-grid @click="selectBuild(item)" style="width:25%;textAlign:'center';font-size: 13px;background: #1890ff;color: white;" v-for="item in villages[villagePos].buildingList" v-if="item.isMine == '1'">{{item.buildingName}} <br><span style="font-size: 10px">已绑定</span></a-card-grid>
              <a-card-grid @click="selectBuild(item)" style="width:25%;textAlign:'center';font-size: 13px;" v-for="item in villages[villagePos].buildingList" v-if="item.isMine == '0'">{{item.buildingName}} <br><span style="font-size: 10px">待绑定</span></a-card-grid>
            </a-card>
          </div>
        </a-layout-content>
        <a-layout-content v-else>
            <a-card :title="selectBuildItem.buildingName+'房屋列表'">
              <a-card-grid style="width:25%;textAlign:'center';font-size: 13px;padding: 10px;background: #1890ff;color: white" @click="delHouse(item)" v-if="item.isMine == '1'" v-for="item in houseList">
                <span v-if="!!item.unitNo && item.unitNo.length > 0">{{item.unitNo}}单元</span>{{item.houseNumber}}<br><span style="font-size: 10px">已绑定</span>
              </a-card-grid>
              <a-card-grid style="width:25%;textAlign:'center';font-size: 13px;padding: 10px;" @click="bindHouse(item)" v-if="item.isMine == '0'" v-for="item in houseList">
                <span v-if="!!item.unitNo && item.unitNo.length > 0">
                  {{item.unitNo}}单元</span>{{item.houseNumber}}<br><span style="font-size: 10px">待绑定</span>

              </a-card-grid>
            </a-card>
        </a-layout-content>
      </a-layout>

    </a-layout>

  </a-card>
</template>
<script>
  import pick from 'lodash.pick'
  import {queryIdTree} from '@/api/api'
  import {getAction, postAction, deleteAction} from '@/api/manage'

  export default {
    name: 'DeptBuilding',
    components: {},
    data() {
      return {
        departTree: [],
        id: '',
        model: {},
        visible: false,
        disable: true,
        treeData: [],
        form: this.$form.createForm(this),
        labelCol: {
          xs: {span: 24},
          sm: {span: 3}
        },
        wrapperCol: {
          xs: {span: 24},
          sm: {span: 16}
        },

        villages:[],
        villagePos:0,
        villageSelectedKeys:['1'],
        houseList:[],
        orgCode:'',
        selectBuildItem:{}
      }
    },
    created() {
      this.loadTreeData();
    },
    methods: {
      delHouse(item){
        let params = {houseId:item.id,code1:this.orgCode};
        postAction('/sys/cube/del', params).then((res) => {
          if(this.model.departTypeCategory == 8) {
            this.selectBuild(this.selectBuildItem);
          }else if(this.model.departTypeCategory == 7){
            this.getVillageList();
          }
          this.$message.success('删除绑定成功');
        });
      },
      bindHouse(item){
        let params = {houseId:item.id,code1:this.orgCode};
        postAction('/sys/cube/save', params).then((res) => {
          if(this.model.departTypeCategory == 8) {
            this.selectBuild(this.selectBuildItem);
          }else if(this.model.departTypeCategory == 7){
            this.getVillageList();
          }
          this.$message.success('绑定房屋成功');
        });
      },
      selectBuild(item){
        this.selectBuildItem = item;
        if(this.model.departTypeCategory == 7){
          if(item.isMine == '1'){
            this.delHouse(item);
          }else if(item.isMine == '0') {
            //一级网格
            this.bindHouse(item);
          }
        }else if(this.model.departTypeCategory == 8){
          //二级网格
          let params = {buildingId:item.id,orgCode:this.orgCode};
          getAction('/sys/cube/houseList', params).then((res) => {
            if (res.success) {
              this.houseList = res.result;
              if(!!!this.houseList || this.houseList.length <= 0){
                this.$message.warning('没有可用房屋');
              }
            }
          })
        }
      },
      villageSelected(item){
        this.villagePos = item.key;
        this.villageSelectedKeys = [item.key];
        this.houseList = [];
      },
      getVillageList(){
        let params = {
          orgCode:this.orgCode
        };
        getAction('/sys/cube/villageList', params).then((res) => {
          if (res.success) {
            this.villages = res.result;
          }
        })
      },
      loadTreeData() {
        queryIdTree().then((res) => {
          if (res.success) {
            for (let i = 0; i < res.result.length; i++) {
              let temp = res.result[i];
              this.treeData.push(temp);
            }
          }

        })
      },
      open(record) {
        this.villages = [];
        this.houseList = [];
        this.villagePos = 0;
        this.villageSelectedKeys = ['0'];
        this.form.resetFields();
        this.model = Object.assign({}, record);
        this.visible = true;
        this.$nextTick(() => {
          this.form.setFieldsValue(pick(record, 'departName', 'parentId', 'orgCode', 'departOrder', 'mobile', 'fax', 'address', 'memo'));
        });
        this.orgCode = record.orgCode;
        this.getVillageList();
      },
      clearForm() {
        this.form.resetFields();
        this.treeData = [];
      },
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less'
</style>