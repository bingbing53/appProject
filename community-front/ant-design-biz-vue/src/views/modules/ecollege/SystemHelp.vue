<template>
  <div>
    <a-row>
      <a-col :span="6">
        <a-card>
          <a-divider>目录</a-divider>
          <div class="block">
            <el-tree
              :data="dataList"
              node-key="id"
              default-expand-all
              :expand-on-click-node="false"
              :render-content="renderContent"
              @node-click="nodeClick"
              :props="defaultProps"
            >
            </el-tree>
          </div>
        </a-card>
      </a-col>
      <a-col :span="1"></a-col>
      <a-col :span="17">
        <a-card :title="menuTitle">
          <a-form :form="form" :label-col="{ span: 3 }" :wrapper-col="{ span: 20 }">
            <a-form-item label="帮助标题">
              <a-input v-model="form.title" placeholder="请输入帮助标题" />
            </a-form-item>
            <a-form-item label="帮助内容">
              <!-- <a-textarea
                placeholder="请输入帮助内容"
                :auto-size="{ minRows: 3, maxRows: 5 }"
                v-model="form.textarea"
              /> -->
              <Myueditor ref="Myueditor"></Myueditor>
            </a-form-item>
            <a-form-item :wrapper-col="{ span: 12, offset: 5 }">
              <a-button type="primary" html-type="submit" @click="update"> 提交 </a-button>
            </a-form-item>
          </a-form>
        </a-card>
      </a-col>
    </a-row>
    <el-dialog title="添加标题" :visible.sync="dialogaddVisible">
      <el-form :model="form">
        <el-form-item label="帮助标题：" :label-width="formLabelWidth">
          <el-input v-model="addForm.title" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogaddVisible = false">取 消</el-button>
        <el-button type="primary" @click="addTitle">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
let id = 1000
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import { getAction, deleteAction, putAction, postAction } from '@/api/manage'
import Myueditor from '../ecollege/modules/Myueditor'
export default {
  name: 'SystemHelp',
  components: {
    Myueditor,
  },
  data() {
    const data = [
      {
        id: 1,
        label: '一级 1',
        children: [
          {
            id: 4,
            label: '二级 1-1',
            children: [
              {
                id: 9,
                label: '三级 1-1-1',
              },
              {
                id: 10,
                label: '三级 1-1-2',
              },
            ],
          },
        ],
      },
      {
        id: 2,
        label: '一级 2',
        children: [
          {
            id: 5,
            label: '二级 2-1',
          },
          {
            id: 6,
            label: '二级 2-2',
          },
        ],
      },
      {
        id: 3,
        label: '一级 3',
        children: [
          {
            id: 7,
            label: '二级 3-1',
          },
          {
            id: 8,
            label: '二级 3-2',
          },
        ],
      },
    ]

    return {
      data: JSON.parse(JSON.stringify(data)),
      dataList: [],
      form: {
        title: '',
        textarea: '',
      },
      addForm: {
        title: '',
      },
      url: {
        contentsList: '/help/children/tree',
        add: '/help',
        // delete: `/delete/${id}`,
      },
      dialogaddVisible: false,
      formLabelWidth: '120px',
      clickData: {},
      menuTitle: ['运营管理子系统'],
      defaultProps: {
        label: 'title',
      },
      parentLableList: null,
    }
  },

  methods: {
    // 节点点击
    nodeClick(data, node) {
      console.log(data, '点击的data')
      //   console.log(node.parentNode, 'node')
      this.form.title = data.title
      this.form.textarea = data.content
      this.clickData = data
      //   this.menuTitle = this.clickData.title
      this.menuTitle = []
      this.menuTitle.push(this.clickData.title)
      this.parentLable(this.dataList, this.clickData.parentId)
    },
    parentLable(menus, parentId, result = []) {
      menus.forEach((data) => {
        data.id === parentId && result.push(data)
        data.children && data.children.length && this.parentLable(data.children, parentId, result)
      })
      //   return result
      //   this.parentLableList = []
      this.parentLableList = result
      if (this.parentLableList.length != 0) {
        this.getContentsTitle()
      }
      //   console.log(result, 'result')
      //   if (this.parentLableList.length != 0) {
      //     this.menuTitle.push(this.parentLableList[0].title)
      //     _.reverse(this.menuTitle)
      //     // this.menuTitle = this.menuTitle.join(',')
      //     console.log(this.menuTitle, 'this.menuTitle')
      //     this.parentLable(this.dataList, this.parentLableList[0].parentId)
      //   } else if (this.parentLableList.length == 0) {
      //     this.menuTitle = this.menuTitle.join('->')
      //     return result
      //   }
    },
    getContentsTitle() {
      if (this.parentLableList.length != 0) {
        this.menuTitle.push(this.parentLableList[0].title)
        _.reverse(this.menuTitle)
        // this.menuTitle = this.menuTitle.join(',')
        console.log(this.menuTitle, 'this.menuTitle')
        if (this.parentLableList[0].parentId == 0) {
          this.menuTitle = this.menuTitle.join('->')
        } else {
          this.parentLable(this.dataList, this.parentLableList[0].parentId)
        }
      }
    },
    //获取目录列表
    getContentsList() {
      getAction(this.url.contentsList).then((res) => {
        // res.result.forEach((item) => {
        //   item.label = item.obj.title
        //   item.content = item.obj.content
        // })
        this.dataList = JSON.parse(JSON.stringify(res.result))
        console.log(this.dataList, '目录列表')
      })
    },
    //点击添加按钮
    append(data) {
      this.addForm.title = ''
      this.dialogaddVisible = true
      this.clickData = data
    },
    // 添加标题
    addTitle() {
      let params = {
        title: this.addForm.title,
        content: '',
        parentId: this.clickData.id,
      }
      postAction(this.url.add, params).then((res) => {
        if (res.code == 200) {
          getAction(this.url.contentsList).then((res) => {
            this.dataList = JSON.parse(JSON.stringify(res.result))
            this.treeFind(this.dataList, this.addForm.title)
            if (this.result) {
              console.log(this.result, 'result')
              const newChild = {
                parentId: this.clickData.id,
                id: this.result[0].id,
                title: this.addForm.title,
                children: [],
              }
              if (!this.clickData.children) {
                this.$set(this.clickData, 'children', [])
              }
              this.clickData.children.push(newChild)
              this.dialogaddVisible = false
            }
          })
        } else {
          alert(res.message)
        }
      })
    },
    //根据title查询其中一项
    treeFind(menus, title, result = []) {
      menus.forEach((data) => {
        data.title === title && result.push(data)
        data.children && data.children.length && this.treeFind(data.children, title, result)
      })
      this.result = result
      //   console.log(result, 'result')
    },
    // 修改
    update() {
      console.log(this.clickData.id, 'this.clickData.id')
      console.log(this.$refs.Myueditor.content, 'this.$refs.Myueditor.content')
      let params = {
        title: this.form.title,
        content: this.$refs.Myueditor.content,
        id: this.clickData.id,
      }
      putAction(this.url.add, params).then((res) => {
        if (res.code == 200) {
          this.$set(this.clickData, 'title', this.form.title)
          this.$set(this.clickData, 'content', this.form.textarea)
          this.form.title = ''
          this.form.textarea = ''
        } else {
          alert(res.message)
        }
      })
    },
    //上传图片
    getUploadsImageList(params) {
      let that = this
      postActionimg(this.url.imageuploads, params).then((res) => {
        if (res.code == 200) {
          that.uploadImageArr.push(res.url)
        }
      })
    },
    // 删除
    delete() {
      deleteAction(this.url.add + '/' + id).then((res) => {
        if (res.code == 200) {
          const newChild = { id: this.clickData.id, title: this.form.title, children: [] }
          // if (!this.clickData.children) {
          //   this.$set(this.clickData, 'children', [])
          // }
          this.$set(this.clickData, 'children', JSON.parse(JSON.stringify(newChild)))
        } else {
          alert(res.message)
        }
      })
    },
    remove(node, data) {
      deleteAction(this.url.add + '/' + data.id).then((res) => {
        if (res.code == 200) {
          const parent = node.parent
          const children = parent.data.children || parent.data
          const index = children.findIndex((d) => d.id === data.id)
          children.splice(index, 1)
        } else {
          alert(res.message)
        }
      })
    },

    renderContent(h, { node, data, store }) {
      //   console.log(node, 'node')
      //   console.log(data, 'data')
      //   console.log(store, 'store')
      if (node.level == 1) {
        return (
          <span class="custom-tree-node">
            <span>
              <span>{node.label}</span>
            </span>
            <span style="position: absolute;right:0">
              <i class="el-icon-edit" style="margin-right:10px"></i>
              <i class="el-icon-circle-plus-outline" on-click={() => this.append(data)}></i>
            </span>
          </span>
        )
      } else {
        return (
          <span class="custom-tree-node">
            <span>
              <span>{node.label}</span>
            </span>
            <span style="position: absolute;right:0">
              <i class="el-icon-edit" style="margin-right:10px"></i>
              <i class="el-icon-circle-plus-outline" on-click={() => this.append(data)} style="margin-right:10px"></i>
              <i class="el-icon-delete" on-click={() => this.remove(node, data)}></i>
            </span>
          </span>
        )
      }
    },
    //获取目录列表
    // getContentsList() {
    //   getAction(this.url.contentsList).then((res) => {
    //     console.log(res, '目录列表')
    //     this.dataList = res.result
    //   })
    // },
  },
  mounted() {
    this.getContentsList()
  },
}
</script>
<style scoped>
@import '~@assets/less/common.less';
.buttonSty {
  position: relative;
  border: 1px solid #ddd;
}
</style>