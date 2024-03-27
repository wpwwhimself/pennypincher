<script setup lang="ts">
const appConfig = useAppConfig()
</script>

<template>
  <footer>
    <AppSegment>
      <template>
        <span>{{ appConfig.title }}</span>
      </template>
    </AppSegment>
  </footer>
</template>