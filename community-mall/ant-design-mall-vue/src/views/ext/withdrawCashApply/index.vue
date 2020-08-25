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
        <el-table-column label="申请编号" width="200" align="center">
          <template slot-scope="scope">{{scope.row.sn}}</template>
        </el-table-column>
        <el-table-column label="提现金额" width="120" align="center">
          <template slot-scope="scope">￥{{scope.row.amount }}</template>
        </el-table-column>
        <el-table-column label="银行卡号" width="220" align="center">
          <template slot-scope="scope">{{scope.row.bankAccount}}</template>
        </el-table-column>
        <el-table-column label="开户名" width="120" align="center">
          <template slot-scope="scope">￥{{scope.row.bankAccountName}}</template>
        </el-table-column>
        <el-table-column label="开户行" align="center">
          <template slot-scope="scope">{{scope.row.bank}}</template>
        </el-table-column>
        <el-table-column label="操作" width="210" align="center">
          <template slot-scope="scope">
            <el-button
              size="mini"
              @click="handleUpdateStatus(scope.row, 2)"
              v-show="scope.row.status===0">审核通过</el-button>
            <el-button
              size="mini"
              @click="handleUpdateStatus(scope.row, 1)"
              v-show="scope.row.status===0">审核驳回</el-button>
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
    <el-dialog
      :title="dialogTitle"
      :visible.sync="dialogVisible"
      width="30%">
      <el-form ref="updateStatusForm":model="updateStatusParam" label-width="120px">
        <el-form-item label="拒绝理由" prop="name">
          <el-input type="textarea" v-model="updateStatusParam.rejectReason" auto-complete="off"></el-input>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="updateStatusSumbit()">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>
<script>
    import {fetchDrawCashList, updateApplyStatus, shBalance} from '@/api/shopAccount'
    import {formatDate} from '@/utils/date';

    const defaultUpdateStatusParam = {
        id: '',
        status: 0,
        rejectReason: ''
    };
    const defaultListQuery = {
        pageNum: 1,
        pageSize: 10,
        businessType: null
    };
    export default {
        name: "drawCashList",
        components:{},
        data() {
            return {
                listQuery: Object.assign({}, defaultListQuery),
                updateStatusParam: Object.assign({}, defaultUpdateStatusParam),
                listLoading: true,
                list: null,
                total: null,
                operateType: 'withdrawCash',
                multipleSelection: [],
                dialogTitle: '',
                dialogVisible:false,
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
                ]
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

            getList() {
                this.listLoading = true;
                fetchDrawCashList(this.listQuery).then(response => {
                    this.listLoading = false;
                    this.list = response.data.list;
                    this.total = response.data.total;
                });
            },
            handleUpdateStatus(row, status){
                this.updateStatusParam.id=row.id;
                this.updateStatusParam.status=status;
                this.$confirm('是否要进行此操作?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    //如果审核拒绝，弹出拒绝理由框
                    if(status === 1) {
                        this.dialogVisible = true;
                        this.dialogTitle = "拒绝理由";
                    }else {
                        this.updateStatusSumbit();
                    }

                });
            },
            updateStatusSumbit() {
                updateApplyStatus(this.updateStatusParam).then(response=>{
                    this.$message({
                        type: 'success',
                        message: '操作成功!',
                        duration:1000
                    });
                    this.$router.back();
                    this.dialogVisible = false;
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





