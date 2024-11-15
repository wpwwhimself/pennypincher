<script setup lang="ts">
const props = defineProps<{
  label: string,
  icon?: string,
  highlighted?: boolean,
  textColor?: string,
  iconColor?: string,
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
    <Icon v-if="icon" :name="`fluent-mdl2:${icon}`" :style="iconColor && `color: ${iconColor} !important`" />
    {{ label }}
  </AppSegment>
</template>