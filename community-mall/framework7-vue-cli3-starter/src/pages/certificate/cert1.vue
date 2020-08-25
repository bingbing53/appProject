<template>
    <f7-page>
        <div class="mb-20 pd-10">
            <span class="c-waring"><van-icon name="warning-o" color="#ff976a" class="v_middle mr-5" />请填写个人真实信息</span>
        </div>
        <van-cell-group class="myGroup">
            <van-field
                    v-model="info.realnameHidden"
                    required
                    clearable
                    label="真实姓名"
                    placeholder="请输入真实姓名"
            />

            <van-field v-model="info.idcardHidden" label="身份证号" clearable placeholder="请输入身份证号" />
        </van-cell-group>

        <div class="mt-50 pd-30">
            <van-button type="danger" round @click="postMineInfo">保存信息</van-button>
        </div>
    </f7-page>
</template>

<script>
    import { certificate1, getMineInfo } from "@/api/api_community.js";
    export default {
        data() {
            return {
                info: {
                    realname: "",
                    realnameHidden: "",
                    idcard: "",
                    idcardHidden: ""
                }
            };
        },
        created() {
            this.$commonUtils.setTitle("一级认证");

            this.getMineInfo();
        },
        methods: {
            //获取我的信息
            getMineInfo() {
                getMineInfo().then(res => {
                    var result = res.data;
                    this.info.realname = result.realname;
                    this.info.idcard = result.idcard;
                    this.info.idcardHidden = this.$commonUtils.plusXing(
                        result.idcard,
                        3,
                        4
                    );
                    this.info.realnameHidden = this.$commonUtils.plusXing(
                        result.realname,
                        1,
                        0
                    );
                });
            },
            //提交我的信息
            postMineInfo() {
                if (this.info.realnameHidden.trim() == "") {
                    wx.toast("请填写真实姓名");
                    return;
                }
                if (this.info.realnameHidden.trim().indexOf("*") == -1) {
                    this.info.realname = this.info.realnameHidden.trim();
                }
                if (
                    this.info.idcardHidden.trim() != "" &&
                    this.info.idcardHidden.indexOf("*") == -1
                ) {
                    if (!this.$commonUtils.checkIdCard(this.info.idcardHidden)) {
                        wx.toast("请填写正确的身份证号");
                        return;
                    }
                    this.info.idcard = this.info.idcardHidden.trim();
                }
                wx.loading("提交中...");
                certificate1(this.info)
                    .then(res => {
                        wx.closeLoading();
                        wx.toast("修改成功");
                        setTimeout(function() {
                            wx.popPage(0);
                        }, 1500);
                    })
                    .catch(err => {
                        wx.closeLoading();
                    });
            }
        }
    };
</script>

<style scoped>


</style>