<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/context/mytags.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>掌上社区功能配置</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name=viewportcontent="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no,minimal-ui">
	<jsp:include page="/context/header.jsp" flush="true"></jsp:include>
</head>
<body>
	<div id="appModulesList" v-cloak>
	    <div class="right-menu" v-show="showRightMenu" style="position:fixed;z-index: 999;background: #fff;border: 1px solid rgba(0,0,0,.2);border-radius: 1px;">
            <ul class="el-scrollbar__view el-select-dropdown__list">
                <li class="el-select-dropdown__item" v-for="menu in rightMenu" @click="rightMenuClick(menu.type)" v-bind:style="{color:menu.color}">
                    <span><i :class="menu.icon"></i>  {{menu.name}}</span>
                </li>
            </ul>
        </div>
        <el-container>
            <el-aside>
                <div class="header">- {{aside_title}} -</div>
                <div class="item-aside" v-for="(item,key) in left_menu_show" v-on:click="clickButtonProxy($event)">
                    <el-row :gutter="4">
                        <el-col :span="3" style="text-align: center;">-</el-col>
                        <el-col :span="19">
                            <item v-html="item.text">{{item.text}}</item>

                        </el-col>
                    </el-row>
                </div>
            </el-aside>
            <el-main>
                <div class="list_module">
                    <!--工具条-->
                    <el-row>
                        <el-form :inline="true" :model="filters" size="mini" ref="filters">

                            <el-form-item>
                                <el-button type="primary" icon="el-icon-search" v-on:click="getAppModuless">查询</el-button>
                            </el-form-item>
                            <el-form-item>
                                <el-button icon="el-icon-refresh" @click="resetForm('filters')">重置</el-button>
                            </el-form-item>
                        </el-form>
                    </el-row>

                    <!--列表-->
                    <el-table class="tableCss" :data="appModuless" :row-class-name="tableRowClassName" size="mini" v-loading="listLoading" @sort-change="handleSortChange" @row-dblclick="handleEdit" @row-contextmenu="rightClick" @selection-change="selsChange" style="width: 100%;">
                        <el-table-column type="selection" width="55"></el-table-column>
                        <el-table-column type="index" width="60"></el-table-column>
                        <el-table-column prop="showName" label="展示名称" min-width="80" sortable="custom" show-overflow-tooltip></el-table-column>
                        <el-table-column prop="showIcon" label="展示图标" min-width="50" sortable="custom" show-overflow-tooltip>
                            <template slot-scope="scope" v-if="scope.row.showIcon">
                                <img width="20px" :src="'systemController/showOrDownByurl.do?dbPath='+scope.row.showIcon" alt="展示图标">
                            </template>
                        </el-table-column>
                        <%--<el-table-column prop="enabled" label="是否启用" min-width="60" sortable="custom" show-overflow-tooltip :formatter="formatYes_noDict"></el-table-column>--%>
                        <el-table-column prop="isWeb" label="是否web页" min-width="60" sortable="custom" show-overflow-tooltip>
                            <template slot-scope="scope">
                                <el-tag type="success" v-if="scope.row.isWeb == '1'" size="mini">是</el-tag>
                                <el-tag type="info" v-if="scope.row.isWeb == '0'" size="mini">否</el-tag>
                            </template>
                        </el-table-column>
                        <el-table-column prop="target" label="链接地址" min-width="120" sortable="custom" show-overflow-tooltip></el-table-column>
                        <%--<el-table-column prop="sort" label="排序" min-width="120" sortable="custom" show-overflow-tooltip></el-table-column>--%>
                        <el-table-column prop="code" label="模块编码" min-width="80" sortable="custom" show-overflow-tooltip></el-table-column>
                        <el-table-column prop="superCode" label="所属页面" min-width="80" sortable="custom" show-overflow-tooltip>
                            <template slot-scope="scope">
                                <span v-if="scope.row.superCode == 'work'">
                                    办公主页
                                </span>
                                <span v-if="scope.row.superCode == 'mine'">
                                    个人中心
                                </span>
                                <span v-if="scope.row.superCode == 'calendar'">
                                    我的日程
                                </span>
                                <span v-if="scope.row.superCode == 'chat'">
                                    共商共治
                                </span>
                            </template>
                        </el-table-column>
                    </el-table>

                    <!--工具条-->
                    <div class="toolbar">
                        <el-button type="danger" size="mini" @click="batchRemove" :disabled="this.sels.length===0">批量删除</el-button>
                         <el-pagination small background @current-change="handleCurrentChange" @size-change="handleSizeChange" :page-sizes="[10, 20, 50, 100]"
                            :page-size="pageSize" :total="total" layout="sizes, prev, pager, next"  style="float:right;"></el-pagination>
                    </div>
                </div>

                <!--新增界面-->
                <el-dialog class="my-el-dialog" z-index="800" :visible.sync="formVisible" :close-on-click-modal="false" :show-close="false" :modal="false" @close="dialogClose">
                    <el-form :model="form" label-width="100px" :rules="formRules" ref="form" size="mini" :disabled="addOrUpdate_disabled">
                            <el-form-item label="展示名称" prop="showName">
                                <el-input v-model="form.showName" auto-complete="off" placeholder="请输入展示名称" maxlength="32"></el-input>
                            </el-form-item>
                            <el-form-item label="展示图标" prop="showIcon">
                                <el-upload
                                        ref="upload"
                                        :action="url.upload"
                                        :data="{isup:'1'}"
                                        :show-file-list="false"
                                        :on-success="handleShowIconUploadFile"
                                        :before-upload="beforeAvatarUpload">
                                    <img v-if="form.showIcon" :src="form.showIcon">
                                    <i v-else class="el-icon-plus"></i>
                                </el-upload>
                            </el-form-item>
                            <el-form-item label="是否启用">
                                <el-radio v-model="form.enabled" :label="option.typecode" v-for="option in yes_noOptions">{{option.typename}}</el-radio>
                            </el-form-item>
                            <el-form-item label="是否web页">
                                <el-radio v-model="form.isWeb" :label="option.typecode" v-for="option in yes_noOptions">{{option.typename}}</el-radio>
                            </el-form-item>
                            <el-form-item label="链接地址" prop="target">
                                <el-input v-model="form.target" auto-complete="off" placeholder="请输入链接地址" maxlength="100"></el-input>
                            </el-form-item>
                            <el-form-item label="排序" prop="sort">
                                <el-input v-model="form.sort" auto-complete="off" placeholder="请输入排序" maxlength="10"></el-input>
                            </el-form-item>
                            <el-form-item label="模块编码" prop="code">
                                <el-input v-model="form.code" auto-complete="off" placeholder="请输入模块编码" maxlength="32"></el-input>
                            </el-form-item>
                        <el-button @click.native="formVisible = false">取消</el-button>
                        <el-button type="primary" @click.native="formSubmit" :loading="formLoading" :disabled="addOrUpdate_disabled">提交</el-button>
                    </el-form>
                </el-dialog>

                <!--权限分配-->
                <el-dialog class="my-el-dialog" z-index="800" :visible.sync="modules.auth.formVisible" :close-on-click-modal="false" :show-close="false" :modal="false" @close="dialogClose">
                    <div class="list_module">
                        <el-radio-group v-model="modules.personType" size="small" @change="getAppMauths">
                            <el-radio-button label="1">社区社工权限</el-radio-button>
                            <el-radio-button label="2">社工小组权限</el-radio-button>
                            <el-radio-button label="3">普通居民权限</el-radio-button>
                            <el-radio-button label="4">一级网格用户权限</el-radio-button>
                            <el-radio-button label="5">二级网格用户权限</el-radio-button>
                        </el-radio-group>
                        <el-select v-model="modules.searchDepart" filterable placeholder="请选择社区" size="mini" @change="getAppMauths">
                            <el-option :label="option.departname" :value="option.id" v-for="option in modules.sysDepartList"></el-option>
                        </el-select>
                        <div>
                            <div style="margin: 10px 0 10px;">现有权限如下（点叉号删除）</div>
                            <el-tag v-for="item in modules.auth.nowAuth" style="margin: 5px 10px 5px;" closable @close="handleAuthDel(item.id)">{{item.showName}}</el-tag>
                        </div>

                        <div>
                            <div style="margin: 10px 0 10px;">掌上社区全部权限如下所示（点击新增）</div>
                            <span v-for="item in modules.auth.filterAuth" @click="appAuthSave(item.id,item.code)"><el-tag  style="margin: 5px 10px 5px;">{{item.showName}}</el-tag></span>
                        </div>
                    </div>
                </el-dialog>
            </el-main>
        </el-container>
	</div>
</body>
<script>
	var vue = new Vue({
		el:"#appModulesList",
		data() {
			return {
			    showRightMenu:false,
                rightMenuRow:null,
                rightMenu:[
                    {name:'修改',icon:'el-icon-edit',type:'edit',color:'#606266'},
                    {name:'删除',icon:'el-icon-delete',type:'delete',color:'#F56C6C'}],
				filters: {
				},
				//帮助菜单
                aside_title:'掌上社区功能列表',
                left_menu: {
                    list: [
                        {text:'<button class="el-button el-button--primary el-button--mini" name="handleAdd()">新增</button>'},
                        {text:'<button class="el-button el-button--danger el-button--mini" name="batchRemove()">删除</button>'},
                        {text:'<button class="el-button el-button--info el-button--mini" name="ExportXls()">导出</button>'}
                        ],
                    update: [{text:'<button class="el-button el-button--primary el-button--mini" name="handleEditClick()">编辑</button>'},
                             {text:'<button class="el-button el-button--success el-button--mini" name="formSubmit()">保存</button>'},
                             {text:'<button class="el-button el-button--info el-button--mini" name="handleDialogClose()">返回</button>'}]
                },
                left_menu_show:[],
                //弹出的form是否禁用
                addOrUpdate_disabled:true,
				url:{
					list:'${webRoot}/appModulesController.do?datagrid',
					del:'${webRoot}/appModulesController.do?doDel',
					batchDel:'${webRoot}/appModulesController.do?doBatchDel',
					queryDict:'${webRoot}/systemController.do?typeListJson',
					queryTableDict:'${webRoot}/systemController.do?dictTableListJson',
					save:'${webRoot}/appModulesController.do?doAdd',
					edit:'${webRoot}/appModulesController.do?doUpdate',
					upload:'${webRoot}/systemController/filedeal.do',
					downFile:'${webRoot}/systemController/showOrDownByurl.do',
					exportXls:'${webRoot}/appModulesController.do?exportXls&id=',
					ImportXls:'${webRoot}/appModulesController.do?upload',
					helpInfo:'${webRoot}/helpController.do?info',

                    authList:'${webRoot}/appMauthController.do',
                    streetDepartJson:'systemController.do?streetDepartJson',
                    authSave:'${webRoot}/appMauthController.do?doAdd',
                    authDel:'${webRoot}/appMauthController.do?doDel',
				},
				appModuless: [],
				total: 0,
				page: 1,
				pageSize:100,
				sort:{
					sort:'id',
					order:'desc'
				},
				listLoading: false,
				sels: [],//列表选中列

				formTitle:'新增',
				formVisible: false,//表单界面是否显示
				formLoading: false,
				formRules: {
					sort:[
                            {pattern:/^[0-9]*$/,message:'请输入正整数'},
					],
				},
				//表单界面数据
				form: {},
				//数据字典
		   		yes_noOptions:[],

                modules:{
			        auth:{
			            formVisible:false,
                        nowAuth:[],
                        filterAuth:[]
                    },
                    personType:'1',
                    sysDepartList:[],
                    searchDepart:'',
                }
			}
		},
		methods: {
		    delAuth(){

            },
		    appAuthSave(id,code){
                let para = {
                    id:id,
                    sysOrgCode:this.modules.searchDepart,
                    user:this.modules.personType,
                    code:code
                };
                if (!para.id || !para.sysOrgCode || !para.user || !para.code) {
                    return;
                }
                this.$http.post(this.url.authSave,para,{emulateJSON: true}).then((res) => {
                    this.getAppMauths();
                });
            },
            handleAuthDel: function (id) {
		        let para = {id:id};
                this.$http.post(this.url.authDel,para,{emulateJSON: true}).then((res) => {
                    this.listLoading = false;
                    if(res.data.success){
                        this.$message({
                            message: '删除成功',
                            type: 'success',
                            duration:1500
                        });
                    }else{
                        this.$message({
                            message: res.data.msg,
                            type: 'error',
                            duration:1500
                        });
                    }
                    this.getAppMauths();
                });
            },
            getSysDepartList(){
                this.$http.get(this.url.streetDepartJson).then((res) => {
                    var datas = res.data.obj;
                    this.modules.sysDepartList = datas;
                    this.modules.sysDepartList.unshift({'id':'','departname':'请选择'});
                });
            },
            getAppMauths() {
                this.modules.auth.nowAuth = [];
                this.modules.auth.filterAuth = [];
                let para = {
                    params: {
                        sysOrgCode:this.modules.searchDepart,
                        user:this.modules.personType
                    }
                };
                this.$http.get(this.url.authList, para).then((res) => {
                    if (!res.data || res.data.respCode != '0') {
                        alert("查询失败！");
                        return;
                    }
                    let data = res.data.data;
                    for (let i = 0; i < data.length ; i++) {
                        for(let j = 0 ; j < this.appModuless.length ; j++){
                            if(data[i].code == this.appModuless[j].code){
                                data[i].showName = this.appModuless[j].showName;
                                break;
                            }
                        }
                        this.modules.auth.nowAuth.push(data[i]);
                    }
                    for(let j = 0 ; j < this.appModuless.length ; j++){
                        let find = false;
                        for(let i = 0 ; i < this.modules.auth.nowAuth.length ; i++){
                            if(this.appModuless[j].code == this.modules.auth.nowAuth[i].code){
                                find = true;
                            }
                        }
                        if(!find){
                            this.modules.auth.filterAuth.push(this.appModuless[j]);
                        }
                    }
                });
            },
		    tableRowClassName:function({row, rowIndex}){
                if (rowIndex % 2 == 0) {
                    return 'success-row';
                }
                return 'default-row';
            },
		    clickButtonProxy: function (event) {
                event.preventDefault();
                var self_method = event.target.name;
                var fun = eval('this.'+self_method);
            },
		    rightMenuClick(type){
                switch(type){
                    case 'edit':
                        this.handleEdit(this.rightMenuRow);
                        break;
                    case 'delete':
                        this.handleDel(this.rightMenuRow);
                        break;
                }
            },
            rightClick:function(row, event){
                event.preventDefault();
                var x = event.clientX;
                var y = event.clientY;

                this.showRightMenu = true;
                this.rightMenuRow = row;
                $(".right-menu").css("left",x);
                $(".right-menu").css("top",y);
            },
			handleShowIconUploadFile: function(response, file){
                // this.imageUrl = URL.createObjectURL(file.raw);
				this.form.showIcon=response.obj[0].url;

			},
			handleSortChange(sort){
				this.sort={
					sort:sort.prop,
					order:sort.order=='ascending'?'asc':'desc'
				};
				this.getAppModuless();
			},
			handleDownFile(type,filePath){
				var downUrl=this.url.downFile+"?down="+type+"&dbPath="+filePath;
				window.open(downUrl);
			},
			formatDate: function(row,column,cellValue, index){
				return !!cellValue?utilFormatDate(new Date(cellValue), 'yyyy-MM-dd'):'';
			},
			formatDateTime: function(row,column,cellValue, index){
				return !!cellValue?utilFormatDate(new Date(cellValue), 'yyyy-MM-dd hh:mm:ss'):'';
			},
			formatYes_noDict: function(row,column,cellValue, index){
				var names="";
				var values=cellValue;
				if(!Array.isArray(cellValue))values=cellValue.split(',');
				for (var i = 0; i < values.length; i++) {
					var value = values[i];
					if(i>0)names+=",";
					for(var j in this.yes_noOptions){
						var option=this.yes_noOptions[j];
						if(value==option.typecode){
							names+=option.typename;
						}
					}
				}
				return names;
			},
			handleCurrentChange(val) {
				this.page = val;
				this.getAppModuless();
			},
			handleSizeChange(val) {
				this.pageSize = val;
				this.page = 1;
				this.getAppModuless();
			},
			resetForm(formName) {
		        this.$refs[formName].resetFields();
		        this.getAppModuless();
		    },
			//获取用户列表
			getAppModuless() {
				var fields=[];
				fields.push('id');
				fields.push('showName');
				fields.push('showIcon');
				fields.push('enabled');
				fields.push('isWeb');
				fields.push('target');
				fields.push('code');
				fields.push('superCode');
				let para = {
					params: {
						page: this.page,
						rows: this.pageSize,
						//排序
						// sort:this.sort.sort,
						order:this.sort.order,
						field:fields.join(',')
					}
				};
				this.listLoading = true;
				this.$http.get(this.url.list,para).then((res) => {
					this.total = res.data.total;
					var datas=res.data.rows;
					for (var i = 0; i < datas.length; i++) {
						var data = datas[i];
					}
					this.appModuless = datas;
					this.listLoading = false;
				});
			},
			//删除
			handleDel: function (row,index) {
				this.$confirm('确认删除该记录吗?', '提示', {
					type: 'warning'
				}).then(() => {
					this.listLoading = true;
					let para = { id: row.id };
					this.$http.post(this.url.del,para,{emulateJSON: true}).then((res) => {
						this.listLoading = false;
						if(res.data.success){
                            this.$message({
                                message: '删除成功',
                                type: 'success',
                                duration:1500
                            });
						}else{
						    this.$message({
                                message: res.data.msg,
                                type: 'error',
                                duration:1500
                            });
						}
						this.getAppModuless();
					});
				}).catch(() => {

				});
			},
			//显示编辑界面
			handleEdit: function (row,index) {
			    this.left_menu_show = this.left_menu["update"];
                this.aside_title = '修改掌上社区功能列表';
                this.addOrUpdate_disabled = true;

				this.formTitle='编辑';
				this.formVisible = true;
				this.form = Object.assign({}, row);
			},
			//编辑页面可编辑
			handleEditClick:function(){
                this.addOrUpdate_disabled = false;
			},
            beforeAvatarUpload:function(file){
                const typeArr = ['image/png', 'image/gif', 'image/jpeg', 'image/jpg'];
                const isJPG = typeArr.indexOf(file.type) !== -1;
                const isLt3M = file.size / 1024 / 1024 < 3;
                if (!isJPG) {
                    this.$message.error('只能是图片!');
                    this.$refs.upload.clearFiles();
                    return false;
                }
                if (!isLt3M) {
                    this.$message.error('上传图片大小不能超过 3MB!');
                    this.$refs.upload.clearFiles();
                    return false;
                }
                return true;
            },
			//dialog关闭
            handleDialogClose:function(){
                this.formVisible = false;
                this.modules.auth.formVisible = false;
            },
            //点击
            handleAuth:function(){
		        this.modules.auth.formVisible = true;
                this.left_menu_show = this.left_menu["auth"];
                this.aside_title = '权限分配';

                this.getAppMauths();
            },
			//显示新增界面
			handleAdd: function () {
			    this.left_menu_show = this.left_menu["update"];
                this.aside_title = '新增掌上社区功能列表';
                this.addOrUpdate_disabled = false;

				this.formTitle='新增';
				this.formVisible = true;
				this.form = {
					showName:'',
					showIcon:'',
					enabled:'',
					isWeb:'',
					target:'',
					sort:'',
					code:'',
				};
			},
			//弹出框关闭
            dialogClose:function(){
                this.left_menu_show = this.left_menu["list"];
                this.aside_title = '掌上社区功能列表';

                this.modules.auth.formVisible = false;
            },
			//新增
			formSubmit: function () {
				this.$refs.form.validate((valid) => {
					if (valid) {
						this.$confirm('确认提交吗？', '提示', {}).then(() => {
							this.formLoading = true;
							let para = Object.assign({}, this.form);
							this.$http.post(!!para.id?this.url.edit:this.url.save,para,{emulateJSON: true}).then((res) => {
								this.formLoading = false;
								if(res.data.success){
                                    this.$message({
                                        message: '提交成功',
                                        type: 'success',
                                        duration:1500
                                    });
                                }else{
                                    this.$message({
                                        message: res.data.msg,
                                        type: 'error',
                                        duration:1500
                                    });
                                }
								this.$refs['form'].resetFields();
								this.formVisible = false;
								this.getAppModuless();
							});
						});
					}
				});
			},
			selsChange: function (sels) {
				this.sels = sels;
			},
			//批量删除
			batchRemove: function () {
				var ids = this.sels.map(item => item.id).toString();
				if(ids == '' || ids == null){
				    this.$message({
                        message: '请至少选择一条记录',
                        type: 'warning',
                        duration:1500
                    });
                    return;
				}
				this.$confirm('确认删除选中记录吗？', '提示', {
					type: 'warning'
				}).then(() => {
					this.listLoading = true;
					let para = { ids: ids };
					this.$http.post(this.url.batchDel,para,{emulateJSON: true}).then((res) => {
						this.listLoading = false;
                        if(res.data.success){
                            this.$message({
                                message: '删除成功',
                                type: 'success',
                                duration:1500
                            });
                        }else{
                            this.$message({
                                message: res.data.msg,
                                type: 'error',
                                duration:1500
                            });
                        }
						this.getAppModuless();
					});
				}).catch(() => {
				});
			},
			//导出
			ExportXls: function() {
					var ids = this.sels.map(item => item.id).toString();
					window.location.href = this.url.exportXls+ids;
			},
			//导入
			ImportXls: function(){
				openuploadwin('Excel导入',this.url.ImportXls, "appModulesList");
			},
			//初始化数据字典
			initDictsData:function(){
	        	var _this = this;
                    _this.initDictByCode('yes_no',_this,'yes_noOptions');
	        },
	        initDictByCode:function(code,_this,dictOptionsName){
	        	if(!code || !_this[dictOptionsName] || _this[dictOptionsName].length>0)
	        		return;
	        	this.$http.get(this.url.queryDict,{params: {typeGroupName:code}}).then((res) => {
	        		var data=res.data;
					if(data.success){
					  _this[dictOptionsName] = data.obj;
					  _this[dictOptionsName].splice(0, 1);//去掉请选择
					}
				});
	        },
	        initTableDict:function(_this,_tableName,_filed,_columns,dictOptionsName){
                if(!_this[dictOptionsName] || _this[dictOptionsName].length>0)
                    return;
                this.$http.get(this.url.queryTableDict,{params: {tableName:_tableName,dictField:_filed,dictText:_columns}}).then((res) => {
                    var data=res.data;
                    if(data.success){
                        _this[dictOptionsName] = data.obj;
                    }
                });
            },
            //获取帮助信息
            initHelpInfo:function(){
                this.$http.get(this.url.helpInfo,{params: {page:'appModulesList'}}).then((res) => {
                    var data=res.data;
                    if(data.success && data.obj != null){
                        this.left_menu = JSON.parse(data.obj.context);
                        this.left_menu_show = this.left_menu["list"];
                    }
                });
            }
		},
		mounted() {
	        this.initHelpInfo();
			this.initDictsData();
			this.getAppModuless();

			this.getSysDepartList();
		}
	});
	$("html").click(function(){
        vue.showRightMenu = false;
    });
	function utilFormatDate(date, pattern) {
        pattern = pattern || "yyyy-MM-dd";
        return pattern.replace(/([yMdhsm])(\1*)/g, function ($0) {
            switch ($0.charAt(0)) {
                case 'y': return padding(date.getFullYear(), $0.length);
                case 'M': return padding(date.getMonth() + 1, $0.length);
                case 'd': return padding(date.getDate(), $0.length);
                case 'w': return date.getDay() + 1;
                case 'h': return padding(date.getHours(), $0.length);
                case 'm': return padding(date.getMinutes(), $0.length);
                case 's': return padding(date.getSeconds(), $0.length);
            }
        });
    };
	function padding(s, len) {
	    var len = len - (s + '').length;
	    for (var i = 0; i < len; i++) { s = '0' + s; }
	    return s;
	};
	function reloadTable(){

	}
</script>
<script src="plug-in/main/js/common.js?v=0.1"></script>
</html>
