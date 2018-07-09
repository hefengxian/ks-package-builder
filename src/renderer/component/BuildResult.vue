<template>
    <div>
        build-result
    </div>
</template>

<script>
    export default {
        name: "build-result",
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