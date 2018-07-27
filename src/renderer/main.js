import 'iview/dist/styles/iview.css'
import 'github-markdown-css'

import Vue from 'vue'

import App from './App'
import iView from 'iview'

if (!process.env.IS_WEB) Vue.use(require('vue-electron'))
Vue.config.productionTip = false

Vue.use(iView)

/* eslint-disable no-new */
new Vue({
    components: {App},
    template: '<App/>'
}).$mount('#app')
