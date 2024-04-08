<script setup lang="ts">
const appConfig = useAppConfig()
const route = useRoute()
useHead({
  title: (route.meta.title as string),
  titleTemplate: `%s | ${appConfig.title}`,
})
</script>

<template>
  <AppHeader />
  <NuxtLoadingIndicator />
  <div id="main-wrapper">
    <NuxtPage />
  </div>
  <AppFooter />
</template>

<style scoped>
#main-wrapper{
  box-sizing: border-box;
  flex: 1 0 auto;
}
</style>