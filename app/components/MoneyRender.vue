<script setup lang="ts">
const props = defineProps<{
  amount: number,
}>()
</script>

<template>
  <span :style="amount <= 0 && 'color: red'">
    {{ asPln(amount) || "—" }}
  </span>
</template>