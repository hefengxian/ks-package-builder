<template>
    <card dis-hover :bordered="false">
        <strong>TODO</strong> 暂时只是一些说明，计划要把代码准备工作自动化（通过 Git）
        <i-button type="ghost" @click="runBat">Hello</i-button>
        <pre>{{outputs.join('\n')}}</pre>
        <bat-template ref="bat"
                      :data="options"
                      style="width: 0;"/>
    </card>
</template>

<script>
    import fs from 'fs'
    import path from 'path'
    import {shell} from 'electron'
    import {spawn, exec} from 'child_process'
    import iconv from 'iconv-lite'
    import moment from 'moment'

    iconv.skipDecodeWarning = true
    const FORMAT = 'YYYY-MM-DD HH:mm:ss'

    export default {
        name: "build-input",
        props: {
            options: {
                type: Object,
                required: true,
                default() {
                    return {}
                }
            }
        },
        data() {
            return {
                outputs: []
            }
        },
        computed: {},
        mounted() {

        },
        methods: {
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
            let content = this.$refs['bat'].$el.innerText
            content = content.replace(/\r?\n/g, '\r\n')
            // content = iconv.decode(new Buffer(content), 'ANSI', {stripBOM: false})
            // 批处理里使用中文的话必须是 GBK 格式，可以使用 cp936 或者 GBK
            content = iconv.encode(content, 'cp936')
            let dest = "C:\\Users\\dell\\Desktop\\kwm系统构建平台\\test_gen.bat"
            fs.writeFile(dest, content, e => {
                // console.log(e)
            })
        },
    }
</script>

<style scoped>

</style>