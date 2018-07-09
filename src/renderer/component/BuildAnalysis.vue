<template>
    <div style="flex: 1;">
        <i-form label-position="top">
            <form-item label="数据库 IP">
                <i-input  placeholder="D:\KWM\Base\MySQL"
                          v-model="options.analysisDBIP"></i-input>
            </form-item>
            <form-item label="Solr Data 目录">
                <i-input placeholder="D:\KWM\Analysis_Server\Solr_Data"
                         v-model="options.solrDataDir"></i-input>
            </form-item>
        </i-form>
    </div>
</template>

<script>
    export default {
        name: "build-analysis",
        props: {
            options: {
                type: Object,
                required: true,
                default() {
                    return {}
                }
            }
        },
    }
</script>

<style scoped>

</style>