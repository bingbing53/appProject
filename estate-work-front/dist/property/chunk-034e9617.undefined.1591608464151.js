(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["chunk-034e9617"],{"0384":function(e,s,t){"use strict";var a=t("fa15"),i=t.n(a);i.a},"8e65":function(e,s,t){"use strict";t.r(s);var a=function(){var e=this,s=e.$createElement,t=e._self._c||s;return t("div",[t("div",{staticClass:"pd-10"},[t("input",{directives:[{name:"model",rawName:"v-model",value:e.faddress.shequ,expression:"faddress.shequ"}],staticClass:"border_style",staticStyle:{"font-size":"16px",height:"100%","text-indent":"2em"},attrs:{placeholder:"点击选择社区",readonly:""},domProps:{value:e.faddress.shequ},on:{click:e.showPopupShequ,input:function(s){s.target.composing||e.$set(e.faddress,"shequ",s.target.value)}}}),t("br"),t("van-popup",{style:{height:"100%"},attrs:{position:"right"},model:{value:e.showPickerS,callback:function(s){e.showPickerS=s},expression:"showPickerS"}},[t("div",{staticClass:"popOut"},[t("div",{staticClass:"popInner"},e._l(e.address[0].range,(function(s,a){return t("div",[t("span",{staticClass:"select_item",on:{click:function(t){return e.pickShequ(s,0,a)}}},[e._v(e._s(s))])])})),0)])]),t("br"),t("input",{directives:[{name:"model",rawName:"v-model",value:e.faddress.xiaoqu,expression:"faddress.xiaoqu"}],staticClass:"border_style",staticStyle:{"font-size":"16px",height:"100%","text-indent":"2em"},attrs:{placeholder:"点击选择小区",readonly:""},domProps:{value:e.faddress.xiaoqu},on:{click:e.showPopupXiaoqu,input:function(s){s.target.composing||e.$set(e.faddress,"xiaoqu",s.target.value)}}}),t("br"),t("van-popup",{style:{height:"100%"},attrs:{position:"right","lazy-render":"true"},model:{value:e.showPickerX,callback:function(s){e.showPickerX=s},expression:"showPickerX"}},[t("div",{staticClass:"popOut"},[t("div",{staticClass:"popInner"},e._l(e.address[1].range,(function(s,a){return t("div",[t("span",{staticClass:"select_item",on:{click:function(t){return e.pickXiaoqu(s,1,a)}}},[e._v(e._s(s))])])})),0)])]),t("br"),t("input",{directives:[{name:"model",rawName:"v-model",value:e.faddress.louyu,expression:"faddress.louyu"}],staticClass:"border_style",staticStyle:{"font-size":"16px",height:"100%","text-indent":"2em"},attrs:{placeholder:"点击选择楼宇",readonly:""},domProps:{value:e.faddress.louyu},on:{click:e.showPopupLouyu,input:function(s){s.target.composing||e.$set(e.faddress,"louyu",s.target.value)}}}),t("br"),t("van-popup",{style:{height:"100%"},attrs:{position:"right","lazy-render":"true"},model:{value:e.showPickerL,callback:function(s){e.showPickerL=s},expression:"showPickerL"}},[t("div",{staticClass:"popOut"},[t("div",{staticClass:"popInner"},e._l(e.address[2].range,(function(s,a){return t("div",[t("span",{staticClass:"select_item",on:{click:function(t){return e.pickLouyu(s,1,a)}}},[e._v(e._s(s))])])})),0)])]),t("br"),t("div",{staticClass:"pt-10 pb-10 mb-50"},[t("van-row",{attrs:{gutter:"10"}},[t("van-col",{attrs:{span:"9"}},[t("input",{directives:[{name:"model",rawName:"v-model",value:e.address[3].value,expression:"address[3].value"}],staticClass:"border_style",staticStyle:{"font-size":"16px",border:"none",height:"100%"},attrs:{placeholder:"请输入单元号"},domProps:{value:e.address[3].value},on:{input:function(s){s.target.composing||e.$set(e.address[3],"value",s.target.value)}}})]),t("van-col",{staticClass:"pt-10",attrs:{sapn:"3","custom-class":"pt-10 f-16"}},[e._v("单元")]),t("van-col",{attrs:{span:"9"}},[t("input",{directives:[{name:"model",rawName:"v-model",value:e.address[4].value,expression:"address[4].value"}],staticClass:"border_style",staticStyle:{"font-size":"16px",border:"none",height:"100%"},attrs:{placeholder:"请输入房间号"},domProps:{value:e.address[4].value},on:{input:function(s){s.target.composing||e.$set(e.address[4],"value",s.target.value)}}})]),t("van-col",{staticClass:"pt-10",attrs:{sapn:"3","custom-class":"pt-10 f-16"}},[e._v("房间")])],1)],1),t("div",{staticClass:"f-14",staticStyle:{color:"red","margin-bottom":"10px"}},[e._v("     找不到地址请手动填写")]),t("div",[t("input",{directives:[{name:"model",rawName:"v-model",value:e.address[5].value,expression:"address[5].value"}],staticClass:"border_style",staticStyle:{"font-size":"16px",height:"100%"},attrs:{placeholder:"请输入详细地址"},domProps:{value:e.address[5].value},on:{input:function(s){s.target.composing||e.$set(e.address[5],"value",s.target.value)}}})]),t("van-button",{staticClass:"right mt-10",attrs:{type:"info",plain:"",hairline:""},on:{click:e.saveClick}},[e._v("保存")])],1)])},i=[],r=(t("ac6a"),t("96cf"),t("1da1")),o=t("dffc"),n={data:function(){return{columns:["男","女"],showIndex:0,addressPersonalIndex:-1,communityindex:0,villageindex:0,buildingindex:0,address:[{range:[],list:[]},{range:[],list:[]},{range:[],list:[]},{value:""},{value:""},{value:""},{value:""}],index:0,pos:0,showPicker:!1,showPickerS:!1,showPickerX:!1,showPickerL:!1,showPropertyInfo:!1,faddress:{shequ:"",xiaoqu:"",louyu:""},newIndex:1,houseIndex:1}},methods:{showPopupShequ:function(){this.showPickerS=!0},showPopupXiaoqu:function(){this.showPickerX=!0},showPopupLouyu:function(){this.showPickerL=!0},showPopup:function(e){this.showPicker=!0,this.newIndex=e},showPopupProperty:function(e){this.showPropertyInfo=!0,this.houseIndex=e},pickShequ:function(e,s,t){alert(22),this.faddress.shequ=e,this.address[s].value=t,s<2&&this.getAddressList(s),this.showPickerS=!1},pickXiaoqu:function(e,s,t){this.faddress.xiaoqu=e,this.address[1].value=t,this.getAddressList(s),this.showPickerX=!1},pickLouyu:function(e,s,t){this.faddress.louyu=e,this.address[2].value=t,this.getAddressList(s),this.showPickerL=!1},pickPropertyInfo:function(e,s,t,a){this.houseInfo[t].value=e,this.houseInfo[t].code=s,this.showPropertyInfo=!1},onCancel:function(){this.show=!1},onConfirm:function(e,s,t){this.show=!1},ShowPUP:function(){this.show=!0},getAddressList:function(){var e=Object(r["a"])(regeneratorRuntime.mark((function e(s){var t,a,i;return regeneratorRuntime.wrap((function(e){while(1)switch(e.prev=e.next){case 0:if(t=this,a="",!(0===s&&this.address[0].list.length>0)){e.next=9;break}if(s+=1,a=this.address[0].list[this.address[0].value].org_code,""!==a){e.next=7;break}return e.abrupt("return");case 7:e.next=14;break;case 9:if(!(1===s&&this.address[1].list.length>0)){e.next=14;break}if(s+=1,a=this.address[1].list[this.address[1].value].id,""!==a){e.next=14;break}return e.abrupt("return");case 14:return e.next=16,o["a"].getAddressList(s,a);case 16:i=e.sent,i=JSON.parse(i),console.log(i),t.address[s].list=i,t.address[s].range=[],t.address[s].list.forEach((function(e,a){0===s?t.address[s].range.push(e.departname):1===s?t.address[s].range.push(e.village_name):2===s&&t.address[s].range.push(e.building_name)}));case 22:case"end":return e.stop()}}),e,this)})));function s(s){return e.apply(this,arguments)}return s}(),saveClick:function(){for(var e=this,s=[],t=0;t<6;t++)s.push(e.address[t].value);console.log(JSON.stringify(s)),window.localStorage.setItem("address_arrdata",s),this.$router.go(-1)}},mounted:function(){this.index=this.$route.query.index,this.pos=this.$route.query.fieldsIndex,this.address=[{range:[],list:[]},{range:[],list:[]},{range:[],list:[]},{value:""},{value:""},{value:""},{value:""}],this.getAddressList(0)}},d=n,u=(t("0384"),t("0c7c")),l=Object(u["a"])(d,a,i,!1,null,"4607c326",null);s["default"]=l.exports},fa15:function(e,s,t){}}]);