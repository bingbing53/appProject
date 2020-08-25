
<template>
    <div ak="xQvLe5mdn7hGbodfSEwV3UBzdGBow0g4"></div>
</template>
<script>
export default {
  name:"baiduMapModal",
  data () {
    return {
     
    }
  },
  methods: {
    handler ({BMap, map}) {
    alert(222)
      console.log(BMap, map)
      this.center.lng = 116.404
      this.center.lat = 39.915
      this.zoom = 15
    },
    
  }
}
</script>
<style scoped>


</style>