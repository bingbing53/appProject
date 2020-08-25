<template>
  <div :style="{'width':width==null?'auto':width+'px'}">
    <v-chart :forceFit="width==null" :height="height" :data="data" :scale="scale" padding="0">
      <v-tooltip/>
      <v-bar position="x*y"/>
    </v-chart>
  </div>
</template>

<script>
  import moment from 'dayjs'

  const sourceData = []
  const beginDay = new Date().getTime()
  //
  // for (let i = 0; i < 10; i++) {
  //   sourceData.push({
  //     x: moment(new Date(beginDay + 1000 * 60 * 60 * 24 * i)).format('YYYY-MM-DD'),
  //     y: Math.round(Math.random() * 10)
  //   })
  // }

  const tooltip = [
    'x*y',
    (x, y) => ({
      name: x,
      value: y
    })
  ]

  // const scale = [{
  //   dataKey: 'x',
  //   min: 2
  // }, {
  //   dataKey: 'y',
  //   title: '时间',
  //   min: 1,
  //   max: 30
  // }]

  export default {
    name: 'MiniBar',
    props: {
      dataSource: {
        type: Array,
        default: () => []
      },
      width: {
        type: Number,
        default: null
      },
      height: {
        type: Number,
        default: 200
      },
      // x 轴别名
      x: {
        type: String,
        default: 'x'
      },
      // y 轴别名
      y: {
        type: String,
        default: '数量'
      }
    },
    created() {
      if (this.dataSource.length === 0) {
        this.data = sourceData
      } else {
        this.data = this.dataSource
      }
    },
    computed: {
      scale() {
        return [
          { dataKey: 'x', title: this.x, alias: this.x },
          { dataKey: 'y', title: this.y, alias: this.y }
        ]
      }
    },
    data() {
      return {
        tooltip,
        data: [],
        // scale
      }
    }
  }
</script>

<style lang="scss" scoped>
  @import "chart";
</style>