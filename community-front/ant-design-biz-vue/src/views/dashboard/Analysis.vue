<template>
  <div class="page-header-index-wide">

  </div>
</template>

<script>
  import ChartCard from '@/components/ChartCard'
  import { getAction } from '@/api/manage'
  import BarMultid from '@/components/chart/BarMultid'

  export default {
    name: "Analysis",
    components: {
      ChartCard,
      BarMultid
    },
    data() {
      return {
        loading: true,
      }
    },
    created() {
      setTimeout(() => {
        this.loading = !this.loading
      }, 1000)
    },
    methods: {
    }
  }
</script>

<style lang="scss" scoped>
  .extra-wrapper {
    line-height: 55px;
    padding-right: 24px;

    .extra-item {
      display: inline-block;
      margin-right: 24px;

      a {
        margin-left: 24px;
      }
    }
  }

  /* 首页访问量统计 */
  .head-info {
    position: relative;
    text-align: left;
    padding: 0 32px 0 0;
    min-width: 125px;

    &.center {
      text-align: center;
      padding: 0 32px;
    }

    span {
      color: rgba(0, 0, 0, .45);
      display: inline-block;
      font-size: .95rem;
      line-height: 42px;
      margin-bottom: 4px;
    }
    p {
      line-height: 42px;
      margin: 0;
      a {
        font-weight: 600;
        font-size: 1rem;
      }
    }
  }
</style>