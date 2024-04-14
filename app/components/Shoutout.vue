<script setup lang="ts">
const props = defineProps<{
  label?: string,
  value?: any,
  colorInLabel?: string,
  colorInValue?: string,
}>()
const display_value: string = props.value || "—"
</script>

<template>
  <div class="shoutout flex-down tight">
    <label>
      <slot name="label">{{ props.label }}</slot>
    </label>
    <strong>
      <slot>{{ display_value ?? "—" }}</slot>
    </strong>
  </div>
</template>

<style scoped>
.shoutout strong{
  font-size: 1.25em;
}
</style>