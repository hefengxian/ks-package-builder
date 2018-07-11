<template>
    <div>
        <card dis-hover :bordered="false">
            <strong slot="title">可选配置</strong>

            <!--<i-form label-position="top">
                <form-item label="KWM 服务地址">
                    <i-input placeholder=""
                             v-model="options.appServerAddress"></i-input>
                </form-item>
                <form-item label="KWM Cloud 地址">
                    <i-input placeholder=""
                             v-model="options.appCloudAddress"></i-input>
                </form-item>
            </i-form>-->
        </card>

        <card dis-hover
              class="margin-top-16"
              :bordered="false">
            <strong slot="title">Fetch_Server.iss</strong>
            <div slot="extra">
                <a @click="openDir('iss')">打开目录</a>
            </div>
            <div style="height: 280px; overflow: auto">
                <iss-template ref="iss"
                              :data="options"
                              style="width: 0;"/>
            </div>
        </card>
    </div>
</template>

<script>
    import fs from 'fs'
    import path from 'path'
    import {shell} from 'electron'

    export default {
        name: "build-analysis",
        props: {
            options: {
                type: Object,
                required: true,
                default() {
                    return {}
                }
            }
        },
        beforeDestroy() {
        },
        methods: {
            openDir(type) {
                let fullPath
                if (type === 'iss') {
                    fullPath = path.join(this.options.rootPath)
                } else {
                    fullPath = path.join(this.options.rootPath, '')
                }
                shell.openItem(fullPath)
            }
        },
        components: {
            IssTemplate: {
                props: {data: {type: Object}},
                data() {return {...this.data}},
                template: `<pre>${fs.readFileSync(path.join(__static, 'build_resource/iss/fetch_server_x64.iss')).toString()}</pre>`
            },
        }
    }
</script>

<style>

</style>