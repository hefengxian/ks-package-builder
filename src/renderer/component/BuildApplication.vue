<template>
    <div>
        build-application
    </div>
</template>

<script>
    export default {
        name: "build-application",
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