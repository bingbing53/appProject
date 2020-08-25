<template>
  <f7-page class="bgcw car">
    <van-nav-bar class="myNavBare" title="购物车" left-arrow @click-left="shoppClickLeft" />
    <div class="bgcg mine carInner">
      <template v-if="list.length <= 0  || showEmpty">
        <div class="bgcg">
          <div class="f-100 c-e6 pt-150 tc bgcg" style="height:100%">
            <span>
              <van-icon name="ellipsis" class="v_bottom f-60" />
              <van-icon name="shopping-cart-o" class="top" />
              <van-icon name="ellipsis" class="v_bottom f-60" />
            </span>
          </div>
          <div class="bgcg tc mt-50">
            <p class="c-ccc mb-20">购物车还是空空的呢~</p>
            <van-button
              type="danger"
              size="small"
              round
              style="width:100px"
              class="mt-10"
              @click="goHome"
            >去逛逛</van-button>
          </div>
        </div>
      </template>
      <template v-else>
        <div v-for="(nape,pos) in list" class="broder_b mb-20 bgcw border-radius8">
          <p class="pd-10" @click="enterStore(nape.sysOrgCode)">
            <van-icon name="shop-o" class="ml-10 v_middle f-18" />
            <b class="ml-10 v_middle">{{nape.sysCompanyName}}</b>
            <van-icon name="arrow" class="ml-5 v_middle f-16" />
          </p>
          <van-checkbox
            class="card-goods__item"
            v-for="(item,index) in nape.cartItemList"
            :key="index"
            :name="item"
            v-model="item.isChecked"
            @change="changeItem(item.isChecked,item,index,pos)"
          >
            <div>
              <van-card
                class="borderScale myskuStyle"
                :price="item.price+'.00'"
                :desc="skuFun(item.sp1,item.sp2,item.sp3)"
                :title="item.productName"
                :thumb="formatImage(item.productPic)"
              >
                <div slot="bottom" class="fr f-20">
                  <!-- <van-stepper
                  v-model="item.quantity"
                  disable-input
                  @plus="addFun(item.id,index,pos)"
                  @minus="jian(index,pos)"
                  />-->
                  <van-button
                    class="inlineBlock mybutton mr-5"
                    size="mini"
                    @click.stop="jian($event,item.id,index,pos,item.sysCompanyCode)"
                  >-</van-button>
                  <span class="f-14 inlineBlock">{{item.quantity}}</span>
                  <van-button
                    class="inlineBlock mybutton ml-5"
                    size="mini"
                    @click.stop="addFun(item.id,index,pos,item.sysCompanyCode)"
                  >+</van-button>
                </div>
              </van-card>
            </div>

            <van-button
              icon="delete"
              type="default"
              size="mini"
              class="delButton"
              @click.stop="remove($event,index,pos,item.sysCompanyCode)"
            ></van-button>
          </van-checkbox>
          <!-- </van-checkbox-group> -->
          <!-- {{nape.isChose}} -->
          <van-submit-bar
            class="myBar border-radius8"
            :price="priceDuc(nape.priceAll)"
            :disabled="!nape.isChose"
            button-text="结算"
            @submit="onSubmit(nape.sysCompanyCode,pos)"
          ></van-submit-bar>
        </div>
      </template>
    </div>
  </f7-page>
</template>

<script>
import { Dialog, Toast } from "vant";
import {
  getCartList,
  getCartDetail,
  cAmountCar,
  cutCar,
  addCar,
  delCar
} from "@/api/api_mall.js";
export default {
  data() {
    return {
      showEmpty: false,
      list: [],
      sysCompanyCodeSign: "",
      checked: false,
      panduan: true,
      midprc: "",
      totalPrice: 0,
      num: 0,
      itemCode: ""
    };
  },
  methods: {
    goHome() {
      wx.popPage();
    },
    shoppClickLeft() {
      // console.log(this.GLOBAL.detailGoodsId)
      wx.goBack();
      // this.$f7router.back("", {
      //   animate: true,
      //   pushState: false,
      //   ignoreCache: true,
      // });
      // wx.popPage();
      let carLen = 0;
      this.list.forEach((item, index) => {
        carLen += item.cartItemList.length;
      });
      this.GLOBAL.carNumber = carLen;
    },
    changeItem(checked, e, index, pos) {
      let codeSign = "";
      this.list[pos].cartItemList.forEach((item, idx) => {
        if (item.isChecked) {
          codeSign += item.productSkuCode + ",";
        }
      });
      codeSign = codeSign.substring(0, codeSign.length - 1);
      if (codeSign != "") {
        this.toCAmount("pos", codeSign, e.sysCompanyCode).then(res => {
          console.log(res);
          if (res.data.code == 200) {
            this.list[pos].priceAll = res.data.data.payAmount;
            this.list[pos].isChose = true;
          }
        });
      } else {
        this.list[pos].priceAll = 0;
        this.list[pos].isChose = false;
      }
    },
    //显示规格
    skuFun(sp1, sp2, sp3) {
      if (sp1 && sp2 && sp3) {
        return "已选：" + sp1 + " , " + sp2 + " , " + sp3 + " 规格";
      } else if (sp1 && sp2 && sp3 == null) {
        return "已选：" + sp1 + " , " + sp2 + " 规格";
      }
    },
    enterStore(sysCompanyCode) {
      this.$f7router.navigate(`/enter-store/${sysCompanyCode}/`);
    },
    //格式化图片路径
    formatImage(url) {
      return this.$commonUtils.formatPicture(url);
    },
    priceDuc(price) {
      return price * 100;
    },
    onSubmit(sysCompanyCode, nape) {
      console.log(typeof nape);
      this.GLOBAL.carJsonList = [];
      this.list[nape].cartItemList.forEach((item, index) => {
        if (item.isChecked) {
          this.GLOBAL.carJsonList.push(item);
        }
      });
      // return
      this.$f7router.navigate(`/toConfirmOrders/forceClose/`);
    },
    remove(e, a, p, sysCompanyCode) {
      let _this = this;
      Dialog.confirm({
        title: "确定删除?"
      })
        .then(() => {
          this.shanchu(e, a, p, sysCompanyCode);
        })
        .catch(() => {
          // on cancel
        });
    },
    addFun(id, a, p, sysCompanyCode) {
      this.num = p;
      let codes = "";
      addCar({ cartItemId: id })
        .then(res => {
          if (res.data.code == 501) {
            Toast(res.data.message);
          } else {
            this.list[p].cartItemList[a].quantity++;
            if (this.list[p].cartItemList[a].isChecked) {
              //被选中时
              console.log("选中时。。。");
              this.list[p].cartItemList.forEach((item, index) => {
                if (item.isChecked) {
                  codes += item.productSkuCode + ",";
                }
              });
              codes = codes.substring(0, codes.length - 1);
              this.toCAmount(p, codes, sysCompanyCode);
            } else {
              //未被选中
              console.log("未被选中时。。。");
            }
          }
        })
        .catch(err => {});
    },
    jian(event, id, a, p, sysCompanyCode) {
      this.num = p;
      let codes = "";
      if (this.list[p].cartItemList[a].quantity == 1) {
        event.stopPropagation();
      }
      if (this.list[p].cartItemList[a].quantity == 1) {
        this.list[p].cartItemList[a].quantity = 1;
        Toast("请至少选择一件商品");
      } else {
        this.list[p].cartItemList[a].quantity--;
        cutCar({ cartItemId: id })
          .then(res => {
            if (this.list[p].cartItemList[a].isChecked) {
              //选中的时候
              console.log("选中时");
              this.list[p].cartItemList.forEach((item, index) => {
                if (item.isChecked) {
                  codes += item.productSkuCode + ",";
                }
              });
              codes = codes.substring(0, codes.length - 1);
              this.toCAmount(p, codes, sysCompanyCode);
            } else {
              //未被选中
              console.log("未被选中");
            }
          })
          .catch(err => {});
      }
    },
    shanchu(e, a, p, sysCompanyCode) {
      let codes = "";
      delCar({ cartItemId: this.list[p].cartItemList[a].id })
        .then(res => {
          this.GLOBAL.carFlag = true;
          this.getCarLength();
          if (this.list[p].cartItemList.length == 1) {
            this.list.splice(p, 1);
          } else {
            this.list[p].cartItemList.splice(a, 1);
          }
          this.list[p].cartItemList.forEach((item, index) => {
            if (item.isChecked) {
              codes += item.productSkuCode + ",";
            }
          });
          codes = codes.substring(0, codes.length - 1);
          if (codes != "") {
            this.toCAmount(p, codes, sysCompanyCode);
          } else {
          }
        })
        .catch(err => {});
    },
    getCarLength() {
      let carLen = 0;
      getCartList()
        .then(res => {
          res.data.data.forEach((item, index) => {
            carLen += item.cartItemList.length;
          });
          this.GLOBAL.carNumber = carLen;
          this.$forceUpdate();
        })
        .catch(err => {});
    },
    //计算金额
    async toCAmount(number, code, sysCompanyCode) {
      let _this = this;
      let param = {
        sysCompanyCode: sysCompanyCode,
        productSkuCodeList: code,
        couponHistoryId: "",
        useCoinProductSkuCodeList: ""
      };
      let res = await cAmountCar(param);
      if (number == "pos") {
        return res;
      } else {
        this.list[number].priceAll = res.data.data.payAmount;
      }
    },
    //获取购物车数据
    getlist() {
      let _this = this;
      this.showEmpty = false;
      getCartList()
        .then(res => {
          if (res.data.data.length > 0) {
            this.showEmpty = false;
            res.data.data.forEach((item, index) => {
              let sysCompanyCodeJson = {
                sysCompanyCode: item.sysCompanyCode
              };
              item.priceAll = 0;
              item.count = 0;
              item.cartItemList.forEach((nape, pos) => {
                nape.isChecked = false;
              });
            });
            this.list = res.data.data;
          } else {
            setTimeout(function() {
              _this.showEmpty = true;
            }, 800);
          }
        })
        .catch(err => {});
    }
  },
  mounted() {
    this.getlist();
    this.showEmpty = false;
  }
};
</script>

<style>
.mybutton {
  width: 36px;
  height: 26px;
  line-height: 26px;
  border: none;
  background: #f2f3f5;
}
.van-card {
  background: #ffffff;
  padding: 8px 20px;
}
.van-card__desc {
  width: 60vw;
  height: 30vw;
}
.card-goods {
  padding: 0;
  background-color: #fff;
  margin-bottom: 10px;
}
.card-goods__item {
  position: relative;
  background-color: #fafafa;
}
.van-checkbox__label {
  width: 100%;
  height: auto;
  padding: 0 10px 0 15px;
  box-sizing: border-box;
  background: #fff;
  margin-left: 0px;
}
.van-checkbox__icon {
  top: 40%;
  left: 10px;
  z-index: 1;
  position: absolute;
  margin-top: -10px;
}
.van-card__price {
  color: #ee0a24;
  height: 4vh;
  min-width: 50px;
  font-size: 16px;
  line-height: 4vh;
  text-align: center;
}
.card-goods__item {
  margin-bottom: 10px;
}
.van-card__title {
  height: 10vh;
  line-height: 4vh;
  font-size: 16px;
  font-weight: bold;
}
.van-button--mini {
  min-width: 30px;
  font-size: 20px;
}
.disButton {
  display: inline-block;
  width: 20px;
}
.delButton {
  width: 40px;
  color: #333;
  font-size: 14px;
  background-color: transparent;
  border: none;
  position: absolute;
  top: 10px;
  right: 10px;
}
.myBar {
  position: static !important;
}
.myBar .van-submit-bar__button {
  width: 100px;
  height: 40px;
  line-height: 40px;
  border-radius: 20px;
  font-weight: bold;
  font-size: 14px;
}
.van-image img {
  border-radius: 3px;
}
.van-card__thumb {
  width: 80px;
  height: 80px;
}
.myskuStyle .van-card__price-currency {
  font-size: 12px;
}
.myskuStyle .van-card__title {
  max-height: 58px !important;
}
.myskuStyle .van-card__price-decimal {
  font-size: 12px;
}

.car .page-content {
  display: flex;
  flex-direction: column;
  min-height: 100%;
}
.carInner{
  padding-top: 0px !important;
}
</style>