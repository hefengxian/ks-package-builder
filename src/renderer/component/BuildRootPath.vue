<template>
    <div style="flex: 1;">
        <i-form :label-width="80" >
            <form-item label="构建根目录">
                <row :gutter="16" type="flex">
                    <i-col style="flex: 1;">
                        <i-input type="text" v-model="options.rootPath" placeholder="例如：D:\KWM"></i-input>
                    </i-col>
                    <i-col>
                        <i-button type="primary" icon="folder" @click="handleOpenFile">打开</i-button>
                    </i-col>
                </row>
            </form-item>
            <form-item label="版本">
                <i-input type="text" v-model="options.version" placeholder="3.0"></i-input>
            </form-item>
            <form-item label="厂商">
                <i-input type="text" v-model="options.publisher" placeholder="Knowlesys Inc."></i-input>
            </form-item>
            <form-item label="URL">
                <i-input type="text" v-model="options.url" placeholder="http://www.knowlesys.cn/"></i-input>
            </form-item>
        </i-form>
    </div>
</template>

<script>
    import {remote} from 'electron'

    export default {
        name: "build-root-path",
        props: {
            options: {
                type: Object,
                required: true,
            },
        },
        methods: {
            handleOpenFile() {
                let path = remote.dialog.showOpenDialog({properties: ['openFile', 'openDirectory', 'multiSelections']})
                this.options.rootPath = path[0]
            }
        }
    }
</script>

<style>

</style>