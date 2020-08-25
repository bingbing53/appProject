<template>
  <a-modal
    :title="title"
    :width="1100"
    :bodyStyle="bodyStyle"
    style="top: 0px;"
    :visible="visible"
    :maskClosable="false"
    :confirmLoading="confirmLoading"
    @ok="handleOk"
    @cancel="handleCancel"
    :footer="null"
  >
      <a-layout>
        <a-layout-sider style="max-height: 100%;overflow: scroll;background: #fff" width="300">
          <a-menu
            mode="inline"
            :style="bodyStyle"
            @select="menuSelect"
            theme="light"
          >
            <template v-for="item in areaList">
            <a-sub-menu :key="item.orgCode">
              <span slot="title"><a-icon type="appstore" /><span>{{item.title}}</span></span>
              <template v-for="item2 in item.children">
                <a-menu-item v-if="!item2.children || item2.children.length == 0" :key="item3.orgCode">{{item2.title}}</a-menu-item>
                <a-sub-menu v-else :key="item2.orgCode">
                  <span slot="title"><a-icon type="appstore" /><span>{{item2.title}}</span></span>

                  <template v-for="item3 in item2.children">
                    <a-menu-item v-if="!item3.children || item3.children.length == 0" :key="item3.orgCode">{{item3.title}}</a-menu-item>
                    <a-sub-menu v-else :key="item3.orgCode">
                      <span slot="title"><a-icon type="appstore" /><span>{{item3.title}}</span></span>

                      <template v-for="item4 in item3.children">
                        <a-menu-item v-if="!item4.children || item4.children.length == 0" :key="item4.orgCode">{{item4.title}}</a-menu-item>
                        <a-sub-menu v-else :key="item4.orgCode">
                          <span slot="title"><a-icon type="appstore" /><span>{{item4.title}}</span></span>
                          <template v-for="item5 in item4.children">
                            <a-menu-item :key="item5.orgCode">{{item5.title}}</a-menu-item>
                          </template>
                        </a-sub-menu>
                      </template>
                    </a-sub-menu>
                  </template>

                </a-sub-menu>

              </template>
            </a-sub-menu>
          </template>
          </a-menu>
        </a-layout-sider>
        <a-layout>
          <a-layout-content>
            <a-card :bordered="false">
              <a-table bordered :dataSource="dataSource" :columns="columns" :pagination="false">
                <span slot="action" slot-scope="text, record">
                  <span v-if="record.checked">已绑定</span>
                  <a v-if="!record.checked" @click="bindVillage(record)">点击绑定</a>
                </span>
              </a-table>
            </a-card>

          </a-layout-content>
        </a-layout>
      </a-layout>

  </a-modal>
</template>

<script>
import { httpAction,getAction,postAction } from '@/api/manage'
import JDate from '@/components/jeecg/JDate'
import pick from 'lodash.pick'
import moment from 'moment'
export default {
  name: 'VillageModal',
  components: {
    JDate
  },
  data() {
    return {
      title: '操作',
      visible: false,
      bodyStyle:{
        padding: "0",
        height:(window.innerHeight-100)+"px"
      },
      modalWidth:800,
      model: {},
      labelCol: {
        xs: { span: 24 },
        sm: { span: 5 }
      },
      wrapperCol: {
        xs: { span: 24 },
        sm: { span: 16 }
      },
      confirmLoading: false,
      form: this.$form.createForm(this),
      url: {
        add: '/village/village/add',
        edit: '/village/village/edit',
        areaList:'/village/village/queryDepartTreeByDepartType',
        villageList:'/village/village/queryCommunityVillage/',
      },
      areaList:[],
      dataSource:[],
      nowSelectCode:'',
      columns:[
        {
          title: '小区名称',
          align: 'center',
          width: 50,
          dataIndex: 'villageName'
        },
        {
          title: '操作',
          dataIndex: 'action',
          align: 'center',
          width: 40,
          scopedSlots: { customRender: 'action' }
        }
      ]
    }
  },
  methods: {
    bindVillage(item){
      postAction(this.url.add,{id:item.id}).then(res => {
        if(res.success) {
          this.$message.success("添加成功");
          item.key = this.nowSelectCode;
          this.menuSelect(item);

          this.$parent.loadData();

        }else{
          this.$message.error(res.message);
        }
      });
    },
    menuSelect(item){
      this.nowSelectCode = item.key;
      getAction(this.url.villageList+item.key).then(res => {
        if(res.success) {
          this.dataSource = res.result;
        }
      });

    },
    getAreaList(){
      getAction(this.url.areaList).then(res => {
        if(res.success) {
            this.areaList = res.result;
        }
      });
    },
    add() {
      this.edit({})
    },
    edit(record) {
      this.getAreaList();
      // this.$nextTick(() => {
      //   if (record.lonlat && typeof record.lonlat == 'string') {
      //     record.lonlat = record.lonlat.split('|')
      //     let arr = []
      //     record.lonlat.forEach(function(item, index) {
      //       item = item.split('|')
      //       let json = {}
      //       item.forEach(function(items, indexs) {
      //         items = items.split(',')
      //         json.lng = items[0]
      //         json.lat = items[1]
      //       })
      //       arr.push(json)
      //     })
      //   }
      //   if (record.lonlat && typeof record.lonlat == 'object') {
      //     record.lonlat = record.lonlat.join('|')
      //   }
      // })
      this.form.resetFields()
      this.model = Object.assign({}, record)
      //初始化明细表数据
      // console.log(this.model.id)
      this.visible = true
      this.$nextTick(() => {
        this.form.setFieldsValue(
          pick(
            this.model,
            'createName',
            'updateName',
            'sysOrgCode',
            'sysCompanyCode',
            'sysOrgName',
            'sysCompanyName',
            'areaCode',
            'areaName',
            'villageName',
            'villageCode',
            'lonlat',
            'color',
            'strutureType',
            'buildingArea'
          )
        )
        // 时间格式化
      })
      // alert(JSON.stringify(this.polyline.paths[0][0]))
    },
    close() {
      this.$emit('close')
      this.visible = false
    },
    handleOk() {
      const that = this
      // 触发表单验证
      this.form.validateFields((err, values) => {
        if (!err) {
          that.confirmLoading = true
          let httpurl = ''
          let method = ''
          if (!this.model.id) {
            httpurl += this.url.add
            method = 'post'
          } else {
            httpurl += this.url.edit
            method = 'put'
          }
          let formData = Object.assign(this.model, values)
          // return;
          //时间格式化
          httpAction(httpurl, formData, method)
            .then(res => {
              if (res.success) {
                that.$message.success(res.message)
                that.$emit('ok')
              } else {
                that.$message.warning(res.message)
              }
            })
            .finally(() => {
              that.confirmLoading = false
              that.close()
            })
        }
      })
    },
    handleCancel() {
      this.close()
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
.map {
  height: 500px;
  width: 100%;
}
</style>