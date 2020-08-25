<template>
  <div class="app-container">
    <el-card :bordered="false">
    <div class="table-operator">
      <el-button type="primary" @click="readAll" icon="book" size="small">全部标注已读</el-button>
    </div>

    <div class="table-container">
      <el-table ref="brandTable"
                :data="list"
                style="width: 100%"
                @selection-change="handleSelectionChange"
                v-loading="listLoading"
                border>
        <el-table-column label="标题" align="center">
          <template slot-scope="scope">{{scope.row.titile}}</template>
        </el-table-column>
        <el-table-column label="消息类型" align="center">
          <template slot-scope="scope">{{formatMsgType(scope.row.msgCategory)}}</template>
        </el-table-column>
        <el-table-column label="发布时间" align="center">
          <template slot-scope="scope">{{scope.row.sendTime}}</template>
        </el-table-column>
        <el-table-column label="阅读状态" align="center">
          <template slot-scope="scope">
            <el-tag type="success" v-if="scope.row.readFlag == '0'" size="small">{{formatReadFlag(scope.row.readFlag)}}</el-tag>
            <el-tag type="info" v-else size="small">{{formatReadFlag(scope.row.readFlag)}}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center">
          <template slot-scope="scope">
            <el-button
              size="mini"
              @click="showAnnouncement(scope.row)">查看
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
    <div class="pagination-container">
      <el-pagination
        background
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        layout="total, sizes,prev, pager, next,jumper"
        :current-page.sync="listQuery.pageNum"
        :page-size="listQuery.pageSize"
        :page-sizes="[5,10,15]"
        :total="total">
      </el-pagination>
    </div>
    <show-announcement ref="ShowAnnouncement"></show-announcement>
  </el-card>
  </div>
</template>

<script>
  import { readAllMsg,editCementSend,getMyAnnouncementSend } from '@/api/message'
  import ShowAnnouncement from './ShowAnnouncement'
  const defaultListQuery = {
    pageNo: 1,
    pageSize: 10,
    modules:'mall'
  };
export default {
  name: 'UserAnnouncementList',
  components: {
    ShowAnnouncement
  },
  data() {
    return {
      description: '系统通告表管理页面',
      listQuery: Object.assign({}, defaultListQuery),
      list: [],
      total: null,
      listLoading: false
    }
  },
  created() {
    this.loadData()
  },
  methods: {
    handleSizeChange(val){
      this.listQuery.pageNo = 1;
      this.listQuery.pageSize = val;
      this.loadData();
    },
    handleCurrentChange(val){
      this.listQuery.pageNo = val;
      this.loadData();
    },
    formatMsgType(text){
      if (text == '1') {
        return '通知公告'
      } else if (text == '2') {
        return '系统消息'
      } else {
        return text
      }
    },
    formatReadFlag(text){
      if (text == '0') {
        return '未读'
      } else if (text == '1') {
        return '已读'
      } else {
        return text
      }
    },
    loadData(){
      this.listLoading = true;
      getMyAnnouncementSend(this.listQuery).then(res => {
        if(res.success){
          this.list = res.result.records;
          this.total = res.result.total;
        }
      }).finally(res => {
        this.listLoading = false;
      })
    },
    showAnnouncement(record) {
      editCementSend({ anntId: record.anntId }).then(res => {
        if (res.success) {
          this.loadData()
        }
      })
      this.$refs.ShowAnnouncement.detail(record)
    },
    readAll() {
      this.$confirm('是否全部标注已读?', '确认操作', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        readAllMsg({"modules":"mall"}).then(res => {
          if (res.success) {
            this.loadData()
            this.$message({
              type: 'success',
              message: '操作成功'
            });
          }
        })
      })
    }
  }
}
</script>
<style scoped>
.ant-card-body .table-operator {
  margin-bottom: 18px;
}
.anty-row-operator button {
  margin: 0 5px;
}
.ant-btn-danger {
  background-color: #ffffff;
}
z .ant-modal-cust-warp {
  height: 100%;
}
.ant-modal-cust-warp .ant-modal-body {
  height: calc(100% - 110px) !important;
  overflow-y: auto;
}
.ant-modal-cust-warp .ant-modal-content {
  height: 90% !important;
  overflow-y: hidden;
}
</style>
