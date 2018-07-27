<template>
    <div>
        <card dis-hover :bordered="false">
            <Tabs @on-click="handleTabClick"
                  type="card"
                  :animated="false">
                <TabPane name="build" label="构建配置" icon="settings">InnoSetup 构建配置</TabPane>
                <TabPane name="doc" label="文档" icon="document-text">
                    <div class="markdown-body" v-html="docContent"></div>
                </TabPane>
                <TabPane name="data" label="初始数据" icon="hammer">生成初始数据</TabPane>
                <TabPane name="ddl" label="DDL 生成" icon="wrench">
                    <strong>
                        生成数据库 DDL 步骤
                    </strong>
                    <ol class="list-origin">
                        <li>生成 mysqldump 语句，配置好数据库信息，复制下面的 mysqldump 语句（已经排除无用的表）导出一个 DDL</li>
                        <li>重置 <code>Auto_Increment</code>，一般使用编辑器中的正则替换 <code>AUTO_INCREMENT=(\d+)</code> 生成的 DDL 文件</li>
                        <li>删除无用的 Event，主要是技术部用来同步旧版 KWM 系统的采集相关的数据（内容中含有 133 的）</li>
                        <li>删除无用的 Procedure，主要是技术部用来同步旧版 KWM 系统的采集相关的数据(名称中含有 sync 的)</li>
                        <li>视情况是否要删除表的分区语句，初始化数据库不需要分区，如果要删除可以使用 <code>/\*\!50500(\S*\s*\w+\S*\s*)+\*\/</code> 替换</li>
                    </ol>

                    <strong>使用 DDL 生成初始化 Data 目录</strong>
                    <ol class="list-origin">
                        <li>清空 MySQL 配置的 Data 目录</li>
                        <li>使用命令 <code>mysqld --initialize-insecure</code> 初始化 Data 目录</li>
                        <li>启动 MySQL， 可以先建立服务再启动，或者直接使用 mysqld 启动</li>
                        <li>修改 root 密码，顺便创建 mmt_app 用户
                            <ol class="list-origin">
                                <li><code>mysql -uroot --skip-password</code></li>
                                <li>创建 mmt_app 用户
                                    <code>CREATE USER 'mmt_app'@'%' IDENTIFIED WITH mysql_native_password BY 'poms@db';</code>
                                    授权
                                    <code>GRANT ALL ON *.* TO 'mmt_app'@'%';</code></li>
                                <li>
                                    修改 root 用户
                                    <code>ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'poms@db';</code>
                                    <code>RENAME USER 'root'@'localhost' TO 'root'@'%';</code>
                                </li>
                                <li><code>FLUSH PRIVILEGES;</code></li>
                            </ol>
                        </li>
                        <li>导入 DDL 建立表结构 <code>mysql -uroot -ppoms@db --default-character-set utf8 < /path/to/mymonitor_ddl.sql</code></li>
                        <li>导入初始数据，复制初始数据中的 mysqldump 语句进行生成</li>
                        <li>Data 目录到此初始化完成</li>
                    </ol>

                </TabPane>
            </Tabs>
        </card>

        <div v-if="'build' === currentTab">
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
                                     :step="1"></InputNumber>
                        <span>GB</span>
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
                                  />
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
                                  />
                </div>
            </card>
        </div>

        <!-- data -->
        <div v-if="'data' === currentTab">
            <row :gutter="16" class="margin-top-16">
                <i-col :span="12">
                    <card dis-hover :bordered="false">
                        <i-form label-position="top">
                            <form-item label="源数据库 IP">
                                <i-input placeholder="192.168.1.116"
                                         v-model="data.options.originIP"></i-input>
                            </form-item>
                            <form-item label="端口">
                                <i-input placeholder="3306"
                                         v-model="data.options.originPort"></i-input>
                            </form-item>
                            <form-item label="用户名">
                                <i-input placeholder="mmt_app"
                                         v-model="data.options.originUser"></i-input>
                            </form-item>
                            <form-item label="密码">
                                <i-input placeholder="poms@db"
                                         v-model="data.options.originPassword"></i-input>
                            </form-item>
                        </i-form>
                    </card>
                </i-col>
                <i-col :span="12">
                    <card dis-hover :bordered="false">
                        <i-form label-position="top">
                            <form-item label="目标数据库 IP">
                                <i-input placeholder="192.168.1.116"
                                         v-model="data.options.destIP"></i-input>
                            </form-item>
                            <form-item label="端口">
                                <i-input placeholder="3306"
                                         v-model="data.options.destPort"></i-input>
                            </form-item>
                            <form-item label="用户名">
                                <i-input placeholder="mmt_app"
                                         v-model="data.options.destUser"></i-input>
                            </form-item>
                            <form-item label="密码">
                                <i-input placeholder="poms@db"
                                         v-model="data.options.destPassword"></i-input>
                            </form-item>
                        </i-form>
                    </card>
                </i-col>
            </row>

            <card dis-hover :bordered="false" class="margin-top-16">
                <strong slot="title">结果</strong>
                <pre style="overflow: auto"><template v-for="table in tables.full">mysqldump -h{{data.options.originIP}} -P{{data.options.originPort}} -u{{data.options.originUser}} -p{{data.options.originPassword}} --set-gtid-purged=OFF mymonitor --single-transaction --tables {{table.name}} | mysql -h{{data.options.destIP}} -P{{data.options.destPort}} -u{{data.options.destUser}} -p{{data.options.destPassword}} mymonitor <br/></template></pre>
                <pre style="overflow: auto"><template v-for="table in tables.part">mysqldump -h{{data.options.originIP}} -P{{data.options.originPort}} -u{{data.options.originUser}} -p{{data.options.originPassword}} --set-gtid-purged=OFF mymonitor --single-transaction --tables {{table.name}} -w"{{table.where}}" | mysql -h{{data.options.destIP}} -P{{data.options.destPort}} -u{{data.options.destUser}} -p{{data.options.destPassword}} mymonitor <br/></template></pre>
            </card>

            <row :gutter="16">
                <i-col :span="12">
                    <card dis-hover
                          class="margin-top-16"
                          :bordered="false">
                        <strong slot="title">全数据表</strong>
                        <div slot="extra">
                            <!--<a @click="openDir('iss')">打开目录</a>-->
                        </div>
                        <Table size="small" :columns="fullColumns" :data="tables.full"></Table>
                    </card>
                </i-col>
                <i-col :span="12">
                    <card dis-hover
                          class="margin-top-16"
                          :bordered="false">
                        <strong slot="title">部分数据表</strong>
                        <div slot="extra">
                            <!--<a @click="openDir('iss')">打开目录</a>-->
                        </div>
                        <Table size="small" :columns="partColumns" :data="tables.part"></Table>
                    </card>
                </i-col>
            </row>
        </div>

        <!-- structure -->
        <div v-if="'ddl' === currentTab">
            <card dis-hover :bordered="false">
                <card dis-hover :bordered="false">
                    <i-form label-position="top">
                        <row :gutter="16">
                            <i-col :span="12">
                                <form-item label="源数据库 IP">
                                    <i-input placeholder="192.168.1.116"
                                             v-model="data.options.originIP"></i-input>
                                </form-item>
                            </i-col>
                            <i-col :span="12">
                                <form-item label="端口">
                                    <i-input placeholder="3306"
                                             v-model="data.options.originPort"></i-input>
                                </form-item>
                            </i-col>
                        </row>
                        <row :gutter="16">
                            <i-col :span="12">
                                <form-item label="用户名">
                                    <i-input placeholder="mmt_app"
                                             v-model="data.options.originUser"></i-input>
                                </form-item>
                            </i-col>
                            <i-col :span="12">
                                <form-item label="密码">
                                    <i-input placeholder="poms@db"
                                             v-model="data.options.originPassword"></i-input>
                                </form-item>
                            </i-col>
                        </row>
                    </i-form>
                </card>
                <pre style="word-wrap: break-word; white-space: pre-wrap;">mysqldump -h{{data.options.originIP}} -P{{data.options.originPort}} -u{{data.options.originUser}} -p{{data.options.originPassword}} --single-transaction --set-gtid-purged=OFF --ignore-table=mymonitor.{{ignoreTables.join(' --ignore-table=mymonitor.')}} --no-data --triggers --events --routines --databases mymonitor > ~/Desktop/mymonitor_ddl.sql</pre>
            </card>
        </div>
    </div>
</template>

<script>
    import fs from 'fs'
    import path from 'path'
    import {shell} from 'electron'
    import tables from '../../../static/build_resource/tables'
    import ignoreTables from '../../../static/build_resource/ignore-tables'
    import MarkdownIt from 'markdown-it'

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
            let md = new MarkdownIt()

            return {
                currentTab: 'build',
                docContent: md.render(fs.readFileSync(path.join(__static, 'doc', 'database-server.md')).toString()),
                tables,
                ignoreTables,
                fullColumns: [
                    {
                        title: 'Table Name',
                        key: 'name'
                    },
                ],
                partColumns: [
                    {
                        title: 'Table Name',
                        key: 'name'
                    },
                    {
                        title: 'Where',
                        key: 'where'
                    },
                ],
            }
        },
        mounted() {
        },
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
                data() {
                    return {...this.data}
                },
                template: `<pre>${fs.readFileSync(path.join(__static, 'build_resource/iss/database_server_x64.iss')).toString()}</pre>`
            },
            IniTemplate: {
                props: {data: {type: Object}},
                data() {
                    return {...this.data}
                },
                template: `<pre>${fs.readFileSync(path.join(__static, 'build_resource/my.ini')).toString()}</pre>`
            },
        }
    }
</script>

<style lang="less">
    .list-origin {
        list-style-type: decimal;
        -webkit-margin-before: 1em;
        -webkit-margin-after: 1em;
        -webkit-margin-start: 0px;
        -webkit-margin-end: 0px;
        -webkit-padding-start: 40px;
    }
</style>