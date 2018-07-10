<template>
    <card dis-hover :bordered="false">
        <strong>TODO</strong> 暂时只是一些说明，计划要把代码准备工作自动化（通过 Git）
        <i-button type="ghost" @click="runBat">Hello</i-button>
        <pre>{{outputs.join('\n')}}</pre>
    </card>
</template>

<script>
    import {spawn} from 'child_process'
    import iconv from 'iconv-lite'

    export default {
        name: "build-input",
        props: {
            options: {
                type: Object,
                required: true,
                default() {
                    return {
                    }
                }
            }
        },
        data() {
            return {
                outputs: []
            }
        },
        computed: {
        },
        methods: {
            runBat() {
                let ls = spawn('cmd.exe', ['/c', 'C:\\Users\\hfx\\Desktop\\Build_Platform\\task_run.bat'])

                ls.stdout.on('data', data => {
                    data = iconv.decode(new Buffer(data), 'gbk', {stripBOM: false})
                    this.outputs.push(data)
                });

            }
        }
    }
</script>

<style scoped>

</style>