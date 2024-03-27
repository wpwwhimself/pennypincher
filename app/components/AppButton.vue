<script setup lang="ts">
const props = defineProps<{
  label: string,
  icon?: string,
}>()
</script>

<template>
  <AppSegment extra-classes="accent clickable">
    {{ props.label }}
  </AppSegment>
</template>