<script setup lang="ts">
const props = defineProps<{
  label: string,
  labelOnHover?: string,
  icon?: string,
  highlighted?: boolean,
  textColor?: string,
}>()
</script>

<template>
  <AppSegment
    :extra-classes="[
      `button`,
      highlighted && `accent`,
    ].filter(Boolean).join(' ')"
    :style="textColor && `color: ${textColor} !important`"
    @mouseover=""
    @mouseleave=""
  >
    {{ label }}
  </AppSegment>
</template>