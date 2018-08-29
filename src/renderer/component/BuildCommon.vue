<template>
    <card dis-hover :bordered="false">
        <i-form label-position="top" >
            <form-item label="构建根目录">
                <row :gutter="16" type="flex">
                    <i-col style="flex: 1;">
                        <i-input type="text" v-model="data.options.rootPath" placeholder="例如：D:\KWM_BUILD_PLATFORM"></i-input>
                    </i-col>
                    <i-col>
                        <i-button type="primary" icon="folder" @click="handleOpenFile">打开</i-button>
                    </i-col>
                </row>
            </form-item>

            <form-item label="数据库 IP">
                <i-input  placeholder="D:\KWM\Base\MySQL"
                          v-model="data.options.dbIP"></i-input>
            </form-item>

            <row :gutter="16">
                <i-col :span="12">
                    <form-item label="版本">
                        <i-input type="text" v-model="data.options.version" placeholder="3.0"></i-input>
                    </form-item>
                </i-col>
                <i-col :span="12">
                    <form-item label="厂商">
                        <i-input type="text" v-model="data.options.publisher" placeholder="Knowlesys Inc."></i-input>
                    </form-item>
                </i-col>
            </row>

            <row :gutter="16">
                <i-col :span="12">
                    <form-item label="URL">
                        <i-input type="text" v-model="data.options.url" placeholder="http://www.knowlesys.cn/"></i-input>
                    </form-item>
                </i-col>
                <i-col :span="12">
                    <form-item label="打包压缩算法">
                        <i-select v-model="data.options.compress">
                            <i-option v-for="(algorithm, key) in compressAlgorithms"
                                      :key="key"
                                      :value="algorithm.value"
                                      :label="algorithm.label"></i-option>
                        </i-select>
                    </form-item>
                </i-col>
            </row>
        </i-form>
    </card>
</template>

<script>
    import {remote, shell} from 'electron'
    import fs from 'fs'
    import path from 'path'
    import MarkdownIt from 'markdown-it'

    export default {
        name: "build-root-path",
        props: {
            data: {
                type: Object,
                required: true,
            },
        },
        data() {
            return {
                compressAlgorithms: [
                    {
                        value: 'zip',
                        label: 'zip',
                    },
                    {
                        value: 'zip/1',
                        label: 'zip/1',
                    },
                    {
                        value: 'bzip',
                        label: 'bzip',
                    },
                    {
                        value: 'bzip/1',
                        label: 'bzip/1',
                    },
                    {
                        value: 'lzma',
                        label: 'lzma',
                    },
                    {
                        value: 'lzma/fast',
                        label: 'lzma/fast',
                    },
                    {
                        value: 'lzma/normal',
                        label: 'lzma/normal',
                    },
                    {
                        value: 'lzma/max',
                        label: 'lzma/max',
                    },
                    {
                        value: 'lzma/ultra',
                        label: 'lzma/ultra',
                    },
                    {
                        value: 'lzma/ultra64',
                        label: 'lzma/ultra64',
                    },
                    {
                        value: 'lzma2',
                        label: 'lzma2',
                    },
                    {
                        value: 'lzma2/fast',
                        label: 'lzma2/fast',
                    },
                    {
                        value: 'lzma2/normal',
                        label: 'lzma2/normal',
                    },
                    {
                        value: 'lzma2/max',
                        label: 'lzma2/max',
                    },
                    {
                        value: 'lzma2/ultra',
                        label: 'lzma2/ultra',
                    },
                    {
                        value: 'lzma2/ultra64',
                        label: 'lzma2/ultra64',
                    },
                    {
                        value: 'none',
                        label: 'none',
                    },
        ]
            }
        },
        methods: {
            handleOpenFile() {
                let path = remote.dialog.showOpenDialog({properties: ['openFile', 'openDirectory', 'multiSelections']})
                this.data.options.rootPath = path[0]
            }
        },
        beforeDestroy() {
        },
    }
</script>

<style>

</style>