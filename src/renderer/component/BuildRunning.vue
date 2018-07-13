<template>
    <card dis-hover
          title="分析服务"
          icon="ios-pulse"
          :bordered="false">
        <div style="display: flex; flex-direction: row;">
            <div style="padding: 8px; flex: 0 0 200px;">
                <Timeline>
                    <TimelineItem color="green">发布1.0版本</TimelineItem>
                    <TimelineItem color="green">发布2.0版本</TimelineItem>
                    <TimelineItem color="red">严重故障</TimelineItem>
                    <TimelineItem color="blue">发布3.0版本</TimelineItem>
                </Timeline>
            </div>
            <div class="logs">
                <virtual-list :size="18"
                              :remain="15"
                              :start="logs.length - 1"
                              wtag="ul">
                    <li v-for="(log, key) in logs"
                        :key="key">{{log}}</li>
                </virtual-list>
            </div>
        </div>
    </card>
</template>

<script>
    import VirtualList from 'vue-virtual-scroll-list'

    export default {
        name: "build-running",
        props: {
            logs: {
                type: Array
            }
        },
        data() {
            return {
                tasks: [
                    {
                        name: '数据库服务器',
                        icon: '',
                        iss: '',
                        status: '',
                    },
                    {
                        name: '分析服务器',
                        icon: '',
                        iss: '',
                        status: '',
                    },
                    {
                        name: '应用服务器',
                        icon: '',
                        iss: '',
                        status: '',
                    },
                    {
                        name: 'Fetch 服务器',
                        icon: '',
                        iss: '',
                        status: '',
                    },
                ]
            }
        },
        computed: {
        },
        components: {
            VirtualList
        },
    }
</script>

<style lang="less">
    .logs {
        flex: 1;
        background-color: #eff3f8;
        padding: 8px;
        border-radius: 4px;
        overflow: auto;

        & li {
              white-space: pre;
              font-size: 12px;
              font-family: Consolas,Menlo,Courier,monospace;
          }
    }

</style>