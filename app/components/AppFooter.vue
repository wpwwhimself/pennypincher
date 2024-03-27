<script setup lang="ts">
const appConfig = useAppConfig()
</script>

<template>
  <footer>
    <h2>{{ appConfig.title }}r</h2>
    <AppLogo />
  </footer>
</template>