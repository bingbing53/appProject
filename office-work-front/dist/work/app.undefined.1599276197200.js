(function(e){function n(n){for(var a,c,i=n[0],r=n[1],l=n[2],s=0,d=[];s<i.length;s++)c=i[s],Object.prototype.hasOwnProperty.call(o,c)&&o[c]&&d.push(o[c][0]),o[c]=0;for(a in r)Object.prototype.hasOwnProperty.call(r,a)&&(e[a]=r[a]);f&&f(n);while(d.length)d.shift()();return u.push.apply(u,l||[]),t()}function t(){for(var e,n=0;n<u.length;n++){for(var t=u[n],a=!0,c=1;c<t.length;c++){var i=t[c];0!==o[i]&&(a=!1)}a&&(u.splice(n--,1),e=r(r.s=t[0]))}return e}var a={},c={app:0},o={app:0},u=[];function i(e){return r.p+""+({home:"home"}[e]||e)+".undefined.1599276197200.js"}function r(n){if(a[n])return a[n].exports;var t=a[n]={i:n,l:!1,exports:{}};return e[n].call(t.exports,t,t.exports,r),t.l=!0,t.exports}r.e=function(e){var n=[],t={"chunk-0ec97c98":1,"chunk-37df5b4a":1,"chunk-479f757b":1,"chunk-5cb4ce7f":1,"chunk-68f709be":1,"chunk-787b5f22":1,"chunk-afdb7508":1,"chunk-2da72d84":1,"chunk-2ef09dde":1,"chunk-3bdd604a":1,"chunk-41f32f6a":1,"chunk-4793fae4":1,"chunk-0884f422":1,"chunk-10566a70":1,"chunk-44a0b8d5":1,"chunk-79385892":1,"chunk-93c901c8":1,"chunk-51c1b90a":1,"chunk-573294cf":1,"chunk-5f0549ed":1,"chunk-669c562e":1,"chunk-73585bc3":1,"chunk-9ed540d2":1,"chunk-a0faf23e":1,"chunk-ab7a35c8":1,"chunk-b0daa798":1,"chunk-bc3ca294":1,"chunk-c0e38944":1,"chunk-fbeb0498":1,"chunk-a2de1564":1};c[e]?n.push(c[e]):0!==c[e]&&t[e]&&n.push(c[e]=new Promise((function(n,t){for(var a="css/"+({home:"home"}[e]||e)+"."+{"chunk-0ec97c98":"556ee828","chunk-37df5b4a":"7722f565","chunk-3bcf9828":"31d6cfe0","chunk-479f757b":"844d0684","chunk-5cb4ce7f":"c0dd33d7","chunk-68f709be":"67ac21ed","chunk-755bf70c":"31d6cfe0","chunk-0883ff08":"31d6cfe0","chunk-787b5f22":"905a9bbd","chunk-afdb7508":"905a9bbd","chunk-2da72d84":"246a50e2","chunk-2ef09dde":"c5b9c53a","chunk-3bdd604a":"c75d62ff","chunk-41f32f6a":"64eb2b12","chunk-4793fae4":"025dc6db","chunk-4806ce54":"31d6cfe0","chunk-0884f422":"5e0ca89c","chunk-10566a70":"bf09f6bd","chunk-44a0b8d5":"315dfbc0","chunk-79385892":"498a7edc","chunk-93c901c8":"2fc63565","chunk-51c1b90a":"26495343","chunk-573294cf":"033550d5","chunk-5f0549ed":"e3372e99","chunk-669c562e":"853ba9e3","chunk-73585bc3":"5b131c73","chunk-9ed540d2":"b7c04a94","chunk-a0faf23e":"52e223ba","chunk-ab7a35c8":"b95847fb","chunk-b0daa798":"80ce698f","chunk-bc3ca294":"7b81b7dc","chunk-c0e38944":"970c2817","chunk-fbeb0498":"43acc3a2","chunk-a2de1564":"837c97d9",home:"31d6cfe0"}[e]+".css",o=r.p+a,u=document.getElementsByTagName("link"),i=0;i<u.length;i++){var l=u[i],s=l.getAttribute("data-href")||l.getAttribute("href");if("stylesheet"===l.rel&&(s===a||s===o))return n()}var d=document.getElementsByTagName("style");for(i=0;i<d.length;i++){l=d[i],s=l.getAttribute("data-href");if(s===a||s===o)return n()}var f=document.createElement("link");f.rel="stylesheet",f.type="text/css",f.onload=n,f.onerror=function(n){var a=n&&n.target&&n.target.src||o,u=new Error("Loading CSS chunk "+e+" failed.\n("+a+")");u.code="CSS_CHUNK_LOAD_FAILED",u.request=a,delete c[e],f.parentNode.removeChild(f),t(u)},f.href=o;var h=document.getElementsByTagName("head")[0];h.appendChild(f)})).then((function(){c[e]=0})));var a=o[e];if(0!==a)if(a)n.push(a[2]);else{var u=new Promise((function(n,t){a=o[e]=[n,t]}));n.push(a[2]=u);var l,s=document.createElement("script");s.charset="utf-8",s.timeout=120,r.nc&&s.setAttribute("nonce",r.nc),s.src=i(e);var d=new Error;l=function(n){s.onerror=s.onload=null,clearTimeout(f);var t=o[e];if(0!==t){if(t){var a=n&&("load"===n.type?"missing":n.type),c=n&&n.target&&n.target.src;d.message="Loading chunk "+e+" failed.\n("+a+": "+c+")",d.name="ChunkLoadError",d.type=a,d.request=c,t[1](d)}o[e]=void 0}};var f=setTimeout((function(){l({type:"timeout",target:s})}),12e4);s.onerror=s.onload=l,document.head.appendChild(s)}return Promise.all(n)},r.m=e,r.c=a,r.d=function(e,n,t){r.o(e,n)||Object.defineProperty(e,n,{enumerable:!0,get:t})},r.r=function(e){"undefined"!==typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},r.t=function(e,n){if(1&n&&(e=r(e)),8&n)return e;if(4&n&&"object"===typeof e&&e&&e.__esModule)return e;var t=Object.create(null);if(r.r(t),Object.defineProperty(t,"default",{enumerable:!0,value:e}),2&n&&"string"!=typeof e)for(var a in e)r.d(t,a,function(n){return e[n]}.bind(null,a));return t},r.n=function(e){var n=e&&e.__esModule?function(){return e["default"]}:function(){return e};return r.d(n,"a",n),n},r.o=function(e,n){return Object.prototype.hasOwnProperty.call(e,n)},r.p="/work/",r.oe=function(e){throw console.error(e),e};var l=window["webpackJsonp"]=window["webpackJsonp"]||[],s=l.push.bind(l);l.push=n,l=l.slice();for(var d=0;d<l.length;d++)n(l[d]);var f=s;u.push([0,"chunk-vendors"]),t()})({0:function(e,n,t){e.exports=t("56d7")},"0a59":function(e,n,t){},"35ab":function(e,n,t){},"3afe":function(e,n,t){},"56d7":function(e,n,t){"use strict";t.r(n);t("e411");var a=t("f030"),c=(t("8db1"),t("768e")),o=(t("12f2"),t("700b")),u=(t("d46e"),t("04e1")),r=(t("45e8"),t("2a0b")),l=(t("bfff"),t("4d93")),s=(t("4683"),t("a4f9")),d=(t("8a86"),t("2a9a")),f=(t("4696"),t("418b")),h=(t("04a0"),t("332b")),p=(t("617a"),t("f420")),m=(t("9958"),t("d45c")),b=(t("c1af"),t("f1e5")),k=(t("4ca9"),t("5f97")),v=(t("73d6"),t("d120")),g=(t("94dc"),t("56ac")),w=(t("3585"),t("c043")),y=(t("50c9"),t("ba01")),A=(t("088d"),t("b4dd")),P=(t("c116"),t("352a")),I=(t("2a3b"),t("fd07")),O=(t("e115"),t("9fde")),C=(t("fe5f"),t("50d4")),T=(t("aa8d"),t("b89e")),E=(t("d0e6"),t("11f7")),S=(t("cc66"),t("2767")),x=(t("754d"),t("7c18")),D=(t("b304"),t("ada3")),_=(t("9c8b"),t("9ced")),j=(t("3bc8"),t("ae7a")),M=(t("1d73"),t("43ac")),K=(t("495e"),t("d903")),L=(t("d34c"),t("fc96")),N=(t("71f5"),t("d2b6")),q=(t("3048"),t("1591")),H=(t("6add"),t("8913")),B=(t("edec"),t("8e3c")),U=(t("6667"),t("8146")),$=(t("9915"),t("5808")),J=(t("bd56"),t("9970")),W=(t("cdf5"),t("8fa3")),X=(t("f8f1"),t("2678")),F=(t("494d"),t("0e57")),R=(t("e642"),t("15c7")),V=(t("2523"),t("f520")),Z=(t("a2c2"),t("4b9e")),z=(t("033d"),t("2598")),G=(t("76be"),t("6406")),Q=(t("2da9"),t("6fd0")),Y=(t("6e36"),t("819f")),ee=(t("5649"),t("12b6")),ne=(t("e44b"),t("6648"),t("5f54"),t("f0e6"),t("a593")),te=function(){var e=this,n=e.$createElement,t=e._self._c||n;return t("div",{attrs:{id:"app"}},[t("keep-alive",[e.$route.meta.keepAlive?t("router-view"):e._e()],1),e.$route.meta.keepAlive?e._e():t("router-view")],1)},ae=[],ce={name:"app"},oe=ce,ue=(t("7faf"),t("9ca4")),ie=Object(ue["a"])(oe,te,ae,!1,null,null,null),re=ie.exports,le=(t("9e76"),t("3211")),se=function(){return t.e("chunk-37df5b4a").then(t.bind(null,"62c6"))},de=function(){return t.e("chunk-0ec97c98").then(t.bind(null,"caa3"))},fe=function(){return Promise.all([t.e("chunk-755bf70c"),t.e("chunk-fbeb0498")]).then(t.bind(null,"29f0"))},he=function(){return Promise.all([t.e("chunk-755bf70c"),t.e("chunk-b0daa798")]).then(t.bind(null,"6b74"))},pe=function(){return Promise.all([t.e("chunk-755bf70c"),t.e("chunk-4793fae4")]).then(t.bind(null,"d1f3"))},me=function(){return Promise.all([t.e("chunk-755bf70c"),t.e("chunk-ab7a35c8")]).then(t.bind(null,"747c"))},be=function(){return Promise.all([t.e("chunk-755bf70c"),t.e("chunk-a0faf23e")]).then(t.bind(null,"0f10"))},ke=function(){return Promise.all([t.e("chunk-755bf70c"),t.e("chunk-2da72d84")]).then(t.bind(null,"37f8"))},ve=function(){return Promise.all([t.e("chunk-755bf70c"),t.e("chunk-51c1b90a")]).then(t.bind(null,"268f"))},ge=function(){return Promise.all([t.e("chunk-755bf70c"),t.e("chunk-2ef09dde")]).then(t.bind(null,"8d50"))},we=function(){return t.e("chunk-5cb4ce7f").then(t.bind(null,"3086"))},ye=function(){return Promise.all([t.e("chunk-755bf70c"),t.e("chunk-bc3ca294")]).then(t.bind(null,"100a"))},Ae=function(){return Promise.all([t.e("chunk-755bf70c"),t.e("chunk-4806ce54"),t.e("chunk-44a0b8d5")]).then(t.bind(null,"95cc"))},Pe=function(){return Promise.all([t.e("chunk-755bf70c"),t.e("chunk-4806ce54"),t.e("chunk-93c901c8")]).then(t.bind(null,"8e65"))},Ie=function(){return Promise.all([t.e("chunk-755bf70c"),t.e("chunk-4806ce54"),t.e("chunk-79385892")]).then(t.bind(null,"74cd"))},Oe=function(){return Promise.all([t.e("chunk-755bf70c"),t.e("chunk-573294cf")]).then(t.bind(null,"1f44"))},Ce=function(){return Promise.all([t.e("chunk-755bf70c"),t.e("chunk-3bdd604a")]).then(t.bind(null,"ed52"))},Te=function(){return Promise.all([t.e("chunk-755bf70c"),t.e("chunk-669c562e")]).then(t.bind(null,"6e3e"))},Ee=function(){return Promise.all([t.e("chunk-755bf70c"),t.e("chunk-5f0549ed")]).then(t.bind(null,"3114"))},Se=function(){return Promise.all([t.e("chunk-755bf70c"),t.e("chunk-9ed540d2")]).then(t.bind(null,"f2f8"))},xe=function(){return t.e("chunk-3bcf9828").then(t.bind(null,"84ad"))},De=function(){return Promise.all([t.e("chunk-755bf70c"),t.e("chunk-0883ff08"),t.e("chunk-787b5f22")]).then(t.bind(null,"96ef"))},_e=function(){return Promise.all([t.e("chunk-755bf70c"),t.e("chunk-73585bc3")]).then(t.bind(null,"f2d2"))},je=function(){return Promise.all([t.e("chunk-755bf70c"),t.e("chunk-c0e38944")]).then(t.bind(null,"5285"))},Me=function(){return Promise.all([t.e("chunk-755bf70c"),t.e("chunk-4806ce54"),t.e("chunk-0884f422")]).then(t.bind(null,"d45f"))},Ke=function(){return Promise.all([t.e("chunk-755bf70c"),t.e("chunk-4806ce54"),t.e("chunk-10566a70")]).then(t.bind(null,"cda5"))},Le=function(){return Promise.all([t.e("chunk-755bf70c"),t.e("chunk-0883ff08"),t.e("chunk-afdb7508")]).then(t.bind(null,"4f9e"))},Ne=function(){return t.e("home").then(t.bind(null,"b75f"))};ne["a"].use(le["a"]);var qe="".concat("/work/"),He=new le["a"]({mode:"hash",base:qe,routes:[{path:"/",name:"text",component:Ne},{path:"/publicopinion",name:"publicopinion",component:he,meta:{title:"民情民意"}},{path:"/detailopinion",name:"Detailopinion",component:pe,meta:{title:"录入民意"}},{path:"/license",name:"license",component:se,meta:{title:"隐私政策",keepAlive:!1}},{path:"/workhistory",name:"workhistory",component:me,meta:{title:"工作记录",keepAlive:!0}},{path:"/torecord",name:"torecord",component:be,meta:{title:"我要记录"}},{path:"/worksort",name:"worksort",component:ke},{path:"/hisDetail",name:"hisDetail",component:ve,meta:{keepAlive:!1,title:"记录详情"}},{path:"/mycollect",name:"mycollect",component:ge,meta:{keepAlive:!1,title:"我的收藏"}},{path:"/invest",name:"invest",component:ye,meta:{keepAlive:!1,title:"居民调查"}},{path:"/invest2",name:"invest",component:ye,meta:{keepAlive:!1,title:"家庭调查"}},{path:"/invest3",name:"invest",component:ye,meta:{keepAlive:!1,title:"房产调查"}},{path:"/investsign",name:"investsign",component:we,meta:{keepAlive:!1}},{path:"/investhistory:uuid",name:"investhistory",component:Ie,meta:{keepAlive:!1}},{path:"/investDetail:id",name:"investdetail",component:Ae,meta:{keepAlive:!1}},{path:"/articleDetail",name:"articleDetail",component:fe,meta:{keepAlive:!1,title:"通知详情"}},{path:"/download",name:"download",component:de,meta:{keepAlive:!1,title:"掌上办公app官方下载"}},{path:"/selectAddress",name:"selectaddress",component:Pe,meta:{keepAlive:!1}},{path:"/group",name:"group",component:Oe,meta:{keepAlive:!1,title:"我的小组"}},{path:"/groupdetail",name:"groupdetail",component:Ce,meta:{keepAlive:!1,title:"小组信息"}},{path:"/addgroup",name:"addgroup",component:Ee,meta:{keepAlive:!1,title:"添加小组"}},{path:"/collection",name:"collection",component:Te,meta:{keepAlive:!1,title:"被调查记录"}},{path:"/addmember",name:"addmember",component:Se,meta:{keepAlive:!1,title:"添加小组成员"}},{path:"/census",name:"census",component:xe,meta:{keepAlive:!1,title:"人口查询"}},{path:"/censusDetail",name:"censusDetail",component:De,meta:{keepAlive:!0,title:"个人信息查询"}},{path:"/personaldetail",name:"personaldetail",component:Le,meta:{keepAlive:!1,title:"个人信息查询"}},{path:"/censusHouse",name:"censusHouse",component:_e,meta:{keepAlive:!0,title:"房屋同住人查询"}},{path:"/censusHouseDetail",name:"censusHouseDetail",component:je,meta:{keepAlive:!0,title:"房屋信息"}},{path:"/censusAddress",name:"censusAddress",component:Me,meta:{keepAlive:!1,title:"房屋信息"}},{path:"/personalAddress",name:"personalAddress",component:Ke,meta:{keepAlive:!1,title:"房屋信息"}},{path:"/Proposal",name:"Proposal",component:function(e){return t.e("chunk-a2de1564").then(function(){var n=[t("7919")];e.apply(null,n)}.bind(this)).catch(t.oe)},meta:{keepAlive:!1,title:"代表提案"}},{path:"/addProposal",name:"addProposal",component:function(e){return t.e("chunk-68f709be").then(function(){var n=[t("45ff")];e.apply(null,n)}.bind(this)).catch(t.oe)},meta:{keepAlive:!1,title:"新增提案"}},{path:"/addMyProposal",name:"addMyProposal",component:function(e){return t.e("chunk-479f757b").then(function(){var n=[t("3db3")];e.apply(null,n)}.bind(this)).catch(t.oe)},meta:{keepAlive:!1,title:"新增提案"}},{path:"/viewProposal",name:"viewProposal",component:function(e){return Promise.all([t.e("chunk-755bf70c"),t.e("chunk-3bdd604a"),t.e("chunk-41f32f6a")]).then(function(){var n=[t("74d3")];e.apply(null,n)}.bind(this)).catch(t.oe)},meta:{keepAlive:!1,title:"查看提案"}},{path:"*",redirect:"/"}],scrollBehavior:function(e,n,t){if(t||"undefined"===typeof t){if(n.meta.isKeepAlive="undefined"===typeof n.meta.isKeepAlive&&void 0,e.meta.isKeepAlive="undefined"!==typeof e.meta.isKeepAlive||void 0,t)return t}else n.meta.isKeepAlive="undefined"!==typeof n.meta.isKeepAlive||void 0,e.meta.isKeepAlive="undefined"===typeof e.meta.isKeepAlive&&void 0}});He.beforeEach((function(e,n,t){t()})),He.afterEach((function(e){if(e.meta.title&&(document.title=e.meta.title,navigator.userAgent.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/))){var n=document.createElement("iframe");n.style.display="none",n.src="/static/html/fixIosTitle.html?r="+Math.random(),document.body.appendChild(n),setTimeout((function(e){document.body.removeChild(n)}),300)}}));var Be=He,Ue=t("9f3a"),$e=(t("82ae"),t("f0fe"));ne["a"].use(Ue["a"]);var Je={},We=new Ue["a"].Store({state:{classificationId:null},getters:Je,mutations:{setClassificationId:function(e,n){e.classificationId=n}},actions:{getClassification:function(e){return new Promise((function(n,t){Object($e["f"])(e).then((function(e){console.log(e,"vuex111111"),n(e)})).catch((function(e){t(e)}))}))},init:function(e){e.commit}}}),Xe=t("fed1"),Fe=t.n(Xe),Re=(t("e7f5"),t("8366")),Ve=t.n(Re),Ze=(t("508f"),t("62fc"),t("0a59"),t("3afe"),t("35ab"),t("b881"),t("85b2")),ze=t.n(Ze),Ge=t("87a7"),Qe=t.n(Ge),Ye=(t("6491"),t("9a33"),t("49a5"),t("5501")),en=t.n(Ye),nn={showPicture:function(e,n,t){return"http"!=e.substring(-1,4)&&(n=1,0==t&&(n=0)),void 0!=n&&1===n&&e?(e=e.split(".")[0]+"Zoom."+e.split(".")[1],e?e.startsWith("http")?e:"https://mongo.qicaidonghu.cn/pic/"+e:""):e?e.startsWith("http")?e:"https://mongo.qicaidonghu.cn/pic/"+e:""},reduceImage:function(e,n){var t="",a=null;en.a.getData(e.file,(function(){a=en.a.getTag(this,"Orientation");var c=document.createElement("canvas"),o=c.getContext("2d"),u=new Image;u.src=e.content,u.onload=function(){var r=this.width,l=this.height;if(r<600||l<600)n(e.content);else{if((r>4096||l>4096)&&(r>l?(r=4096,l/=r/4096):r<l?(l=4096,r/=l/4096):(l=4096,r=4096)),c.width=r,c.height=l,""!=a&&1!=a&&null!=a&&"undefined"!=a)switch(a){case 6:o.rotate(90*Math.PI/180),o.drawImage(u,0,-l,r,l);break;case 8:o.rotate(270*Math.PI/180),o.drawImage(u,i.width,0,r,l);break;case 3:o.rotate(180*Math.PI/180),o.drawImage(u,r,l,r,l);break}else o.drawImage(u,0,0,r,l);e.content=c.toDataURL(e.file.type,.6),t=e.content,n(t)}}}))},rotateImg:function(e,n,t){var a=0,c=3;if(null!=e){var o=e.height,u=e.width,i=2;null==i&&(i=a),"right"==n?(i++,i>c&&(i=a)):(i--,i<a&&(i=c));var r=90*i*Math.PI/180,l=t.getContext("2d");switch(i){case 0:t.width=u,t.height=o,l.drawImage(e,0,0);break;case 1:t.width=o,t.height=u,l.rotate(r),l.drawImage(e,0,-o);break;case 2:t.width=u,t.height=o,l.rotate(r),l.drawImage(e,-u,-o);break;case 3:t.width=o,t.height=u,l.rotate(r),l.drawImage(e,-u,0);break}}},token:function(e){window.localStorage.setItem("token_message",e)},removeClass:function(e,n){for(var t=document.getElementsByTagName(e),a=0;a<t.length;a++)1==t[a].classList.contains(n)&&t[a].classList.remove(n)},checkPhone:function(e,n){if(e=e||"",n=n||1,1==n&&-1!=e.indexOf("****"))return!0;var t=/^1[0-9]\d{9}$/;return t.test(e)}};ne["a"].prototype.common=nn,window.token=nn.token,ne["a"].use(Qe.a),ne["a"].use(ze.a),ne["a"].prototype.qs=Fe.a,ne["a"].config.productionTip=!1,ne["a"].use(Ve.a),ne["a"].use(a["a"]).use(c["a"]).use(o["a"]).use(u["a"]).use(r["a"]).use(l["a"]).use(s["a"]).use(d["a"]).use(f["a"]).use(h["a"]).use(p["a"]).use(m["a"]).use(b["a"]).use(k["a"]).use(v["a"]).use(g["a"]).use(w["a"]).use(y["a"]).use(A["a"]).use(P["a"]).use(I["a"]).use(O["a"]).use(C["a"]).use(T["a"]).use(E["a"]).use(S["a"]).use(x["a"]).use(D["a"]).use(_["a"]).use(j["a"]).use(M["a"]).use(K["a"]).use(L["a"]).use(N["a"]).use(q["a"]).use(H["a"]).use(B["a"]).use(U["a"]).use($["a"]).use(J["a"]).use(W["a"]).use(X["a"]).use(F["a"]).use(R["a"]).use(V["a"]).use(Z["a"]).use(z["a"]).use(G["a"]).use(Q["a"]).use(Y["a"]).use(ee["a"]),Be.beforeEach((function(e,n,t){e.meta.title&&(document.title=e.meta.title),We.dispatch("init").then((function(){t()}))})),new ne["a"]({router:Be,store:We,render:function(e){return e(re)}}).$mount("#app")},"62fc":function(e,n,t){},"7faf":function(e,n,t){"use strict";var a=t("bbbf"),c=t.n(a);c.a},b881:function(e,n,t){},bbbf:function(e,n,t){},f0fe:function(e,n,t){"use strict";t.d(n,"c",(function(){return s})),t.d(n,"d",(function(){return d})),t.d(n,"e",(function(){return f})),t.d(n,"a",(function(){return h})),t.d(n,"b",(function(){return p})),t.d(n,"g",(function(){return m})),t.d(n,"f",(function(){return b}));t("aa8d");var a=t("b89e"),c=t("82ae"),o=t.n(c),u=t("e04f"),i=t.n(u);o.a.defaults.withCredentials=!0;var r=function(){a["a"].clear()};i.a.set(),console.log(Document,"dssdfdsf"),o.a.interceptors.request.use((function(e){e.headers["Content-Type"]="application/x-www-form-urlencoded";var n="";if("POST"===e.method){for(var t in a["a"].loading({mask:!0,duration:0,message:"加载中..."}),e.body)n&&(n+="&"),n+=t+"="+e.body[t];e.body=n}else{for(var c in e.body)n&&(n+="&"),n+=c+"="+e.body[c];e.body=n}e.timeout=12e4;var o=window.localStorage.getItem("token_message");return e.headers={"X-AUTH-TOKEN":o,"Content-Type":"application/json"},e})),o.a.interceptors.response.use((function(e){return console.log(e,"response"),r(),e.data}),(function(e){if(r(),console.log(e,"err"),401==e.status)"1"==window.sessionStorage.getItem("reload")||(window.sessionStorage.setItem("reload",1),window.location.reload());else try{e.response.data&&Object(a["a"])({message:e.response.data,position:"bottom"})}catch(n){}}));var l=o.a;function s(e){return l({url:"/api/proposal/mine/page",method:"get",params:e})}function d(e){return l({url:"/api/proposal/org/page",method:"get",params:e})}function f(e){return l({url:"/api/proposal/"+e,method:"get"})}function h(e){return l({url:"/api/proposal",method:"post",data:e})}function p(e){return l({url:"/api/proposal/"+e.id,method:"put",data:e})}function m(e){return l({url:"/api/proposalVote/"+e.id+"/page",method:"get"})}function b(){return l({url:"/api/dict/proposalType",method:"get"})}}});