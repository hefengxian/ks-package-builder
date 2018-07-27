<template>
    <div id="app">
        <div class="ks-left">
            <Steps :current="currentKey"
                   direction="vertical">
                <Step v-for="(step, key) in steps"
                      class="build-step"
                      @click.native="stepClick(key)"
                      :key="key"
                      :title="step.title"
                      :icon="step.icon"
                      :content="step.content"></Step>
            </Steps>
        </div>
        <div class="ks-right">
            <div class="content">
                <component :is="stepComponents[currentKey]"
                           :data.sync="$data"></component>
                <!-- <BuildCommon v-if="currentKey === 0" :options.sync="options"/>
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
                            @click="currentKey--">上一步
                    </Button>
                    <Button type="primary"
                            :disabled="currentKey >= steps.length - 1"
                            @click="currentKey++">下一步
                    </Button>
                </div>
                <div class="action-right">
                    <Button :disabled="currentKey !== 6"
                            v-if="currentKey < 7"
                            @click="runBuild"
                            icon="play"
                            type="success">开始构建
                    </Button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import fs from 'fs'
    import path from 'path'
    import {shell} from 'electron'
    import {spawn, exec, execSync} from 'child_process'
    import iconv from 'iconv-lite'
    import moment from 'moment'

    import BuildCommon from './component/BuildCommon'
    import BuildInput from './component/BuildInput'
    import BuildDatabase from './component/BuildDatabase'
    import BuildAnalysis from './component/BuildAnalysis'
    import BuildApplication from './component/BuildApplication'
    import BuildFetch from './component/BuildFetch'
    import BuildRunning from './component/BuildRunning'
    import BuildResult from './component/BuildResult'

    const LS_KEY = 'options_store_key'
    iconv.skipDecodeWarning = true
    const FORMAT = 'YYYY-MM-DD HH:mm:ss'

    export default {
        name: 'ks-package-builder',
        data() {
            let options = JSON.parse(localStorage.getItem(LS_KEY))
            if (options === null) {
                options = {
                    ISS_SUB_PATH: 'Build\\Iss\\',
                    rootPath: 'C:\\Users\\dell\\Desktop\\KWM_Build_Platform',
                    version: '4.0',
                    publisher: 'Knowlesys Inc.',
                    url: 'http://www.knowlesys.cn/',
                    compress: 'zip',
                    mysqlBaseDir: 'D:\\KWM\\Base\\MySQL',
                    mysqlDataDir: 'D:\\KWM\\Database_Server\\Data',
                    mysqlMemoryPoolSize: 1,

                    originIP: '192.168.1.116',
                    originPort: '3306',
                    originUser: 'mmt_app',
                    originPassword: 'poms@db',

                    destIP: '192.168.1.46',
                    destPort: '3306',
                    destUser: 'mmt_app',
                    destPassword: 'poms@db',

                    dbIP: '192.168.1.116',
                    solrDataDir: 'D:\\KWM\\Analysis_Server\\Solr_Data',
                    appServerAddress: '/kwm/server/',
                    appCloudAddress: '/kwmcloud/',
                }
            }

            return {
                options: {...options, currentDate: moment().format('YYYY-MM-DD'),},
                logs: [],
                stepComponents: [
                    BuildCommon,
                    BuildInput,
                    BuildDatabase,
                    BuildAnalysis,
                    BuildApplication,
                    BuildFetch,
                    BuildRunning,
                    BuildResult,
                ],
                steps: [
                    {
                        title: '构建目录',
                        icon: 'folder',
                        content: '构建项目的根目录，公用配置',
                    },
                    {
                        title: '生成输入文件',
                        icon: 'filing',
                        content: '准备输入的各种文件',
                    },
                    {
                        title: '配置数据库服务器',
                        icon: 'soup-can',
                        content: '数据库服务器配置',
                    },
                    {
                        title: '配置分析服务器',
                        icon: 'ios-pulse',
                        content: '分析服务器配置',
                    },
                    {
                        title: '配置应用服务器',
                        icon: 'monitor',
                        content: '应用服务器配置',
                    },
                    {
                        title: '配置 Fetch 服务器',
                        icon: 'android-download',
                        content: 'Fetch 服务器配置',
                    },
                    {
                        title: '运行构建',
                        icon: 'gear-a',
                        content: '运行构建，查看日志',
                    },
                    {
                        title: '构建结果',
                        icon: 'android-apps',
                        content: '查看构建结果',
                    },
                ],
                currentKey: 0,
                currentTaskKey: 0,
                runTasks: [
                    {
                        title: '数据库服务器',
                        desc: '等待构建',
                        icon: 'soup-can',
                        status: 'wait',
                        iss: 'Database_Server_x64.iss',
                    },
                    {
                        title: '分析服务器',
                        desc: '等待构建',
                        icon: 'ios-pulse',
                        status: 'wait',
                        iss: 'Analysis_Server_x64.iss',
                    },
                    {
                        title: '应用服务器',
                        desc: '等待构建',
                        icon: 'monitor',
                        status: 'wait',
                        iss: 'Application_Server_x64.iss',
                    },
                    {
                        title: 'Fetch 服务器',
                        desc: '等待构建',
                        icon: 'android-download',
                        status: 'wait',
                        iss: 'Fetch_Server_x64.iss',
                    },
                ],
            }
        },

        watch: {
            options: {
                handler(newVal, oldVal) {
                    // console.log('data.options has change: ', oldVal, newVal)
                    localStorage.setItem(LS_KEY, JSON.stringify(newVal))
                },
                deep: true,
                // immediate: true,
            }
        },
        components: {
            BuildCommon,
            BuildInput,
            BuildDatabase,
            BuildAnalysis,
            BuildApplication,
            BuildFetch,
            BuildRunning,
            BuildResult,
        },
        mounted() {
            // console.dir(document.querySelector('#app'))
        },
        methods: {
            stepClick(key) {
                if (key < this.currentKey) {
                    this.currentKey = key
                } else if (key === this.currentKey + 1) {
                    this.currentKey = key
                }
            },
            runBuild() {

                this.runTasks.forEach((v, k) => {
                    let isccPath = path.join(this.options.rootPath, 'Build\\Bin\\InnoSetup\\ISCC.exe')
                    let issPath = path.join(this.options.rootPath, 'Build\\Iss', v.iss)
                    let cmd = `"${isccPath}" ${issPath}`

                    this.currentTaskKey = k
                    this.runTasks[k].desc = '构建中...'
                    this.runTasks[k].status = 'process'
                    
                    this.logs.push(`=============== 开始执行：${cmd}`)
                    let ls = exec(cmd, {encoding: 'binary', maxBuffer: Infinity})

                    // 正常输出
                    ls.stdout.on('data', data => {
                        data = iconv.decode(data, 'gbk')// .trim()
                        let lines = data.split(/[\n\r\n]/g)
                        // this.logs.push(`[${moment().format(FORMAT)}] ${data}`)
                        lines.forEach((line, k) => {
                            if (line.trim() !== '') {
                                this.logs.push(line)
                            }
                        })
                    });

                    // 错误信息
                    ls.stderr.on('data', data => {
                        this.runTasks[k].desc = '构建失败'
                        this.runTasks[k].status = 'error'
                        data = iconv.decode(data, 'gbk').trim()
                        this.logs.push(`>>>>>>>>>>>>>> ${data}`)
                    })

                    // child_process 进程关闭
                    ls.on('close', (code, signal) => {
                        // console.log(code, signal)
                        if (code === 0) {   // 正常退出
                            this.runTasks[k].desc = '构建完成'
                            this.runTasks[k].status = 'finish'
                            this.logs.push(`=============== ${v.title}打包完成！`)
                        }
                    })
                })
            }
        },
    }
</script>

<style lang="less">
    #app {
        display: flex;
        height: 100vh;
        overflow: hidden;

        pre, code {
            // font-size: 12px;
            font-family: Consolas, "Roboto Mono", Monaco, courier, monospace, "PingFang SC", "Hiragino Sans GB","Microsoft YaHei","微软雅黑";
            background-color: #f8f8f8;
            color: #525252;
            white-space: pre;
            font-size: 12px;
        }

        code {
            color: #e96900;
            padding: 3px 5px;
            margin: 0 2px;
            border-radius: 2px;
            white-space: nowrap;
        }

        pre {
            padding: 1.2em 1.4em;
        }

        .markdown-body {
            box-sizing: border-box;
            margin: 0 auto;
            font-size: 12px;
            font-family: "Helvetica Neue",Helvetica,"PingFang SC", consolas, "Hiragino Sans GB","Microsoft YaHei","微软雅黑",Arial,sans-serif, -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol";;
        }

        .padding {
            &-top-16 {
                padding-top: 16px;
            }
            &-top-32 {
                padding-top: 32px;
            }
        }

        .margin {
            &-top-16 {
                margin-top: 16px;
            }
            &-top-32 {
                margin-top: 32px;
            }
        }

        & .ks-left {
            height: 100vh;
            overflow: auto;
            padding: 16px;
            max-width: 280px;
            border-right: 1px solid #f0f0f0;

            & .build-step {
                cursor: pointer;
                /*&:hover {
                    color: #f00!important;
                }*/
            }
        }
        & .ks-right {
            flex: 1;
            height: 100vh;
            overflow: auto;
            display: flex;
            flex-direction: column;

            & .content {
                overflow: auto;
                flex: 1;
                padding: 0 16px;
                background-color: #eff3f8;

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
