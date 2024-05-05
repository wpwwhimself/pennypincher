<script setup lang="ts">
const props = defineProps<{
  amount?: number,
  plusGreen?: boolean,
}>()
</script>

<template>
  <span :class="[
    (amount || 0) < 0 && 'bottom',
    amount == 0 && 'middle',
    (amount || 0) > 0 && plusGreen && 'top',
  ].filter(Boolean).join(' ')">
    {{ asPln(amount) || "—" }}
  </span>
</template>

<style scoped>
.bottom {
  color: hsl(0, 75%, 50%);
}
.middle {
  color: hsl(0, 0%, 50%);
}
.top {
  color: hsl(100, 75%, 50%);
}
</style>