<template> 
  <div class="app-container">
    <el-card class="filter-container" shadow="never">
      <div>
        <i class="el-icon-search"></i>
        <span>筛选搜索</span>
        <el-button
          style="float:right"
          type="primary"
          @click="handleSearchList()"
          size="small">
          查询搜索
        </el-button>
        <el-button
          style="float:right;margin-right: 15px"
          @click="handleResetSearch()"
          size="small">
          重置
        </el-button>
      </div>
      <div style="margin-top: 15px">
        <el-form :inline="true" :model="listQuery" size="small" label-width="140px">
          <el-form-item label="业务类型：">
            <el-select v-model="listQuery.businessType" class="input-width" placeholder="全部" clearable>
              <el-option v-for="item in businessTypeOptions"
                         :key="item.value"
                         :label="item.label"
                         :value="item.value">
              </el-option>
            </el-select>
          </el-form-item>
        </el-form>
      </div>
    </el-card>
    <el-card class="operate-container" shadow="never">
      <i class="el-icon-tickets"></i>
      <span style="margin-top: 5px">数据列表</span>
      <span style="margin-top: 5px; float: right">商户公益币：{{coinBalance}}</span>
    </el-card>
    <div class="table-container">
      <el-table ref="orderTable"
                :data="list"
                style="width: 100%;"
                @selection-change="handleSelectionChange"
                v-loading="listLoading" border>
        <el-table-column type="selection" width="60" align="center"></el-table-column>
        <el-table-column label="编号" width="80" align="center">
          <template slot-scope="scope">{{scope.row.id}}</template>
        </el-table-column>
        <el-table-column label="业务参考号" width="180" align="center">
          <template slot-scope="scope">{{scope.row.businessRefNumber}}</template>
        </el-table-column>
        <el-table-column label="业务类型" width="180" align="center">
          <template slot-scope="scope">{{scope.row.businessType | formatBusinessTypeType}}</template>
        </el-table-column>
        <el-table-column label="改变类型" align="center">
          <template slot-scope="scope">{{scope.row.changeType | formatChangeType}}</template>
        </el-table-column>
        <el-table-column label="公益币改变数量" width="120" align="center">
          <template slot-scope="scope">{{scope.row.coinBalanceChangeCount}}</template>
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
  import {fetchList, shBalance} from '@/api/shopAccount'
  import {formatDate} from '@/utils/date';
  const defaultListQuery = {
    pageNum: 1,
    pageSize: 10,
    businessType: null
  };
  export default {
    name: "coinAccountList",
    components:{},
    data() {
      return {
        listQuery: Object.assign({}, defaultListQuery),
        listLoading: true,
        list: null,
        total: null,
        operateType: null,
        multipleSelection: [],
        closeOrder:{
          dialogVisible:false,
          content:null,
          orderIds:[]
        },
        businessTypeOptions: [
          // orderRevenue->订单收入；withdrawCash->提现支出；orderRefund->订单退款
          {
            label: '订单收入',
            value: 'orderRevenue'
          },
          {
              label: '订单退款',
              value: 'orderRefund'
          }
        ],
        coinBalance: 0,
        logisticsDialogVisible:false
      }
    },
    created() {
      this.getList();
      this.computedBalance();
    },
    filters: {
      formatCreateTime(time) {
        let date = new Date(time);
        return formatDate(date, 'yyyy-MM-dd hh:mm:ss')
      },
        formatBusinessTypeType(value) {
        if (value === 'orderRevenue') {
          return '订单收入';
        } else if (value === 'withdrawCash') {
          return '提现支出';
        } else {
          return '订单退款';
        }
      },
        formatChangeType(value) {
        if (value === 'increase') {
          return '增加';
        } else {
          return '减少';
        }
      },
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
      handleSizeChange(val) {
        this.listQuery.pageNum = 1;
        this.listQuery.pageSize = val;
        this.getList();
      },
      handleCurrentChange(val) {
        this.listQuery.pageNum = val;
        this.getList();
      },
      getList() {
        this.listLoading = true;
        fetchList(this.listQuery).then(response => {
          this.listLoading = false;
          this.list = response.data.list;
          this.total = response.data.total;
        });
      },
      computedBalance() {
        shBalance().then(response => {
          if (response.data && response.data.coinBalance) {
            this.coinBalance = response.data.coinBalance
          }
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


