import { createRouter, createWebHashHistory, type RouteRecordRaw } from 'vue-router'

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    name: 'Home',
    component: () => import('@/views/Home.vue'),
  },
  // 在这里添加更多路由
]

const router = createRouter({
  history: createWebHashHistory(),
  routes,
})

export default router
