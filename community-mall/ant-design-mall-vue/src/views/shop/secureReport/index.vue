<template> 
  <div class="app-container">
    <el-card class="operate-container" shadow="never">
      <i class="el-icon-tickets"></i>
      <span style="margin-top: 5px">数据列表</span>
    </el-card>
    <div class="table-container">
      <el-table ref="orderTable"
                :data="list"
                style="width: 100%;"
                @selection-change="handleSelectionChange"
                v-loading="listLoading" border>
        <el-table-column type="selection" width="60" align="center"></el-table-column>
        <el-table-column label="提交日期" width="120" align="center">
          <template slot-scope="scope">{{scope.row.createTime | formatCreateTime}}</template>
        </el-table-column>
        <el-table-column label="分类" width="120" align="center">
          <!-- 日检、周检、月检 -->
          <template slot-scope="scope">{{scope.row.type | formatType}}</template>
        </el-table-column>
        <el-table-column label="描述" align="center">
          <template slot-scope="scope">{{scope.row.comment}}</template>
        </el-table-column>
        <el-table-column label="图片" width="240" align="center">
          <template slot-scope="scope">{{scope.row.pictures}}</template>
        </el-table-column>
        <el-table-column label="提交人" width="120" align="center">
          <template slot-scope="scope">{{scope.row.sysCompanyCode}}</template>
        </el-table-column>
        <el-table-column label="联系方式" width="120" align="center">
          <template slot-scope="scope">{{scope.row.sysCompanyCode}}</template>
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
  </div>
</template>
<script>
    import {fetchDrawCashList, updateApplyStatus, shBalance} from '@/api/shopAccount'
    import {formatDate} from '@/utils/date';
    import request from '@/utils/request'

    const defaultListQuery = {
        pageNum: 1,
        pageSize: 10,
        businessType: null
    };
    export default {
        name: "secureReportList",
        components:{},
        data() {
            return {
                listQuery: Object.assign({}, defaultListQuery),
                listLoading: true,
                list: null,
                total: null,
                multipleSelection: []
            }
        },
        created() {
            this.getList();
        },
        filters: {
            formatCreateTime(time) {
                let date = new Date(time);
                return formatDate(date, 'yyyy-MM-dd')
            },
            formatType(value) {
                // 类型（day：日检，week：周检，month：月检）
                if (value === 'day') {
                    return '日检';
                } else if (value === 'week') {
                    return '周检';
                } else {
                    return '月检';
                }
            }
        },
        methods: {
            handleResetSearch() {
                this.listQuery = Object.assign({}, defaultListQuery);
            },
            handleSearchList() {
                this.listQuery.pageNum = 1;
                this.getList();
            },
            handleSelectionChange(val){
                this.multipleSelection = val;
            },
            getList() {
                this.listLoading = true;
                request({
                  url:'/politicalBusiness/secureReport/queryList',
                  method:'get',
                  params:this.listQuery
                }).then(response => {
                    this.listLoading = false;
                    this.list = response.data.list;
                    this.total = response.data.total;
                });
            }
        }
    }
</script>
<style scoped>
  .input-width {
    width: 203px;
  }
</style>





