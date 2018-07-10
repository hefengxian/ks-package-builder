<template>
    <div>
        <card dis-hover :bordered="false">
            <strong slot="title">数据库可选配置</strong>

            <i-form label-position="top">
                <!--<form-item label="MySQL BaseDir 目录">
                    <i-input  placeholder="D:\KWM\Base\MySQL"
                              v-model="options.mysqlBaseDir"></i-input>
                </form-item>-->
                <form-item label="MySQL Data 目录">
                    <i-input placeholder="D:\KWM\Database_Server\Data"
                             v-model="options.mysqlDataDir"></i-input>
                </form-item>
                <form-item label="MySQL Innodb 内存">
                    <InputNumber :min="1"
                                 v-model="options.mysqlMemoryPoolSize"
                                 :step="1"></InputNumber> <span>GB</span>
                </form-item>
            </i-form>
        </card>

        <card dis-hover
              class="margin-top-16"
              :bordered="false">
            <strong slot="title">Database_Server.iss</strong>
            <div slot="extra">
                <a @click="openDir('iss')">打开目录</a>
            </div>
            <div style="height: 280px; overflow: auto">
                <iss-template ref="iss"
                              :data="options"
                              style="width: 0;"/>
            </div>
        </card>

        <card dis-hover
              class="margin-top-16"
              :bordered="false">
            <strong slot="title">my.ini</strong>
            <div slot="extra">
                <a @click="openDir('ini')">打开目录</a>
            </div>
            <div style="height: 280px; overflow: auto">
                <ini-template ref="ini"
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
        name: "build-database",
        props: {
            options: {
                type: Object,
                required: true,
                default() {
                    return {
                        mysqlDataDir: 'D:\\KWM\\Database_Server\\Data',
                        mysqlMemoryPoolSize: 1,
                    }
                }
            }
        },
        data() {
            return {
            }
        },
        mounted() {},
        beforeDestroy() {
            // 销毁组件之前保存文件
            let destIssFile = path.join(this.options.rootPath, 'Current_Database_Server_x64.iss')
            let issContent = this.$refs['iss'].$el.innerText
            fs.writeFile(destIssFile, issContent, e => {
                if (e) {
                    this.$Notice.error({title: e})
                } else {
                    this.$Notice.info({title: 'Current_Database_Server_x64.iss 文件保存成功'})
                }
            })

            let destIniFile = path.join(this.options.rootPath, '输入/KWM/Base/MySQL/my.ini')
            let iniContent = this.$refs['ini'].$el.innerText
            fs.writeFile(destIniFile, iniContent, e => {
                if (e) {
                    this.$Notice.error({title: e})
                } else {
                    this.$Notice.info({title: 'my.ini 文件保存成功'})
                }
            })
        },
        methods: {
            openDir(type) {
                let fullPath
                if (type === 'iss') {
                    fullPath = path.join(this.options.rootPath)
                } else {
                    fullPath = path.join(this.options.rootPath, '输入/KWM/Base/MySQL/')
                }
                shell.openItem(fullPath)
            }
        },
        components: {
            IssTemplate: {
                props: {data: {type: Object}},
                data() {return {...this.data}},
                template: `<pre>${fs.readFileSync(path.join(__static, 'build_resource/iss/database_server_x64.iss')).toString()}</pre>`
            },
            IniTemplate: {
                props: {data: {type: Object}},
                data() {return {...this.data}},
                template: `<pre>${fs.readFileSync(path.join(__static, 'build_resource/my.ini')).toString()}</pre>`
            },
        }
    }
</script>

<style>

</style>