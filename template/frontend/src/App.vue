<!--
  应用整体布局壳

  设计规范（来自 docs/01-design-system.md）：
  - 侧边栏宽度固定 200px
  - Logo 区 padding: 20px
  - 内容区背景 #f5f7fa
  - 滚动条使用 Naive 自定义（:native-scrollbar="false"）

  可选模块：
  - 暗黑主题切换（默认未启用，启用方式见注释）
-->
<template>
  <n-config-provider>
    <n-message-provider>
      <n-dialog-provider>
        <n-notification-provider>
          <n-layout has-sider style="height: 100vh">
            <n-layout-sider
              bordered
              :width="200"
              :native-scrollbar="false"
              style="display: flex; flex-direction: column"
            >
              <div style="flex: 1">
                <div style="padding: 20px; text-align: center">
                  <h2 style="margin: 0">{{ appName }}</h2>
                </div>
                <n-menu
                  v-model:value="activeKey"
                  :options="menuOptions"
                  @update:value="handleMenuUpdate"
                />
              </div>

              <!-- 可选：暗黑主题切换开关 -->
              <!-- 启用步骤：
                   1. 在下方 script 中取消 isDark / theme 注释
                   2. 在 n-config-provider 上加 :theme="theme"
                   3. 在 backend/app.go 启用 SetDarkMode 方法
              -->
              <!--
              <div style="padding: 16px; border-top: 1px solid var(- -n-border-color)">
                <div style="display: flex; align-items: center; justify-content: center; gap: 10px">
                  <n-icon :size="20" :color="isDark ? '#ffd93d' : '#f59e0b'">
                    <sunny-outline />
                  </n-icon>
                  <n-switch v-model:value="isDark" size="medium" />
                  <n-icon :size="20" :color="isDark ? '#60a5fa' : '#94a3b8'">
                    <moon-outline />
                  </n-icon>
                </div>
              </div>
              -->
            </n-layout-sider>

            <n-layout-content
              :native-scrollbar="false"
              style="background: #f5f7fa"
              content-style="background: #f5f7fa; min-height: 100%"
            >
              <router-view />
            </n-layout-content>
          </n-layout>
        </n-notification-provider>
      </n-dialog-provider>
    </n-message-provider>
  </n-config-provider>
</template>

<script setup lang="ts">
import { h, ref } from 'vue'
import { useRouter } from 'vue-router'
import {
  NConfigProvider,
  NMessageProvider,
  NDialogProvider,
  NNotificationProvider,
  NLayout,
  NLayoutSider,
  NLayoutContent,
  NMenu,
  NIcon,
  type MenuOption,
} from 'naive-ui'
import { HomeOutline } from '@vicons/ionicons5'

// ===== 暗黑主题（可选，默认未启用） =====
// import { computed, watch, provide } from 'vue'
// import { darkTheme, NSwitch } from 'naive-ui'
// import { MoonOutline, SunnyOutline } from '@vicons/ionicons5'
// import { SetDarkMode } from '../wailsjs/go/backend/App'
// const isDark = ref(false)
// const theme = computed(() => (isDark.value ? darkTheme : null))
// provide('isDark', isDark)
// watch(isDark, (v) => SetDarkMode(v))

const appName = '{{APP_TITLE}}'
const router = useRouter()
const activeKey = ref('/')

const menuOptions: MenuOption[] = [
  {
    label: '首页',
    key: '/',
    icon: () => h(NIcon, null, { default: () => h(HomeOutline) }),
  },
  // 在这里添加更多菜单项
]

function handleMenuUpdate(key: string) {
  router.push(key)
}

router.afterEach((to) => {
  activeKey.value = to.path
})
</script>

<style>
html,
body,
#app {
  background: #f5f7fa;
  margin: 0;
  padding: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto,
    'Helvetica Neue', Arial, 'Noto Sans', sans-serif,
    'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
</style>
