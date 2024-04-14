<script setup lang="ts">
const props = defineProps<{
  category: Category,
}>()
</script>

<template>
  <span>
    <span :style="`color: ${category.color || category.parent?.color}`">&#11044;</span>
    {{ category.name }}
  </span>
</template>