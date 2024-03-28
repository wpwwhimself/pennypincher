<script setup lang="ts">
const props = defineProps<{
  label: string,
  value?: string | number,
}>()
</script>

<template>
  <div class="shoutout flex-down tight">
    <label>{{ props.label }}</label>
    <strong>{{ props.value ?? "—" }}</strong>
  </div>
</template>

<style scoped>
.shoutout strong{
  font-size: 1.25em;
}
</style>