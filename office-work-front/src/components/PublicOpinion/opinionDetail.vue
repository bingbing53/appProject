<template>
<div>
    <div class="bgcw2 pd-10">
        <p class="Wline Bline pb-10 pt-10 f-b sort_view">
        <span class="blueLeftline">I</span> 第一步：选择民意分类
        </p>
        <div class="pd-10">
        <div class="Bline pb-10 pt-5" v-for="(item,index) in category" :key="index">
            <div class="pb-5 pt-5 mb-10 c-666 f-16">{{item.name}}</div>
            <van-row gutter="5">
            <van-col
                v-for="(item2,index2) in categotyList"
                :key="index2"
                :span="8"
                v-if="item.code === item2.PARENT_CODE"
            >
                <div
                class="bage mb-10"
                :class="[bage.pos === index2 ? 'bageClick bage' : 'bage', '']"
                v-if="item.code === item2.PARENT_CODE"
                @click="bageClick(index2,item2)"
                >{{item2.name}}</div>
            </van-col>
            </van-row>
        </div>
        </div>
        <div class="bgcy"></div>
        <p class="Wline Bline pb-10 pt-10 f-b sort_view">
        <span class="blueLeftline">I</span> 第二步：输入民意标题
        </p>
        <div class="pd-10 pb-10 f-14">
        <van-field
            maxlength="100"
            placeholder="输入民意标题内容"
            v-model="form.title"
        />
        </div>
        <div class="bgcy"></div>
        <p class="Wline Bline pb-10 pt-10 f-b sort_view">
        <span class="blueLeftline">I</span> 第三步：录入民意内容
        </p>
        <div class="pd-10 f-14">
        <van-field
            type="textarea"
            maxlength="100"
            placeholder="请输入录入民意内容"
            v-model="form.content"
        />
        <br />
        <van-uploader :after-read="afterRead" v-model="fileList" @delete="delimage" multiple class="pl-10" />
        </div>
         <div class="bgcy"></div>
        <p class="Wline Bline pb-10 pt-10 f-b sort_view">
            <span class="blueLeftline">I</span> 第四步：建议措施
        </p>
        <div class="pd-10 pb-10 f-14">
        <van-field
            maxlength="1000"
            type="textarea"
            placeholder="请输入建议措施"
            v-model="form.suggest"
        />
        </div>

        <div class="bgcy"></div>
        <p class="Wline Bline pb-10 pt-10 f-b sort_view">
        <span class="blueLeftline">I</span> 第五步：民意来源
        </p>
        <div class="pd-10 f-14">
        <van-row gutter="5">
            <van-col span="19" class="mb-10">
            <van-field 
                class="border_style"
                maxlength="30"
                placeholder="身份证号（选填）"
                v-model="form.idcard"
            />
            </van-col>
            <van-col span="5" class="mt-5">
            <van-button type="info" size="small" @click="searchPerson" class="b-blue">搜 索</van-button>
            </van-col>
        </van-row>
        <van-row gutter="5">
            <van-col span="24" class="mb-10">
            <van-field 
                class="border_style "
                maxlength="30"
                placeholder="姓名（必填）"
               error
                v-model="form.username"
            />
            </van-col>
            <van-col span="24" class="mb-10">
            <van-field 
                class="border_style "
                maxlength="30"
                placeholder="手机号（必填）"
                error
                v-model="form.mobile"
            />
            </van-col>
            <van-col span="24" class="mb-10">
            <van-field 
                class="border_style"
                maxlength="200"
                placeholder="居住地址（选填）"
                v-model="form.address"
            />
            </van-col>
        </van-row>
        </div>
        <div class="text-c pd-10" style="border-radius:10px">
        <van-button
            class="van_button_my"
            size="large"
            type="info"
            @click="saveForm"
        >提交民意</van-button>
        </div>
    </div>
</div>
</template>
<script>
import detail from "@/api/PublicOpinion/PublicOpinion";
import { Dialog } from "vant";
import { Toast } from "vant"; 
import { setTimeout } from 'timers';
export default {
    data(){
        return{
            bage: {pos: -1, item: {} },
            files: [],
            fileList: [],
            newimageArr: [],
            category:[],
            form: {
                title: "",
                idcard: "",
                mobile: "",
                address: "",
                content: "",
                username: "",
                suggest:"",
                image:[],
                iamgeArr:[]
            },
            id:"",

        }
    },
    methods:{
    async getWill() {
            let _this = this;
            let res = await detail.getWillCategoryList();
            // console.log("页面："+res);
            res = JSON.parse(res);
            this.category = [];
            this.categotyList = [];
            res.forEach(function(item, index) {
                if (item.code.length === 6) {
                _this.category.push(item);
                } else {
                _this.categotyList.push(item);
                }
            });
            },
        
        afterRead(file) {
            let _this = this;
            // _this.newimageArr = [];
            // this.fileList.forEach(function(item, index) {
            if(file.file.size >= 1500000){
                let c = _this.common.reduceImage(file,function(data){
                _this.newimageArr.push(data);
                });
            }else{
                _this.newimageArr.push(file.content);
            }
            // });
        },
        delimage(file){
            let _this = this;
             this.newimageArr.forEach(function(item,index){
                if(item == file.content){
                    _this.newimageArr.splice(index,1)
                }
            })

            this.form.image.forEach(function(item,index){
                item = _this.common.showPicture(item);
                if(item == file.content){
                    _this.form.image.splice(index,1)
                }
            })

        },
        bageClick(index,item) {
            this.bage.pos = index;
            this.bage.item = item;
        },
          //根据身份证号搜索居民信息
       async searchPerson() {
        if (!detail.checkIdCard(this.form.idcard)) {
            Dialog({ message: "请输入正确的身份证号" });
            return;
        }
        let resdata = await detail.searchPersonID({ idcard: this.form.idcard });
        resdata = JSON.parse(resdata)
        // return;
        if (resdata.length > 0) {
            this.form.username = resdata[0].personName;
            this.form.mobile = resdata[0].mobilePhone;
            this.form.address = resdata[0].presentDetailAddr1;
        } else {
            Dialog({ message: "未查询到此身份证信息，请手动填写" });
        }
        },
    //检查form表单
        async saveForm() {
        let _this = this;
        this.form.will_type = this.bage.item.code;
        if (this.form.will_type== undefined || this.form.will_type == null) {
            Dialog({ message: "请选择民意分类" });
            return;
        }

        if (this.form.title.trim() == "") {
            Dialog({ message: "请输入民意标题" });
            return;
        }
        if (this.form.content.trim() == "") {
            Dialog({ message: "请输入民意内容" });
            return;
        }
        if (this.form.username.trim() == "") {
            Dialog({ message: "请输入居民姓名" });
            return;
        }
        if (this.form.mobile.trim() == "") {
            Dialog({ message: "请输入居民手机号" });
            return;
        }
        if(!this.common.checkPhone(this.form.mobile.trim())){
              Dialog({ message: '请输入正确的手机号' });
            return;
        }
        if (this.newimageArr.length <= 0) {
            this.form.image = JSON.stringify(this.form.image);
            // console.log(this.newimageArr.length)
            this.formSubmit();
        } else {
            let i= this.newimageArr.length;
            while(i--) {
            　　if (this.newimageArr[i].substring(0, 4)== "http") {
                    this.newimageArr.splice(i, 1);
            　　}
            }
            // return;
            // console.log(JSON.stringify(this.newimageArr))
            let resimgarr = await detail.uploadImage(this.newimageArr);
            resimgarr = JSON.parse(resimgarr);
            // console.log(this.form.image)
            resimgarr.forEach(function(item,index){
                _this.form.image.push(item.url)
            })
            this.form.image = JSON.stringify(this.form.image);
            this.formSubmit();
        }
        },
        async formSubmit() {
        // console.log(JSON.stringify(this.form));
        // return;
         await detail.submitForm(this.form);
            Toast.success({
                    message:"提交成功",
                    position:"bottom",
                    duration:1000
                })
            this.form = {
                title: "",
                idcard: "",
                mobile: "",
                address: "",
                content: "",
                username: "",
                image: ""
            };
            this.images = [];
            this.bage = {};
            this.fileList = [];
            this.$router.go(-1)
        },
       async getDetail(id){
           let _this = this;
           let res = await detail.getMyopinionDetail(id);
            res = JSON.parse(res);
            this.categotyList.forEach(function(item, index) {
                if (item.code === res.willType) {
                    _this.bage.pos = index;
                    _this.bage.item = item;
                }
            });
           
             if(res.image == "[]"){
               console.log(12344)
                this.form = res;
                res.image = [];

            }else if(res.image == null){
                console.log(JSON.stringify(res))
                 this.form = res;
                res.image = [];
               
            }else{
                 res.image = JSON.parse(res.image);
               let iamgeArr = [];
                   for(let i in res.image){
                      iamgeArr.push(res.image[i]) 
                   }
                if (iamgeArr.length > 0) {
                    iamgeArr.forEach(function(item, index) {
                        iamgeArr[index] = _this.common.showPicture( iamgeArr[index]);
                        _this.fileList.push({ content:iamgeArr[index], file: {} });
                    });
                    this.form = res;
                    this.form.iamgeArr = iamgeArr
                }
            }
            
        }
    },
    mounted(){
        let id = this.$route.query.id;
        this.getWill();
        let _this = this;
        setTimeout( function(){
            if(id){
            _this.getDetail(id);
            }
        },600)
      
    }
}
</script>
<style scoped>
.bage {
  border-radius: 15px;
  border: solid 1px #eee;
  padding: 0.8vw;
  /* margin-bottom: 1.33vw; */
  text-align: center;
  font-size: 3.4666vw;
}
.bageClick {
  background: #3396fb;
  color: #fff;
  text-align: center;
}
 .required::-webkit-input-placeholder{
    color: #f44;
    }

</style>


