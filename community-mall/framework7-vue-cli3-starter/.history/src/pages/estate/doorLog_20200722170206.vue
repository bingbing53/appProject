<template>
    <f7-page>
        <van-pull-refresh v-model="doorLogList.isLoading" @refresh="getDoorLog(1)">
            <van-list
                    v-model="doorLogList.loading"
                    :finished="doorLogList.finished"
                    finished-text="没有更多了"
                    @load="getDoorLog(0)"
            >
                <van-cell-group v-for="item in doorLogList.items">
                    <van-cell :title="item.devName" :value="item.eventType_dictText" :border="false"/>
                    <van-cell title="开门时间" :value="item.createTime" :border="false"/>
                </van-cell-group>
            </van-list>
        </van-pull-refresh>
    </f7-page>
</template>
<script>
    import {doorLog} from "@/api/api_estate.js";
    export default {
        data(){
            return {
                doorLogList:{
                    items: [],
                    isLoading: false,
                    loading: false,
                    finished: false,
                    total: 0,
                    pages: 1,
                    current:0
                }
            }
        },
        created(){
            this.$commonUtils.setTitle('开门记录');
        },
        methods:{
            //获取开门记录
            getDoorLog(type){
                let _this = this;
                if(type == 1){
                    this.doorLogList.pages = 1;
                    this.doorLogList.total = 0;
                    this.doorLogList.current = 0;
                    this.doorLogList.items = [];
                }
                if(this.doorLogList.pages <= this.doorLogList.current)
                    return;
                doorLog({pageNo:this.doorLogList.current + 1}).then(res => {

                    let result = res.data;

                    result.records.forEach(function(item){
                        _this.doorLogList.items.push(item);
                    });
                    this.doorLogList.total = result.total;
                    this.doorLogList.pages = result.pages;
                    this.doorLogList.current = result.current;

                    this.doorLogList.finished = false;

                    console.log(this.doorLogList.pages);
                    console.log(this.doorLogList.current);

                    if(this.doorLogList.pages <= this.doorLogList.current)
                        this.doorLogList.finished = true;
                    this.doorLogList.isLoading = false;
                    this.doorLogList.loading = false;
                }).catch(err => {
                    this.doorLogList.isLoading = false;
                    this.doorLogList.loading = false;
                    this.doorLogList.finished = false;
                });
            }
        }
    }
</script>

<style scoped>

</style>