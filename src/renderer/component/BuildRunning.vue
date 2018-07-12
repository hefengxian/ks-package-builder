<template>
    <card dis-hover :bordered="false">
        <pre id="logs"
             style="overflow: auto;"
             ref="logs">{{logStr}}</pre>
    </card>
</template>

<script>
    export default {
        name: "build-running",
        props: {
            logs: {
                type: Array
            }
        },
        computed: {
            logStr() {
                this.$nextTick(() => {
                    document.querySelector(".content").scrollTop = document.querySelector("#logs").scrollHeight
                })
                return this.logs.join('\n')
            }
        },
    }
</script>

<style>

</style>