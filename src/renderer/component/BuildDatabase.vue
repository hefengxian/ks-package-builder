<template>
    <div style="flex: 1;">
        <i-form label-position="top">
            <form-item label="MySQL BaseDir 目录">
                <i-input  placeholder="D:\KWM\Base\MySQL"
                          v-model="options.mysqlBaseDir"></i-input>
            </form-item>
            <form-item label="MySQL Data 目录">
                <i-input placeholder="D:\KWM\Database_Server\Data"
                         v-model="options.mysqlDataDir"></i-input>
            </form-item>
            <form-item label="MySQL Innodb 内存">
                <InputNumber :min="1"
                             v-model="options.mysqlMemoryPoolSize"
                             :step="1"></InputNumber> <span>GB</span>
            </form-item>
        </i-form>
    </div>
</template>

<script>
    export default {
        name: "build-database",
        props: {
            options: {
                type: Object,
                required: true,
                default() {
                    return {
                        mysqlBaseDir: 'D:\\KWM\\Base\\MySQL',
                        mysqlDataDir: 'D:\\KWM\\Database_Server\\Data',
                        mysqlMemoryPoolSize: 1,
                    }
                }
            }
        },
    }
</script>

<style scoped>

</style>