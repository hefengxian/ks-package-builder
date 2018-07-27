<template>
    <div>
        <card dis-hover :bordered="false">
            <div v-html="scheduleDesc" class="markdown-body"></div>
        </card>

        <card dis-hover :bordered="false" class="margin-top-16">
            <strong slot="title">替换 Task Schedule 导出的 XML</strong>
            <div>
                <i-form label-position="top">
                    <form-item label="XML 目录">
                        <row :gutter="16" type="flex">
                            <i-col style="flex: 1;">
                                <i-input type="text" v-model="scheduleXMLDir" placeholder="例如：D:\KWM_BUILD_PLATFORM"></i-input>
                            </i-col>
                            <i-col>
                                <i-button type="primary" icon="folder" @click="handleOpenFile">打开</i-button>
                            </i-col>
                        </row>
                    </form-item>
                    <form-item>
                        <Button type="primary"
                                @click="replaceSchedule"
                                style="width: 25%;">替换</Button>
                    </form-item>
                </i-form>
            </div>
        </card>
    </div>
</template>

<script>
    import fs from 'fs'
    import path from 'path'
    import {remote} from 'electron'
    import {shell} from 'electron'
    import {spawn, exec} from 'child_process'
    import iconv from 'iconv-lite'
    import moment from 'moment'
    import MarkdownIt from 'markdown-it'

    iconv.skipDecodeWarning = true
    const FORMAT = 'YYYY-MM-DD HH:mm:ss'

    export default {
        name: "build-input",
        props: {
            data: {
                type: Object,
                required: true,
                default() {
                    return {}
                }
            }
        },
        data() {
            let md = new MarkdownIt()
            let scheduleDesc = fs.readFileSync(path.join(__static, 'build_resource', 'task_schedule.md'))
            scheduleDesc = md.render(scheduleDesc.toString())
            return {
                outputs: [],
                md,
                scheduleDesc,
                scheduleXMLDir: 'C:\\Users\\dell\\Desktop\\KWM_Build_Platform\\Input\\KWM\\Analysis_Server\\www_root\\subject-classifier\\schedule_init',
            }
        },
        computed: {},
        mounted() {

        },
        methods: {
            handleOpenFile() {
                let path = remote.dialog.showOpenDialog({
                    defaultPath: this.scheduleXMLDir,
                    properties: ['openFile', 'openDirectory', 'multiSelections']
                })
                this.scheduleXMLDir = path[0]
            },

            // 替换 Schedule XML 中的不需要的部分
            replaceSchedule() {
                let list = fs.readdirSync(this.scheduleXMLDir)
                list.forEach((v, k) => {
                    if (v.endsWith('.xml')) {
                        let xmlPath = path.join(this.scheduleXMLDir, v)
                        let xmlContent = fs.readFileSync(xmlPath)
                        // Windows 导出的 Task Schedule 的 XML 文件是 UTF-16 格式
                        xmlContent = iconv.decode(xmlContent, 'utf-16')
                        // Author 替换
                        xmlContent = xmlContent.replace(/<Author>([\w\\]*)<\/Author>/ig, (match, p1, offset, str) => `<Author>Knowlesys</Author>`)
                        // 删除 Principal
                        xmlContent = xmlContent.replace(/<Principals>([\s\S\w\\]*)<\/Principals>/ig, (match, p1, offset, str) => `<Principals><Principal id="Author"></Principal></Principals>`)
                        // 如果是启用的，要关闭
                        xmlContent = xmlContent.replace(/<Enabled>true<\/Enabled>/ig, `<Enabled>false</Enabled>`)
                        // 写入文件
                        fs.writeFileSync(xmlPath, iconv.encode(xmlContent, 'utf-16'))
                    }
                })
                this.$Message.info('替换完成！')
            },

            runBat() {
                let ls = exec('C:\\Users\\dell\\Desktop\\kwm系统构建平台\\test.bat', {encoding: 'binary', timeout: 120 * 1000})

                // let ls = spawn('cmd.exe', ['/c', 'C:\\Users\\dell\\Desktop\\kwm系统构建平台\\test.bat'])

                // 正常输出
                ls.stdout.on('data', data => {
                    data = iconv.decode(data, 'gbk').trim()
                    if (data.trim() !== '') {
                        this.outputs.push(`[${moment().format(FORMAT)}] ${data}`)
                    }
                });

                // 错误信息
                ls.stderr.on('data', data => {
                    data = iconv.decode(data, 'gbk').trim()
                    this.outputs.push(`[${moment().format(FORMAT)}] ${data}`)
                })
            },
        },
        components: {
            BatTemplate: {
                props: {data: {type: Object}},
                data() {return {...this.data}},
                template: `<pre>${fs.readFileSync(path.join(__static, 'build_resource/test.bat')).toString()}</pre>`
            },
        },
        beforeDestroy() {
           /* let content = this.$refs['bat'].$el.innerText
            content = content.replace(/\r?\n/g, '\r\n')
            // content = iconv.decode(new Buffer(content), 'ANSI', {stripBOM: false})
            // 批处理里使用中文的话必须是 GBK 格式，可以使用 cp936 或者 GBK
            content = iconv.encode(content, 'cp936')
            let dest = "C:\\Users\\dell\\Desktop\\kwm系统构建平台\\test_gen.bat"
            fs.writeFile(dest, content, e => {
                // console.log(e)
            })*/
        },
    }
</script>

<style scoped>

</style>