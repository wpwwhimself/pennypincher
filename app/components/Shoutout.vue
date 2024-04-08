<script setup lang="ts">
const props = defineProps<{
  label: string,
  value?: string | number,
  color?: string,
}>()
</script>

<template>
  <div class="shoutout flex-down tight">
    <label>
      <span v-if="props.color" :style="`color: ${props.color}`">&#11044;</span>
      {{ props.label }}
    </label>
    <strong>{{ props.value ?? "—" }}</strong>
  </div>
</template>

<style scoped>
.shoutout strong{
  font-size: 1.25em;
}
</style>