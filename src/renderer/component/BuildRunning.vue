<template>
    <div>
        build-running
    </div>
</template>

<script>
    export default {
        name: "build-running",
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