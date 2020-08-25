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
        <el-table-column label="余额改变数量" width="120" align="center">
          <template slot-scope="scope">￥{{scope.row.balanceChangeCount}}</template>
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
        name: "accountList",
        components:{},
        data() {
            return {
                listQuery: Object.assign({}, defaultListQuery),
                listLoading: true,
                list: null,
                total: null,
                operateType: 'withdrawCash',
                multipleSelection: [],
                closeOrder:{
                    dialogVisible:false,
                    content:null,
                    orderIds:[]
                },
                balance: 0.00,
                businessTypeOptions: [
                    // orderRevenue->订单收入；withdrawCash->提现支出；orderRefund->订单退款
                    {
                        label: '订单收入',
                        value: 'orderRevenue'
                    },
                    {
                        label: '提现支出',
                        value: 'withdrawCash'
                    },
                    {
                        label: '订单退款',
                        value: 'orderRefund'
                    }
                ],
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
                    this.balance = response.data.balance
                });
            },
            withdrawCashApply() {
                this.$router.push({path: '/ext/addApply'})
            }
        }
    }
</script>
<style scoped>
  .input-width {
    width: 203px;
  }
</style>
