<template>
  <div class="editContainer">
    <a-row class="row_list">
      <a-col :span="6" class="col_list">
        <div class="left_list">
          <span>&nbsp; &nbsp;相关图文 ({{commen_data_left.length}})</span>
          <br />
          <br />
          <div class="comment_list_left">
            <a-list
              itemLayout="vertical"
              size="large"
              :pagination="pagination"
              :dataSource="commen_data_left"
              :loading="loading"
            >
              <a-list-item
                slot="renderItem"
                slot-scope="item, index"
                key="item.articleTitle"
                @click="getcommemtDetail(item.id)"
                style="word-break: break-all;"
              >
                <a-list-item-meta style="word-break: break-all;">
                  <a class="comment_title" slot="title" style="word-break: break-all;">{{item.articleTitle}}</a>
                </a-list-item-meta>
                <span class="comment_num">{{item.comment}} 评论</span>
              </a-list-item>
            </a-list>
          </div>
        </div>
      </a-col>
      <a-col :span="18">
        <div class="right_list">
          <p>评论</p>
          <div class="comment_list_right">
            <!-- <a-spin tip="Loading..." v-show="!loading2"> -->
                <a-row class="commList" v-if="comment_data_right.length <= 0">
                  <a-col :span="24">
                      <div class="none_comment">
                          暂无评论...
                      </div>
                  </a-col>
                </a-row>
            <a-row class="commList" v-else v-for="(item,index) in comment_data_right">
              <a-col :span="3" class="head_image_container">
                <div class="head_image">
                  <img :src="item.head_path" alt class="headimg" />
                </div>
              </a-col>
              <a-col :span="19">
                <div>
                  <span class="comment_name">{{item.name}}</span>
                  <span class="comment_time">{{item.create_time}}</span>
                  <h5 class="comment_content">{{item.review_content}}</h5>
                </div>
                <p class="check_comment" v-show="item.showup" @click="checkUp(item.id,index)">
                  查看评论
                  <a-icon type="down" />
                </p>
                <p
                  class="check_comment"
                  v-show="!item.showup"
                  @click="comment_data_right[index].showup = true;$forceUpdate()"
                >
                  收起评论
                  <a-icon type="up" />
                </p>
                <div class="subCommentList" v-show="!item.showup">
                  <a-row
                    class="sub_row"
                    v-if="item.reviewRecords && item.reviewRecords.records"
                    v-for="(item2,index2) in item.reviewRecords.records"
                  >
                    <a-col :span="3">
                      <div class="head_image">
                        <img :src="item2.head_path" alt class="headimg"/>
                      </div>
                    </a-col>
                    <a-col :span="19">
                      <div>
                        <span class="comment_name">{{item2.name}}</span>
                        <span class="comment_time">{{item2.create_time}}</span>
                        <h5 class="comment_content">{{item2.review_content}}</h5>
                      </div>
                    </a-col>
                    <a-col :span="2">
                      <a-icon type="delete" style="color:#f00" @click="delComment(item2.id)" />
                    </a-col>
                  </a-row>
                  <div class="sub_load" v-show="item.reviewRecords.records.length > 0">
                    <a-spin v-if="loadingMore" />
                    <a-button size="small" v-else @click="onLoadMore(item.id,index)">查看更多...</a-button>
                  </div>
                </div>
              </a-col>
              <a-col :span="2">
                <a-icon type="delete" style="color:#f00" @click="delComment(item.id)" />
              </a-col>
            </a-row>
            <!-- </a-spin> -->
            <a-pagination
              style="float:right;"
              :pageSizeOptions="pageSizeOptions"
              :total="pagination2.total"
              showSizeChanger
              :pageSize="pagination2.pageSize"
              v-model="pagination2.pageNo"
              @change="onChange"
              @showSizeChange="showSizeChange"
            ></a-pagination>
          </div>
        </div>
      </a-col>
    </a-row>
  </div>
</template>
<script>
import { httpAction, postAction, postActionimg, getAction, deleteAction } from '@/api/manage'
export default {
  name: 'commentList',
  data() {
    return {
      type: '',
      commen_data_left: [],
      comment_data_right: [],
      url: {
        list: '/article/article/list',
        commentList: 'article/article/comment',
        delete: '/article/article/delComment'
      },
      relation_id: '',
      pageNo_sub: 1,
      pagination: {
        pageSize: 10,
        pageNo: 1,
        onChange: page => {
          console.log(page)
          this.pagination.pageNo = page
          this.getdatas()
        }
      },
      loading: false,
      pagination2: {
        pageSize: 5,
        pageNo: 1,
        total: 0
      },
      loading2: false,
      loading3: false,
      loadingMore: false,
      showLoadingMore: true,
      page2: 1,
      pageSizeOptions: ['5', '10', '20', '30', '40', '50']
    }
  },
  methods: {
    onChange(pageNo, pageSize) {
      console.log(pageNo, pageSize)
      this.pagination2.pageNo = pageNo
      this.getCommentListFirst()
    },
    showSizeChange(current, size) {
      console.log(current, size)
      this.pagination2.pageNo = current
      this.pagination2.pageSize = size
      this.getCommentListFirst()
    },
    getType(type) {
      type == 1 ? (this.type = 1) : (this.type = 0)
    },
    //获取左侧的文章、视频列表
    getdatas() {
      this.loading = true
      let params = {
        articleType: this.type,
        status: 2,
        pageNo: this.pagination.pageNo,
        pageSize: this.pagination.pageSize
      }
      console.log(JSON.stringify(params))
      getAction(this.url.list, params).then(res => {
        if (res.success) {
          this.commen_data_left = res.result.records
          this.pagination.total = res.result.total
          this.loading = false
        }
      })
    },

    subCommentList(ids, callBack) {
      let listParam = {
        relation_id: ids,
        pageNo: this.pageNo_sub + 1,
        pageSize: 10
      }
      console.log(JSON.stringify(listParam))
      // return;
      getAction(this.url.commentList, listParam).then(res => {
        if (res.success) {
          this.pageNo_sub = res.result.current
          if (res.result.current >= res.result.pages) {
            this.loadingMore = false
          }
          callBack(res)
        }
      })
    },
    //二级评论加载更多
    onLoadMore(ids, inx) {
      this.loadingMore = true
      this.subCommentList(ids, res => {
        this.comment_data_right[inx].reviewRecords.records = this.comment_data_right[inx].reviewRecords.records.concat(
          res.result.records
        )
        this.loadingMore = false
        this.$nextTick(() => {
          window.dispatchEvent(new Event('resize'))
        })
      })
    },
    getCommentListFirst() {
      this.loading2 = true
      let listParam = {
        relation_id: this.relation_id,
        pageNo: this.pagination2.pageNo,
        pageSize: this.pagination2.pageSize
      }
      getAction(this.url.commentList, listParam).then(res => {
        if (res.success) {
          this.comment_data_right = res.result.records
          this.pagination2.total = res.result.total
          this.loading2 = false
          res.result.records.forEach((item, index) => {
            item.showup = true
          })
        }
      })
    },
    getcommemtDetail(id) {
      this.relation_id = id
      this.getCommentListFirst()
    },
    //查看二级评论
    checkUp(ids, index) {
      let that = this
      let para = {
        pageNo: this.page2,
        relation_id: ids
      }
      this.comment_data_right[index].showup = false
      this.comment_data_right[index].reviewRecords.records = []
      getAction(this.url.commentList, para).then(res => {
        let data = res.result.records
        data.forEach(function(item) {
          if (!!item) {
            that.comment_data_right[index].reviewRecords.records.push(item)
          }
        })
        that.$forceUpdate()
      })
    },
    //删除评论
    delComment(id) {
      if (!this.url.delete) {
        this.$message.error('请设置url.delete属性!')
        return
      }
      var that = this
      this.$confirm({
        title: '确认删除这条评论吗?',
        okText: '确认',
        okType: 'danger',
        cancelText: '取消',
        onOk() {
          deleteAction(that.url.delete, { id: id }).then(res => {
            if (res.success) {
              if (that.dataSource.length > 0) {
              }
              that.getdatas()
            } else {
            }
          })
        },
        onCancel() {
          console.log('Cancel')
        }
      })
    }
  },
  mounted() {}
}
</script>

<style lang="less" scoped>
.editContainer {
  background: #fff;
  padding: 20px;
  margin: 0px 50px;
  .row_list {
    .col_list {
      .left_list {
        border-right: 1px solid #ccc;
        width: 100%;
        height: 100%;
        padding: 0px 10px 0px 10px;
      }
    }
    .none_comment{
      text-align: center;
      padding:20px;
    }
    .right_list {
      padding: 0px 80px 0px 80px;
    }
  }
  .comment_title {
    // color: #1890ff;
    font-size: 14px;
    font-weight: normal;
  }
  .comment_num {
    color: #999;
    font-size: 12px;
  }
  .comment_list_left {
    .ant-list-vertical .ant-list-item-meta {
      margin: 0px;
    }
    .ant-list-item {
      padding: 5px;
      .ant-list-item-content {
        margin: 0px 0px 5px 0px;
      }
    }
  }
  .head_image_container .head_image {
    margin: 0 auto;
  }
  .head_image {
    width: 40px;
    height: 40px;
    overflow: hidden;
    position: relative;
    border: 1px solid #eee;
    border-radius: 50%;
  }
  .head_image .headimg {
    position: absolute;
    margin: auto;
    top: -9999px;
    right: -9999px;
    bottom: -9999px;
    left: -9999px;
    max-height: 100%;
  }
  .subCommentList {
    padding: 10px;
    .sub_row {
      margin: 10px;
      padding: 4px;
      border-bottom: 1px solid #eee;
    }
    .sub_load{
      text-align: center;
      button{
        border:none;
      }
    }
  }
  .commList {
    border-bottom: 1px solid #eee;
    margin-bottom: 20px;
  }
  .check_comment {
    margin-top: 5px;
    cursor: pointer;
    color: #406599;
    font-size: 12px;
  }
  .comment_time {
    color: #999;
    font-size: 14px;
  }
  .comment_name {
    font-size: 16px;
    font-weight: bold;
    margin-right: 5px;
  }
  .comment_content {
    margin-top: 5px;
    font-size: 14px;
    font-weight: normal;
  }
}
</style>