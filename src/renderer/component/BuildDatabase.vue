<template>
    <div >
        <card dis-hover :bordered="false">
            <Tabs @on-click="handleTabClick"
                  type="card"
                  :animated="false">
                <TabPane name="build" label="构建配置" icon="settings">
                    InnoSetup 构建配置
                </TabPane>
                <TabPane name="ddl" label="DDL 生成" icon="wrench">
                    生成数据库 DDL
                </TabPane>
                <TabPane name="data" label="初始数据" icon="hammer">
                    生成初始数据
                </TabPane>
            </Tabs>
        </card>

        <div v-show="'build' === currentTab">
            <card dis-hover :bordered="false">
                <strong slot="title">数据库可选配置</strong>

                <i-form label-position="top">
                    <!--<form-item label="MySQL BaseDir 目录">
                        <i-input  placeholder="D:\KWM\Base\MySQL"
                                  v-model="data.options.mysqlBaseDir"></i-input>
                    </form-item>-->
                    <form-item label="MySQL Data 目录">
                        <i-input placeholder="D:\KWM\Database_Server\Data"
                                 v-model="data.options.mysqlDataDir"></i-input>
                    </form-item>
                    <form-item label="MySQL Innodb 内存">
                        <InputNumber :min="1"
                                     v-model="data.options.mysqlMemoryPoolSize"
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
                                  :data="data.options"
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
                                  :data="data.options"
                                  style="width: 0;"/>
                </div>
            </card>
        </div>

        <div v-show="'ddl' === currentTab">
            <card dis-hover :bordered="false">
                <pre style="overflow: auto">mysqldump -h192.168.1.116 -uroot -ppoms@db --single-transaction --set-gtid-purged=OFF --no-data --triggers --events --routines --databases mymonitor > ~/ddl.sql</pre>
            </card>
        </div>

        <div v-show="'data' === currentTab">
            <card dis-hover :bordered="false">
                <pre style="overflow: auto">mysqldump -h192.168.1.116 -uroot -ppoms@db --set-gtid-purged=OFF mymonitor --tables app_parameter | mysql -h192.168.1.46 -uroot -ppoms@db mymonitor
mysqldump -h192.168.1.116 -uroot -ppoms@db --set-gtid-purged=OFF mymonitor --tables client -w"Client_ID=24" | mysql -h192.168.1.46 -uroot -ppoms@db mymonitor
                </pre>
                <!--<Table border :columns="columns1" :data="data1"></Table>-->
            </card>
        </div>
    </div>
</template>

<script>
    import fs from 'fs'
    import path from 'path'
    import {shell} from 'electron'

    export default {
        name: "build-database",
        props: {
            data: {
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
                currentTab: 'build',

            }
        },
        mounted() {},
        beforeDestroy() {
            // 销毁组件之前保存文件
            let destIssFile = path.join(this.data.options.rootPath, this.data.options.ISS_SUB_PATH, 'Database_Server_x64.iss')
            let issContent = this.$refs['iss'].$el.innerText
            fs.writeFile(destIssFile, issContent, e => {
                if (e) {
                    this.$Notice.error({title: e})
                } else {
                    this.$Notice.info({title: 'DB iss 文件保存成功'})
                }
            })

            let destIniFile = path.join(this.data.options.rootPath, 'Input/KWM/Base/MySQL/my.ini')
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
                    fullPath = path.join(this.data.options.rootPath, this.data.options.ISS_SUB_PATH)
                } else {
                    fullPath = path.join(this.data.options.rootPath, 'Input/KWM/Base/MySQL/')
                }
                shell.openItem(fullPath)
            },

            handleTabClick(name) {
                this.currentTab = name
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