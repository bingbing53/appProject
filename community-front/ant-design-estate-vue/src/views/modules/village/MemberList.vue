<template>
  <a-row :gutter="24">
    <a-col :span="24">
      <!-- 成员信息表格begin -->
      <div>
        <div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">
          <i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择
          <a style="font-weight: 600">{{ selectedRowKeys.length }}</a>项
          <a style="margin-left: 24px" @click="onClearSelected">清空</a>
        </div>

        <a-table
          ref="table"
          size="middle"
          bordered
          rowKey="id"
          :columns="columns"
          :dataSource="dataSource"
          :pagination="ipagination"
          :loading="loading"
          :rowSelection="{onChange: onSelectChange}"
          @change="handleTableChange"
          :scroll="{ x: 1220, y: 300 }"
        >
          <span slot="action" slot-scope="text, record">
            <a @click="handleEdit(record)">编辑</a>

            <a-divider type="vertical" />
            <a-dropdown>
              <a class="ant-dropdown-link">
                更多
                <a-icon type="down" />
              </a>
              <a-menu slot="overlay">
                <a-menu-item>
                  <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.id)">
                    <a>删除</a>
                  </a-popconfirm>
                </a-menu-item>
              </a-menu>
            </a-dropdown>
          </span>
        </a-table>
      </div>
      <!-- 成员信息表格end -->
    </a-col>
  </a-row>
</template>
<script>
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
export default {
  name: 'memberList',
  mixins: [JeecgListMixin],
  props:['ids','datas'],
  data() {
    return {
      personIds: '', //选择后成员的id集合
      labelCol: {
        xs: { span: 24 },
        sm: { span: 5 }
      },
      wrapperCol: {
        xs: { span: 24 },
        sm: { span: 16 }
      },
      url: {
        edit: '/village/house/edit',
        list: '/village/house/queryHouseInfo',
        delete: '/person/personInfo/delete'
      },
      // 表头
      columns: [
        {
          title: '#',
          dataIndex: '',
          key: 'rowIndex',
          width: 60,
          align: 'center',
          customRender: function(t, r, index) {
            return parseInt(index) + 1
          }
        },
        {
          title: '姓名',
          align: 'center',
          width: 80,
          dataIndex: 'personName'
        },
        {
          title: '手机号',
          align: 'center',
          width: 100,
          dataIndex: 'mobilePhone'
        },
        {
          title: '卡号',
          align: 'center',
          width: 100,
          dataIndex: 'cardNo'
        },
        {
          title: '曾用名',
          align: 'center',
          width: 80,
          dataIndex: 'usedName'
        },
        {
          title: '证件号码',
          align: 'center',
          width: 80,
          dataIndex: 'idcard'
        },
        {
          title: '居民头像',
          align: 'center',
          width: 80,
          dataIndex: 'headImage'
        },
        {
          title: '性别',
          align: 'center',
          width: 80,
          dataIndex: 'sex'
        },
        {
          title: '籍贯',
          align: 'center',
          width: 80,
          dataIndex: 'nativePlace'
        },
        {
          title: '民族',
          align: 'center',
          width: 80,
          dataIndex: 'nationality'
        },
        {
          title: '政治面貌',
          align: 'center',
          width: 80,
          dataIndex: 'polity'
        },
        {
          title: '文化程度',
          align: 'center',
          width: 80,
          dataIndex: 'eduLevel'
        },
        {
          title: '家庭地址',
          align: 'center',
          width: 80,
          dataIndex: 'familyAddress'
        },
        {
          title: '操作',
          dataIndex: 'action',
          align: 'center',
          fixed: 'right',
          scopedSlots: { customRender: 'action' }
        }
      ]
    }
  },
  methods: {
       getrowDatas(data, idArray) {
      //从子组件中获取选中人员的id,并放入this.dataSource中渲染当前表格
      console.log(this.dataSource)
      let that = this
      data.forEach((item, index) => {
        that.dataSource && that.dataSource.push(item)
      })
      this.personIds = idArray.join(',')
    },
  },
  mounted() {
      console.log(this.ids)
      console.log(this.datas)
  }
}
</script>
<style scoped>
</style>