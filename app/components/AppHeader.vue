<script setup lang="ts">
const appConfig = useAppConfig()
</script>

<template>
  <header>
    <AppLogo />
    <div>
      <h1>{{ appConfig.title }}</h1>
      <h2>{{ appConfig.title }}</h2>
    </div>
  </header>
</template>

<style scoped>

</style>