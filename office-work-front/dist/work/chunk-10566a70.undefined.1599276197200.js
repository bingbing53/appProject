(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["chunk-10566a70"],{"1c40":function(e,t,r){},"41e2":function(e,t,r){"use strict";var s=r("1c40"),n=r.n(s);n.a},b2a8:function(e,t,r){"use strict";r("6a61");var s=r("cf7f"),n=r("8288"),a=function(){var e=Object(s["a"])(regeneratorRuntime.mark((function e(t){var r;return regeneratorRuntime.wrap((function(e){while(1)switch(e.prev=e.next){case 0:return e.next=2,n["a"].get("/api/cube/villageList",{}).then((function(e){r=e}));case 2:return e.abrupt("return",r);case 3:case"end":return e.stop()}}),e)})));return function(t){return e.apply(this,arguments)}}(),i=function(){var e=Object(s["a"])(regeneratorRuntime.mark((function e(t){var r;return regeneratorRuntime.wrap((function(e){while(1)switch(e.prev=e.next){case 0:return e.next=2,n["a"].get("/api/cube/buildingList",{villageId:t}).then((function(e){r=e}));case 2:return e.abrupt("return",r);case 3:case"end":return e.stop()}}),e)})));return function(t){return e.apply(this,arguments)}}(),o=function(){var e=Object(s["a"])(regeneratorRuntime.mark((function e(t){var r;return regeneratorRuntime.wrap((function(e){while(1)switch(e.prev=e.next){case 0:return e.next=2,n["a"].get("/api/cube/housePersonList",{buildingId:t}).then((function(e){r=e}));case 2:return e.abrupt("return",r);case 3:case"end":return e.stop()}}),e)})));return function(t){return e.apply(this,arguments)}}(),u=function(){var e=Object(s["a"])(regeneratorRuntime.mark((function e(t){var r;return regeneratorRuntime.wrap((function(e){while(1)switch(e.prev=e.next){case 0:return e.next=2,n["a"].get("/api/cube/personList",{houseId:t}).then((function(e){r=e}));case 2:return e.abrupt("return",r);case 3:case"end":return e.stop()}}),e)})));return function(t){return e.apply(this,arguments)}}(),c=function(){var e=Object(s["a"])(regeneratorRuntime.mark((function e(t){var r;return regeneratorRuntime.wrap((function(e){while(1)switch(e.prev=e.next){case 0:return e.next=2,n["a"].get("/api/cube/queryHouseInfoById",{houseId:t}).then((function(e){r=e}));case 2:return e.abrupt("return",r);case 3:case"end":return e.stop()}}),e)})));return function(t){return e.apply(this,arguments)}}(),d=function(){var e=Object(s["a"])(regeneratorRuntime.mark((function e(t){var r;return regeneratorRuntime.wrap((function(e){while(1)switch(e.prev=e.next){case 0:return e.next=2,n["a"].post("/api/cube/updateHouse",t).then((function(e){r=e}));case 2:return e.abrupt("return",r);case 3:case"end":return e.stop()}}),e)})));return function(t){return e.apply(this,arguments)}}(),l=function(){var e=Object(s["a"])(regeneratorRuntime.mark((function e(t){var r;return regeneratorRuntime.wrap((function(e){while(1)switch(e.prev=e.next){case 0:return e.next=2,n["a"].post("/api/cube/delHousePerson",{personId:t}).then((function(e){r=e}));case 2:return e.abrupt("return",r);case 3:case"end":return e.stop()}}),e)})));return function(t){return e.apply(this,arguments)}}(),h=function(){var e=Object(s["a"])(regeneratorRuntime.mark((function e(t){var r;return regeneratorRuntime.wrap((function(e){while(1)switch(e.prev=e.next){case 0:return e.next=2,n["a"].post("/api/cube/delPerson",{personId:t}).then((function(e){r=e}));case 2:return e.abrupt("return",r);case 3:case"end":return e.stop()}}),e)})));return function(t){return e.apply(this,arguments)}}(),p=function(){var e=Object(s["a"])(regeneratorRuntime.mark((function e(t){var r;return regeneratorRuntime.wrap((function(e){while(1)switch(e.prev=e.next){case 0:return e.next=2,n["a"].post("/api/cube/updatePersoninfo",t).then((function(e){r=e}));case 2:return e.abrupt("return",r);case 3:case"end":return e.stop()}}),e)})));return function(t){return e.apply(this,arguments)}}(),f=function(){var e=Object(s["a"])(regeneratorRuntime.mark((function e(t){var r;return regeneratorRuntime.wrap((function(e){while(1)switch(e.prev=e.next){case 0:return e.next=2,n["a"].get("/api/cube/searchByNameOrIdCard",{keywords:t}).then((function(e){r=e}));case 2:return e.abrupt("return",r);case 3:case"end":return e.stop()}}),e)})));return function(t){return e.apply(this,arguments)}}();t["a"]={getVilliageList:a,getBuildingList:i,getHousePersonList:o,getPersonList:u,getHouseDetail:c,postHouseDataByHouseId:d,deleteHouseDataByPersonId:l,deletePersonDataByPersonId:h,getPersonData:f,postUpdatePersonInfo:p}},cda5:function(e,t,r){"use strict";r.r(t);var s=function(){var e=this,t=e.$createElement,r=e._self._c||t;return r("div",[r("div",{staticClass:"pd-10"},[r("input",{directives:[{name:"model",rawName:"v-model",value:e.faddress.shequ,expression:"faddress.shequ"}],staticClass:"border_style",staticStyle:{"font-size":"16px",height:"100%","text-indent":"2em"},attrs:{placeholder:"点击选择社区",readonly:""},domProps:{value:e.faddress.shequ},on:{click:e.showPopupShequ,input:function(t){t.target.composing||e.$set(e.faddress,"shequ",t.target.value)}}}),r("br"),r("br"),r("input",{directives:[{name:"model",rawName:"v-model",value:e.faddress.xiaoqu,expression:"faddress.xiaoqu"}],staticClass:"border_style",staticStyle:{"font-size":"16px",height:"100%","text-indent":"2em"},attrs:{placeholder:"点击选择小区",readonly:""},domProps:{value:e.faddress.xiaoqu},on:{click:e.showPopupXiaoqu,input:function(t){t.target.composing||e.$set(e.faddress,"xiaoqu",t.target.value)}}}),r("br"),r("br"),r("input",{directives:[{name:"model",rawName:"v-model",value:e.faddress.louyu,expression:"faddress.louyu"}],staticClass:"border_style",staticStyle:{"font-size":"16px",height:"100%","text-indent":"2em"},attrs:{placeholder:"点击选择楼宇",readonly:""},domProps:{value:e.faddress.louyu},on:{click:e.showPopupLouyu,input:function(t){t.target.composing||e.$set(e.faddress,"louyu",t.target.value)}}}),r("br"),r("div",{staticClass:"pt-10 pb-10 mb-50"},[r("van-row",{attrs:{gutter:"10"}},[r("van-col",{attrs:{span:"9"}},[r("input",{directives:[{name:"model",rawName:"v-model",value:e.address[3].value,expression:"address[3].value"}],staticClass:"border_style",staticStyle:{"font-size":"16px",border:"none",height:"100%"},attrs:{placeholder:"请输入单元号"},domProps:{value:e.address[3].value},on:{input:function(t){t.target.composing||e.$set(e.address[3],"value",t.target.value)}}})]),r("van-col",{staticClass:"pt-10",attrs:{sapn:"3","custom-class":"pt-10 f-16"}},[e._v("单元")]),r("van-col",{attrs:{span:"9"}},[r("input",{directives:[{name:"model",rawName:"v-model",value:e.address[4].value,expression:"address[4].value"}],staticClass:"border_style",staticStyle:{"font-size":"16px",border:"none",height:"100%"},attrs:{placeholder:"请输入房间号"},domProps:{value:e.address[4].value},on:{input:function(t){t.target.composing||e.$set(e.address[4],"value",t.target.value)}}})]),r("van-col",{staticClass:"pt-10",attrs:{sapn:"3","custom-class":"pt-10 f-16"}},[e._v("房间")])],1)],1),r("div",{staticClass:"f-14",staticStyle:{color:"red","margin-bottom":"10px"}},[e._v("     找不到地址请手动填写")]),r("div",[r("input",{directives:[{name:"model",rawName:"v-model",value:e.address[5].value,expression:"address[5].value"}],staticClass:"border_style",staticStyle:{"font-size":"16px",height:"100%"},attrs:{placeholder:"请输入详细地址"},domProps:{value:e.address[5].value},on:{input:function(t){t.target.composing||e.$set(e.address[5],"value",t.target.value)}}})]),r("van-button",{staticClass:"right mt-10",attrs:{type:"info",plain:"",hairline:""},on:{click:e.saveClick}},[e._v("保存")]),r("van-button",{staticClass:"right mt-10",attrs:{type:"info",plain:"",hairline:""},on:{click:e.backClick}},[e._v("取消")])],1),r("van-row",[r("van-action-sheet",{attrs:{title:""},model:{value:e.showPickerS,callback:function(t){e.showPickerS=t},expression:"showPickerS"}},[r("van-picker",{attrs:{"show-toolbar":"",columns:e.address[0].range,"value-key":"itemShequ"},on:{confirm:e.confirmPickerS,cancel:function(t){e.showPickerS=!1}}})],1),r("van-action-sheet",{attrs:{title:""},model:{value:e.showPickerL,callback:function(t){e.showPickerL=t},expression:"showPickerL"}},[r("van-picker",{attrs:{"show-toolbar":"",columns:e.address[2].range,"value-key":"itemLouyu"},on:{confirm:e.confirmPickerL,cancel:function(t){e.showPickerL=!1}}})],1),r("van-action-sheet",{attrs:{title:""},model:{value:e.showPickerX,callback:function(t){e.showPickerX=t},expression:"showPickerX"}},[r("van-picker",{attrs:{"show-toolbar":"",columns:e.address[1].range,"value-key":"itemXiaoqu"},on:{confirm:e.confirmPickerX,cancel:function(t){e.showPickerX=!1}}})],1)],1)],1)},n=[],a=(r("6d57"),r("6a61"),r("cf7f")),i=r("dffc"),o=(r("b2a8"),{data:function(){return{columns:["男","女"],showIndex:0,addressPersonalIndex:-1,communityindex:0,villageindex:0,buildingindex:0,address:[{range:[],list:[]},{range:[],list:[]},{range:[],list:[]},{value:""},{value:""},{value:""},{value:""}],buildIdArray:[],index:0,pos:0,showPicker:!1,showPickerS:!1,showPickerX:!1,showPickerL:!1,showPropertyInfo:!1,faddress:{shequ:"",xiaoqu:"",louyu:""},newIndex:1,houseIndex:1}},methods:{showPopupShequ:function(){this.showPickerS=!0},showPopupXiaoqu:function(){this.showPickerX=!0},showPopupLouyu:function(){this.showPickerL=!0},showPopup:function(e){this.showPicker=!0,this.newIndex=e},showPopupProperty:function(e){this.showPropertyInfo=!0,this.houseIndex=e},pickShequ:function(e,t,r){console.log(e),console.log(t),console.log(r),this.faddress.shequ=e,this.address[t].value=r,t<2&&this.getAddressList(t),this.showPickerS=!1},pickXiaoqu:function(e,t,r){this.faddress.xiaoqu=e,this.address[1].value=r,this.getAddressList(t),this.showPickerX=!1},pickLouyu:function(e,t,r){this.faddress.louyu=e,this.address[2].value=r,this.showPickerL=!1},pickPropertyInfo:function(e,t,r,s){this.houseInfo[r].value=e,this.houseInfo[r].code=t,this.showPropertyInfo=!1},onCancel:function(){this.show=!1},onConfirm:function(e,t,r){this.show=!1},ShowPUP:function(){this.show=!0},getAddressList:function(){var e=Object(a["a"])(regeneratorRuntime.mark((function e(t){var r,s,n;return regeneratorRuntime.wrap((function(e){while(1)switch(e.prev=e.next){case 0:if(r=this,s="",!(0===t&&this.address[0].list.length>0)){e.next=9;break}if(t+=1,s=this.address[0].list[this.address[0].value].org_code,""!==s){e.next=7;break}return e.abrupt("return");case 7:e.next=14;break;case 9:if(!(1===t&&this.address[1].list.length>0)){e.next=14;break}if(t+=1,s=this.address[1].list[this.address[1].value].id,""!==s){e.next=14;break}return e.abrupt("return");case 14:return e.next=16,i["a"].getAddressList(t,s);case 16:n=e.sent,n=JSON.parse(n),console.log(n),r.address[t].list=n,r.address[t].range=[],r.address[t].list.forEach((function(e,s){0===t?r.address[t].range.push(e.departname):1===t?r.address[t].range.push(e.village_name):2===t&&(r.address[t].range.push(e.building_name),console.log("item",e),r.buildIdArray.push(e.id))})),console.log("finish!!!!",r.address[2].range);case 23:case"end":return e.stop()}}),e,this)})));function t(t){return e.apply(this,arguments)}return t}(),saveClick:function(){for(var e=this,t=[],r="",s=0;s<6;s++)if(t.push(e.address[s].value),s<3)null!=e.address[s].value&&(r+=e.address[s].range[e.address[s].value]);else if(null!=e.address[s].value&&""!=e.address[s].value)switch(s){case 3:r=r+e.address[s].value+"单元";break;case 4:r=r+e.address[s].value+"房间";break;case 5:r+=e.address[s].value,window.localStorage.setItem("address",e.address[s].value);break}t[2]=this.buildIdArray[2],console.log(this.buildIdArray,"this.buildArray"),console.log(this.address,"this.address"),console.log(r,"address_str"),console.log(t,"address_arrdatas"),window.localStorage.setItem("address_arrdatas",JSON.stringify(t)),window.localStorage.setItem("address_strs",r),window.localStorage.setItem("isback",!0),this.$router.push({path:"personaldetail",query:{idcard:this.$route.query.idcard}})},backClick:function(){this.$router.go(-1)},confirmPickerS:function(e){var t=0;for(var r in this.address[0].range)if(this.address[0].range[r]==e){t=r;break}var s=e;this.pickShequ(s,0,t)},confirmPickerX:function(e){var t=0;for(var r in this.address[1].range)if(this.address[1].range[r]==e){t=r;break}this.pickXiaoqu(e,1,t)},confirmPickerL:function(e){var t=0;for(var r in this.address[2].range)if(this.address[2].range[r]==e){t=r;break}this.pickLouyu(e,2,t)}},mounted:function(){console.log(this.$route.query.idcard,"mountedthis.$route.query.idcard"),this.index=this.$route.query.index,this.pos=this.$route.query.fieldsIndex,this.address=[{range:[],list:[]},{range:[],list:[]},{range:[],list:[]},{value:""},{value:""},{value:""},{value:""}],this.getAddressList(0)}}),u=o,c=(r("41e2"),r("9ca4")),d=Object(c["a"])(u,s,n,!1,null,"094f8611",null);t["default"]=d.exports}}]);