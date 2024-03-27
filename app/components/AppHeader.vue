<script setup lang="ts">
const appConfig = useAppConfig()
const route = useRoute()
</script>

<template>
  <header>
    <AppSegment>
      <template #icon>
        <AppLogo />
      </template>
      <template>
        <h1>{{ route.meta.title }}</h1>
        <p class="accent">{{ appConfig.title }}</p>
      </template>
    </AppSegment>
  </header>
</template>

<style scoped>
h1, p {
  margin: 0;
  text-align: left;
}
</style>