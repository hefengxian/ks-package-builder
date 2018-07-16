<template>
    <card dis-hover
          title="构建结果"
          :bordered="false">
        <i-button @click="openResultDir" type="primary">打开结果目录</i-button>
    </card>
</template>

<script>
    import path from 'path'
    import {shell} from 'electron'
    import moment from 'moment'

    // const FORMAT = 'YYYY-MM-DD HH:mm:ss'
    export default {
        name: "build-result",
        props: {
            data: {
                type: Object,
                required: true,
                default() {
                    return {}
                }
            }
        },
        methods: {
            openResultDir() {
                let dir = path.join(this.data.options.rootPath, 'Output', moment().format('YYYY-MM-DD'))
                shell.openItem(dir)
            }
        }
    }
</script>

<style>

</style>