<template>
    <card dis-hover :bordered="false">
        <strong>TODO</strong> 暂时只是一些说明，计划要把代码准备工作自动化（通过 Git）
    </card>
</template>

<script>
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
    }
</script>

<style scoped>

</style>