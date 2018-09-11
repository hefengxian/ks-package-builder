<template>
    <card dis-hover
          title="运行构建"
          icon="ios-play"
          :bordered="false">
        <div style="display: flex; flex-direction: row;">
            <div style="padding: 8px; flex: 0 0 200px;">
                <!--<timeline>
                    <timeline-item v-for="(task, key) in data.runTasks"
                                   :key="key"
                                   :color="task.status">{{task.title}}</timeline-item>
                </timeline>-->
                <Steps :current="data.currentTaskKey"
                       direction="vertical">
                    <Step v-for="(task, key) in data.runTasks"
                          :key="key"
                          :status="task.status"
                          :title="task.title"
                          :icon="task.icon"
                          :content="task.desc"></Step>
                </Steps>
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
            data: {
                type: Object
            }
        },
        data() {
            return {
            }
        },
        computed: {
            logs() {
                return this.data.logs
            }
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