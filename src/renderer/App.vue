<template>
    <div id="app">
        <div class="ks-left">
            <Steps :current="0" direction="vertical">
                <Step title="构建目录"
                      icon="folder"
                      content="构建项目的根目录"></Step>
                <Step title="生成输入文件"
                      icon="filing"
                      content="准备输入的各种文件"></Step>
                <Step title="配置数据库服务器"
                      icon="soup-can"
                      content="数据库服务器配置"></Step>
                <Step title="配置分析服务器"
                      icon="ios-pulse"
                      content="分析服务器配置"></Step>
                <Step title="配置应用服务器"
                      icon="monitor"
                      content="应用服务器配置"></Step>
                <Step title="配置应 Fetch 服务器"
                      icon="android-download"
                      content="Fetch 服务器配置"></Step>
                <Step title="运行构建"
                      icon="gear-a"
                      content="运行构建，查看日志"></Step>
            </Steps>
        </div>
        <div class="ks-right">
            <div class="content">
                <p v-for="i in 40">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Adipisci eaque error eveniet laborum libero maiores nemo officia provident quas quia? Accusantium aliquam excepturi nesciunt quibusdam repellendus rerum sequi tempore voluptates.</p>
            </div>
            <div class="action">
                <div class="action-left">
                    <Button type="primary">上一步</Button>
                    <Button type="primary">下一步</Button>
                </div>
                <div class="action-right">
                    <Button type="success">完成</Button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    export default {
        name: 'ks-package-builder',
        components: {}
    }
</script>

<style lang="less">
    #app {
        display: flex;
        height: 100vh;
        overflow: hidden;

        & .ks-left {
            height: 100vh;
            overflow: auto;
            padding: 16px;
            max-width: 280px;
            border-right: 1px solid #f0f0f0;
        }
        & .ks-right {
            flex: 1;
            height: 100vh;

            display: flex;
            flex-direction: column;

            & .content {
                overflow: auto;
                flex: 1;
                padding: 16px;
            }
            & .action {
                padding: 16px;
                display: flex;
                & .action-left, & .action-right {
                    flex: 1;
                }
                & .action-right {
                    display: flex;
                    flex-direction: row-reverse;
                }
            }
        }
    }
</style>
