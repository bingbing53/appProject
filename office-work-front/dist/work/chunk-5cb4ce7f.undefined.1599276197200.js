(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["chunk-5cb4ce7f"],{3086:function(t,e,n){"use strict";n.r(e);var i,a=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{},[n("canvas",{staticStyle:{border:"1px solid black"},attrs:{id:"canvas",width:"300",height:"300"}}),n("div",{staticClass:"right text-c mr-10"},[n("van-button",{attrs:{type:"primary"},on:{click:t.clear}},[t._v("清除")]),t._v("    \n      "),n("van-button",{attrs:{type:"primary"},on:{click:t.save}},[t._v("保存")])],1),n("img",{staticStyle:{visibility:"hidden"},attrs:{src:t.url,alt:""}})])},c=[];function o(t,e){if(!(t instanceof e))throw new TypeError("Cannot call a class as a function")}function s(t,e){for(var n=0;n<e.length;n++){var i=e[n];i.enumerable=i.enumerable||!1,i.configurable=!0,"value"in i&&(i.writable=!0),Object.defineProperty(t,i.key,i)}}function r(t,e,n){return e&&s(t.prototype,e),n&&s(t,n),t}var u=function(t){t.preventDefault()},h=function(){function t(e){o(this,t),this.el=e,this.canvas=document.getElementById(this.el),this.cxt=this.canvas.getContext("2d"),this.stage_info=canvas.getBoundingClientRect(),this.path={beginX:0,beginY:0,endX:0,endY:0}}return r(t,[{key:"init",value:function(t){var e=this;this.canvas.addEventListener("touchstart",(function(t){document.addEventListener("touchstart",u,!1),e.drawBegin(t)})),this.canvas.addEventListener("touchend",(function(t){document.addEventListener("touchend",u,!1),e.drawEnd()})),this.clear(t)}},{key:"drawBegin",value:function(t){var e=this;window.getSelection()?window.getSelection().removeAllRanges():document.selection.empty(),this.cxt.strokeStyle="#000",this.cxt.beginPath(),this.cxt.moveTo(t.changedTouches[0].clientX-this.stage_info.left,t.changedTouches[0].clientY-this.stage_info.top),this.path.beginX=t.changedTouches[0].clientX-this.stage_info.left,this.path.beginY=t.changedTouches[0].clientY-this.stage_info.top,canvas.addEventListener("touchmove",(function(){e.drawing(event)}))}},{key:"drawing",value:function(t){alert(t.changedTouches[0].clientX),this.cxt.lineTo(t.changedTouches[0].clientX-this.stage_info.left,t.changedTouches[0].clientY-this.stage_info.top),this.path.endX=t.changedTouches[0].clientX-this.stage_info.left,this.path.endY=t.changedTouches[0].clientY-this.stage_info.top,this.cxt.stroke()}},{key:"drawEnd",value:function(){document.removeEventListener("touchstart",u,!1),document.removeEventListener("touchend",u,!1),document.removeEventListener("touchmove",u,!1)}},{key:"clear",value:function(t){this.cxt.clearRect(0,0,300,600)}},{key:"save",value:function(){return canvas.toDataURL("image/png")}}]),t}(),l={data:function(){return{val:!0,url:""}},mounted:function(){i=new h("canvas"),i.init()},methods:{clear:function(){i.clear()},save:function(){var t=i.save();this.url=t,console.log(t),window.localStorage.setItem("image_signdata",t),this.$router.go(-1)},mutate:function(t){this.$emit("input",t)}}},d=l,v=(n("d263"),n("9ca4")),f=Object(v["a"])(d,a,c,!1,null,"338a1f57",null);e["default"]=f.exports},4990:function(t,e,n){},d263:function(t,e,n){"use strict";var i=n("4990"),a=n.n(i);a.a}}]);