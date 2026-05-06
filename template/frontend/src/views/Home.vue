<!--
  示例首页

  设计规范：
  - 外层 padding: 20px 24px
  - 卡片间距: n-space :size="16"
  - 卡片圆角: 20px（大圆角风格）
  - 主操作按钮: 圆角 8px / 高度 42px
-->
<template>
  <div style="padding: 20px 24px">
    <n-space vertical :size="16">
      <n-card title="{{APP_TITLE}}" :bordered="false" style="border-radius: 20px">
        <n-text>{{ appDescription }}</n-text>
      </n-card>

      <n-card :bordered="false" style="border-radius: 20px">
        <n-space align="center">
          <n-button type="primary" class="primary-button" @click="handleAction">
            示例操作
          </n-button>
          <n-text depth="3">{{ statusText }}</n-text>
        </n-space>
      </n-card>
    </n-space>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { NCard, NSpace, NButton, NText, useMessage } from 'naive-ui'

const message = useMessage()
const appDescription = '{{APP_DESCRIPTION}}'
const statusText = ref('就绪')

function handleAction() {
  message.success('Hello from {{APP_TITLE}}')
  statusText.value = '已点击'
}
</script>

<style scoped>
.primary-button {
  border-radius: 8px;
  height: 42px;
}
</style>
