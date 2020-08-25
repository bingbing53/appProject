<template>
  <a-card :bordered="false" style="margin:0px 50px;padding:20px">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline">
        <a-row :gutter="24">
          <a-col :md="6" :sm="12">
            <a-form-item label="标题">
              <a-input placeholder="请输入标题查询" v-model="queryParam.title"></a-input>
            </a-form-item>
          </a-col>

          <a-col :md="6" :sm="8">
            <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">
              <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
            </span>
          </a-col>
        </a-row>
      </a-form>
    </div>

    <!-- 操作按钮区域 -->
    <div class="table-operator">
      <template v-if="selectedRowKeys.length > 0">
        <a-button class="mb-10" type="primary" @click="moveArticle">添加到待推送列表</a-button>
      </template>
    </div>

    <!-- table区域-begin -->
    <div>
      <a-row :gutter="24">
        <a-col :span="8">
          <div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">
            <i class="anticon anticon-info-circle ant-alert-icon"></i>已选择&nbsp;
            <a style="font-weight: 600">{{ selectedRowKeys.length }}</a>项&nbsp;&nbsp;
            <a style="margin-left: 24px" @click="onClearSelected">清空</a>
          </div>

          <a-table
            ref="table"
            bordered
            size="middle"
            rowKey="id"
            :columns="columns"
            :dataSource="dataSource"
            :pagination="ipagination"
            :loading="loading"
            :rowSelection="rowSelection"
            @change="handleTableChange"
          ></a-table>
        </a-col>
        <a-col :span="16">
          <a-card>
            <h3>发布文章到微信平台</h3>
            <draggable
              @end="end"
              :options="{animation: 1000}"
              v-model="dataSources"
              class="container_draggable"
            >
              <template v-for="(data,index) in dataSources">
                <a-row class="dragg_out" :key="index">
                  <template v-if="index == 0">
                    <a-col :span="24" class="col_24">
                      <div
                        v-if="data.images"
                        class="dragg_img"
                        :style="{backgroundImage: 'url(' + getImageView(data.images) + ')' }"
                      ></div>
                      <p class="dragg_title">{{data.title}}</p>
                    </a-col>
                  </template>
                  <template v-else>
                    <a-col :span="21" class="dragg_title">
                      <p>{{data.articleTitle}}</p>
                    </a-col>
                    <a-col :span="3">
                      <div class="dragg_img">
                        <img v-if="data.images" :src="getImageView(data.images)" preview="index" />
                      </div>
                    </a-col>
                  </template>
                </a-row>
              </template>
            </draggable>
            <a-button @click="sureChange(2)" type="primary" style="margin-top: 115px">发送预览</a-button>
            <a-button
              @click="sureChange(1)"
              type="primary"
              style="margin-top: 115px;margin-left:20px"
            >发布到微信公众号</a-button>
          </a-card>
          <a-modal
            title="请输入预览的微信号"
            :visible="visibleInput"
            @ok="sureView"
            :confirmLoading="confirmLoading"
            @cancel="handleCancel"
          >
            <p>
              <a-input placeholder="请输入预览的微信号" v-model="username"></a-input>
            </p>
          </a-modal>
        </a-col>
      </a-row>
    </div>
    <!-- table区域-end -->
  </a-card>
</template>

<script>
import { putAction } from '@/api/manage'
import { frozenBatch } from '@/api/api'
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import draggable from 'vuedraggable'
import ARow from 'ant-design-vue/es/grid/Row'
import ACol from 'ant-design-vue/es/grid/Col'
import { httpAction, postAction, getAction } from '@/api/manage'

export default {
  name: 'UserList',
  mixins: [JeecgListMixin],
  components: {
    ACol,
    ARow,
    draggable
  },
  data() {
    return {
      description: '这是用户管理页面',
      queryParam: {
        articleType: 0,
        pageSize: 5,
        status: 2
      },
      isorter:{
        column: 'createDate',
        order: 'desc',
      },
      columns: [
        {
          title: '标题',
          align: 'left',
          dataIndex: 'articleTitle'
        }
      ],
      url: {
        list: '/article/article/list',
        imgserver: window._CONFIG['imageViewURL'],
        pushMessage: '/article/article/pushMessage'
      },
      confirmLoading: false,
      visibleInput: false,
      spinning: false,
      ids: [],
      username: '',
      //数据集
      dataSources: [],
      oldDateSource: [],
      newDateSource: []
    }
  },
  computed: {
    rowSelection() {
      const { selectedRowKeys } = this
      return {
        selectedRowKeys: selectedRowKeys,
        onChange: this.onSelectChange,
        getCheckboxProps: record => {
          return {
            props: {
              disabled: record.images === '',
              name: record.name
            }
          }
        }
      }
    }
  },
  methods: {
    getImageView: function(image) {
      return this.url.imgserver + '/' + image
    },
    handleMenuClick(e) {
      this.batchDel()
    },

    onSelectChange(selectedRowKeys, selections) {
      this.selectedRowKeys = selectedRowKeys
      this.selections = selections

      this.selections.forEach((item, index) => {
        if (item.images) item.images = item.images.split(',')[0]
      })
    },
    end: function(evt) {
      console.log('拖动前的位置' + evt.oldIndex)
      console.log('拖动后的位置' + evt.newIndex)
    },
    sureChange(type) {
      for (var i = 0; i < this.dataSources.length; i++) {
        this.dataSources[i].sort = i
      }
      this.newDateSource = this.dataSources
      // console.log(JSON.stringify(this.newDateSource))
      let ids = []
      for (let i in this.newDateSource) {
        ids.push(this.newDateSource[i].id)
      }
      this.ids = ids
      if (type == 2) {
        this.visibleInput = true
      }
      if (type == 1) {
        this.surePublish()
      }
    },
    //直接发布
    surePublish() {
      this.ids = this.ids.join(',')
      //发送预览
      let params = {
        ids: this.ids,
        type: 1
      }
      console.log(JSON.stringify(params))
      return
      postAction(this.url.pushMessage, params).then(res => {
        if (res.code == 200) {
        }
      })
    },
    sureView() {
      this.ids = this.ids.join(',')
      //发送预览
      let params = {
        ids: this.ids,
        type: 2,
        username: this.username
      }
      this.confirmLoading = true
      console.log(JSON.stringify(params))
      return
      postAction(this.url.pushMessage, params).then(res => {
        if (res.code == 200) {
          this.confirmLoading = false
          this.visibleInput = false
        }
      })
    },
    handleCancel() {
      this.visibleInput = false
    },
    // 点击推送按钮
    moveArticle() {
      this.dataSources = []
      // this.dataSources = this.selections
      let that = this
      this.selections.forEach((item, index) => {
        that.dataSources.push(item)
      })
      console.log(JSON.stringify(this.selections))
    }
  }
}
</script>
<style scoped>
@import '~@assets/less/common.less';
@import '~@assets/less/common_cms.less';
.container_draggable {
  /* display: inline-block; */
  width: 80%;
  background: #fafafa;
  margin: 10px auto;
}
.dragg_out:nth-child(1) {
  height: 160px;
  padding: 0px;
}
.dragg_out:nth-child(1) .col_24 {
  height: 100%;
}
.dragg_out:nth-child(1) .dragg_img {
  background-size: cover;
  background-repeat: no-repeat;
  background-position: center;
  top: 0px;
  height: 100%;
}
.dragg_out:nth-child(1) .dragg_title {
  margin: 0px;
  padding: 0px;
  position: absolute;
  bottom: 0px;
  height: 40px;
  padding: 10px;
  left: 0px;
  right: 0px;
  background: rgba(0, 0, 0, 0.3);
  color: #fff;
}

.dragg_out {
  display: inle-block;
  width: 100%;
  height: 80px;
  margin-right: 10px;
  margin: 0px auto;

  border-radius: 5px;
  padding: 10px;
  cursor: pointer;
}
.dragg_title {
  font-weight: bold;
  height: 100%;
  border-bottom: 1px solid #ddd;
}
.dragg_img {
  width: 100%;
  height: 60px;
  position: relative;
  padding: 2px;

  overflow: hidden;
  vertical-align: top;
  text-align: center;
}
.dragg_img img {
  position: absolute;
  margin: auto;
  top: -9999px;
  right: -9999px;
  bottom: -9999px;
  left: -9999px;
  max-width: 100%;
  max-height: 100%;
  border-radius: 50%;
}
</style>