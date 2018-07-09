<template>
    <div id="app">
        <div class="ks-left">
            <Steps :current="currentKey" direction="vertical">
                <Step title="构建目录"
                      icon="folder"
                      content="构建项目的根目录，公用配置"></Step>
                <Step title="生成输入文件"
                      icon="filing"
                      content="准备输入的各种文件"></Step>
                <Step title="配置数据库服务器"
                      icon="soup-can"
                      content="数据库服务器配置"></Step>
                <Step title="配置分析服务器"
                      icon="ios-pulse"
                      content="分析服务器配置"></Step>
                <Step title="配置应用服务器"
                      icon="monitor"
                      content="应用服务器配置"></Step>
                <Step title="配置应 Fetch 服务器"
                      icon="android-download"
                      content="Fetch 服务器配置"></Step>
                <Step title="运行构建"
                      icon="gear-a"
                      content="运行构建，查看日志"></Step>
                <Step title="构建结果"
                      icon="android-apps"
                      content="查看构建结果"></Step>
            </Steps>
        </div>
        <div class="ks-right">
            <div class="content">
                <component :is="steps[currentKey]" :options="options"></component>
                <!--<BuildRootPath v-if="currentKey === 0" :options.sync="options"/>
                <BuildInput v-if="currentKey === 1" :options.sync="options"/>
                <BuildDatabase v-if="currentKey === 2" :options.sync="options"/>
                <BuildAnalysis v-if="currentKey === 3" :options.sync="options"/>
                <BuildApplication v-if="currentKey === 4" :options.sync="options"/>
                <BuildFetch v-if="currentKey === 5" :options.sync="options"/>
                <BuildRunning v-if="currentKey === 6" :options.sync="options"/>
                <BuildResult v-if="currentKey === 7" :options.sync="options"/>-->
            </div>
            <div class="action">
                <div class="action-left">
                    <Button type="primary"
                            :disabled="currentKey < 1"
                            @click="currentKey--">上一步</Button>
                    <Button type="primary"
                            :disabled="currentKey >= steps.length - 1"
                            @click="currentKey++">下一步</Button>
                </div>
                <div class="action-right">
                    <Button :disabled="currentKey !== 6"
                            v-if="currentKey < 7"
                            icon="play" type="success">开始构建</Button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import BuildRootPath from './component/BuildRootPath'
    import BuildInput from './component/BuildInput'
    import BuildDatabase from './component/BuildDatabase'
    import BuildAnalysis from './component/BuildAnalysis'
    import BuildApplication from './component/BuildApplication'
    import BuildFetch from './component/BuildFetch'
    import BuildRunning from './component/BuildRunning'
    import BuildResult from './component/BuildResult'

    export default {
        name: 'ks-package-builder',
        data() {
            return {
                options: {
                    rootPath: 'D:\\KWM',
                    version: '4.0',
                    publisher: 'Knowlesys Inc.',
                    url: 'http://www.knowlesys.cn/',
                    mysqlBaseDir: 'D:\\KWM\\Base\\MySQL',
                    mysqlDataDir: 'D:\\KWM\\Database_Server\\Data',
                    mysqlMemoryPoolSize: 1,
                    analysisDBIP: '192.168.1.116',
                    solrDataDir: 'D:\\KWM\\Analysis_Server\\Solr_Data',
                },
                steps: [
                    BuildRootPath,
                    BuildInput,
                    BuildDatabase,
                    BuildAnalysis,
                    BuildApplication,
                    BuildFetch,
                    BuildRunning,
                    BuildResult,
                ],
                currentKey: 0,
            }
        },
        components: {
            BuildRootPath,
            BuildInput,
            BuildDatabase,
            BuildAnalysis,
            BuildApplication,
            BuildFetch,
            BuildRunning,
            BuildResult,
        },
        methods: {

        },
    }
</script>

<style lang="less">
    #app {
        display: flex;
        height: 100vh;
        overflow: hidden;

        & .ks-left {
            height: 100vh;
            overflow: auto;
            padding: 16px;
            max-width: 280px;
            border-right: 1px solid #f0f0f0;
        }
        & .ks-right {
            flex: 1;
            height: 100vh;

            display: flex;
            flex-direction: column;

            & .content {
                overflow: auto;
                flex: 1;
                padding: 16px;
                display: flex;
                justify-content: center;
                align-items: center;
            }
            & .action {
                padding: 16px;
                display: flex;
                & .action-left, & .action-right {
                    flex: 1;
                }
                & .action-right {
                    display: flex;
                    flex-direction: row-reverse;
                }
            }
        }
    }
</style>
