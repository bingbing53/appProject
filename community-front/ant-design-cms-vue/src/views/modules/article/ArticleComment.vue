<template>
  <div>
    <comment-List ref="commentList"></comment-List>
  </div>
</template>
<script>
import commentList from '../common/CommentList'
export default {
  components: {
    commentList
  },
  data() {
    return {}
  },
  mounted() {
    this.$refs.commentList.getType(0)
    this.$refs.commentList.getdatas()
  }
}
</script>

<style>
</style>