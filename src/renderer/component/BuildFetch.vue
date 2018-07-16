<template>
    <div>
        <card dis-hover :bordered="false">
            <strong slot="title">可选配置</strong>

            <!--<i-form label-position="top">
                <form-item label="KWM 服务地址">
                    <i-input placeholder=""
                             v-model="data.options.appServerAddress"></i-input>
                </form-item>
                <form-item label="KWM Cloud 地址">
                    <i-input placeholder=""
                             v-model="data.options.appCloudAddress"></i-input>
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
                              :data="data.options"
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
            data: {
                type: Object,
                required: true,
                default() {
                    return {}
                }
            }
        },
        beforeDestroy() {
            // 销毁组件之前保存文件
            let destIssFile = path.join(this.data.options.rootPath, this.data.options.ISS_SUB_PATH, `Fetch_Server_x64.iss`)
            let issContent = this.$refs['iss'].$el.innerText
            fs.writeFile(destIssFile, issContent, e => {
                if (e) {
                    this.$Notice.error({title: e})
                } else {
                    this.$Notice.info({title: 'Fetch.iss 文件保存成功'})
                }
            })
        },
        methods: {
            openDir(type) {
                let fullPath
                if (type === 'iss') {
                    fullPath = path.join(this.data.options.rootPath, this.data.options.ISS_SUB_PATH)
                } else {
                    fullPath = path.join(this.data.options.rootPath, '')
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