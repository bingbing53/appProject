<template>
  <baidu-map class="map"
     :center="center"
     :zoom="14"
     :scroll-wheel-zoom="true"
     @click="mapClick"
  >
    <bm-control class="my_search">
      <label>
        <a-input v-model="keyword" @focus="searchShow = true" placeholder="关键词" />
        <!--<input v-model="keyword" @focus="searchShow = true" placeholder="关键词"/>-->
      </label>
      <bm-navigation anchor="BMAP_ANCHOR_TOP_RIGHT"></bm-navigation>
      <bm-local-search
        :panel="searchShow"
        :pageCapacity="5"
        :keyword="keyword"
        :auto-viewport="true"
      ></bm-local-search>
    </bm-control>
    <bm-marker :position="position" :dragging="false" animation="BMAP_ANIMATION_BOUNCE">
    </bm-marker>
  </baidu-map>
</template>

<script>
    export default {
        name: "BaiduMapPosition",
        data() {
          return {
            center: { lng: 116.404, lat: 39.915 },
            keyword:'',
            searchShow:false,
            position:{lng: 116.404, lat: 39.915},
          };
        },
        props: {
          value: {
            type: Object,
            default: function() {
              return {};
            }
          }
        },
        created:{
        },
        methods:{
          mapClick(item){
            this.position = item.point;
          }
        },
        watch: {
          position(){
            this.$emit('input', this.position)
          }
        }
    }
</script>

<style scoped>
  .map {
    width: 100%;
    height: 300px;
  }
</style>