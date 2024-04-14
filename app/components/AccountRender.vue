<script setup lang="ts">
const props = defineProps<{
  account: Account,
}>()
</script>

<template>
  <span>
    <span :style="`color: ${account.color}`">&#11044;</span>
    {{ account.name }}
  </span>
</template>