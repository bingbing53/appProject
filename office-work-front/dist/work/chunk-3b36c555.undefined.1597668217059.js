(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["chunk-3b36c555"],{"2df9":function(t,e,a){"use strict";var s=a("a9091"),i=a.n(s);i.a},"74cd":function(t,e,a){"use strict";a.r(e);var s=function(){var t=this,e=t.$createElement,a=t._self._c||e;return a("div",[a("div",{staticClass:"pt-10 text-c f-16 pb-10 bgcw2"},[t._v("\n      "+t._s(t.title)+" 历史记录详情\n  ")]),t.addressArr.length>0||t.houseArr.length>0?a("div",{staticClass:"bgcw2"},[t._m(0),a("div",{staticClass:"Bline"})]):t._e(),t.addressArr.length>0?a("div",{staticClass:"pd-10 bgcw2"},[t._v("\n    房屋地址：\n    "),t._l(t.addressArr,function(e){return a("span",[t._v("\n      "+t._s(e.value)),"commNo-"===e.name?a("span",{staticStyle:{color:"#999","font-size":"11px"}},[t._v("社区")]):t._e(),"villageNo-"===e.name?a("span",{staticStyle:{color:"#999","font-size":"11px"}},[t._v("小区")]):t._e(),"buildingNo-"===e.name?a("span",{staticStyle:{color:"#999","font-size":"11px"}},[t._v("楼")]):t._e(),"unitNo-"===e.name?a("span",{staticStyle:{color:"#999","font-size":"11px"}},[t._v("单元")]):t._e(),"houseNo-"===e.name?a("span",{staticStyle:{color:"#999","font-size":"11px"}},[t._v("房间")]):t._e()])})],2):t._e(),t.houseArr.length>0?a("div",{staticClass:"pd-10 bgcw2"},t._l(t.houseArr,function(e){return a("div",[t._v("\n      "+t._s(e.label)+"："+t._s(e.value)+"\n    ")])}),0):t._e(),t._l(t.resultData,function(e,s){return a("div",{key:s,staticClass:"bgcw2"},[a("div",{staticClass:"bgcy pt-10"}),a("div",[a("h5",{staticClass:"pt-10 pb-10"},[a("p",{staticClass:"Wline  pb-10 pt-10 sort_view pl-10"},[a("span",{staticClass:"blueLeftline f-b mr-5"},[t._v("I")]),a("span",[t._v("调查人详情（成员"+t._s(s+1)+"）")])])])]),t.headArr.length>0?a("div",{staticClass:"text-c"},[a("img",{staticStyle:{width:"40%"},attrs:{src:t.headArr[s].value,mode:"widthFix"}})]):t._e(),a("van-cell-group",t._l(e,function(t,e){return a("div",{key:e},[a("van-cell",{attrs:{title:t.label,value:t.value}})],1)}),0),void 0!=t.sign[s]?a("div",{staticClass:"text-r pt-10 pr-10"},[a("img",{staticStyle:{width:"40%"},attrs:{src:t.sign[s].image,mode:"widthFix"}})]):t._e()],1)})],2)},i=[function(){var t=this,e=t.$createElement,a=t._self._c||e;return a("div",[a("h5",{staticClass:"left"},[a("p",{staticClass:"Wline Bline pb-10 pt-10 sort_view pl-10"},[a("span",{staticClass:"blueLeftline f-b mr-5"},[t._v("I")]),a("span",[t._v("调查房屋信息")])])]),a("div",{staticStyle:{clear:"both"}})])}],n=(a("28a5"),a("7f7f"),a("ac6a"),a("96cf"),a("3b8d")),r=a("dffc"),l={data:function(){return{title:"",resultData:[[]],addressArr:[],houseArr:[],headArr:[],sign:[],uuid:""}},methods:{getInvestHistoryData:function(){var t=Object(n["a"])(regeneratorRuntime.mark(function t(){var e,a,s,i,n;return regeneratorRuntime.wrap(function(t){while(1)switch(t.prev=t.next){case 0:return e=this,this.resultData=[[]],this.addressArr=[],this.houseArr=[],this.sign=[],this.headArr=[],t.next=8,r["a"].getInvestHistoryData(this.uuid);case 8:a=t.sent,a=JSON.parse(a),this.title=a.invest.title,s=JSON.parse(a.invest.content),s=s.fields,i=a.data,n=a.sign,s.forEach(function(t,a){i.forEach(function(a,s){if("address-family"===t.field_type||"address-property"===t.field_type){var i=t.field_name;i.forEach(function(t,s){t===a.name&&e.addressArr.push(a)})}else if("address-personal"===t.field_type){i=t.field_name;i.forEach(function(t,s){if(t===a.name){var i=t.split("-")[0];"commNo"==i?a.label="居住社区":"villageNo"==i?a.label="居住小区":"buildingNo"==i?a.label="居住楼宇":"unitNo"==i?a.label="单元号":"houseNo"===i?a.label="房间号":"otherAddress"===i&&(a.label="居住地址"),void 0===e.resultData[a.afew]&&(e.resultData[a.afew]=[]),e.resultData[a.afew].push(a)}})}else t.field_name===a.name&&(a.label=t.label,t.name=t.field_name.split("-")[0],"droitType"===t.name||"houseUse"===t.name||"isRent"===t.name||"liveType"===t.name?e.houseArr.push(a):"headImage"===t.name?(a.value=e.common.showPicture(a.value,"",!1),e.headArr[a.afew]=a):(void 0===e.resultData[a.afew]&&(e.resultData[a.afew]=[]),e.resultData[a.afew].push(a)))})}),void 0!=n&&n.forEach(function(t,a){t.image=e.common.showPicture(t.image),e.sign.push(t)});case 17:case"end":return t.stop()}},t,this)}));function e(){return t.apply(this,arguments)}return e}()},mounted:function(){this.uuid=this.$route.params.uuid,this.getInvestHistoryData()}},c=l,o=(a("2df9"),a("2877")),u=Object(o["a"])(c,s,i,!1,null,null,null);e["default"]=u.exports},"7f7f":function(t,e,a){var s=a("86cc").f,i=Function.prototype,n=/^\s*function ([^ (]*)/,r="name";r in i||a("9e1e")&&s(i,r,{configurable:!0,get:function(){try{return(""+this).match(n)[1]}catch(t){return""}}})},a9091:function(t,e,a){}}]);