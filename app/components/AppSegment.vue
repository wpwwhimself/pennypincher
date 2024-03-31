<script setup lang="ts">
const props = defineProps<{
  extraClasses?: string,
}>()
const slots = useSlots()
const hasOnClick = computed(() => !!getCurrentInstance()?.vnode.props?.onClick)
</script>

<template>
  <div :class="[
    `segment`,
    `flex-right`,
    hasOnClick && `clickable`,
    props.extraClasses,
  ].filter(Boolean).join(' ')">
    <div class="icon" v-if="slots.icon">
      <slot name="icon" />
    </div>
    <div class="content">
      <slot />
    </div>
  </div>
</template>

<style scoped>
.segment {
  background-color: hsla(var(--bg2), 0.2);
  padding: 1em 2em;
  position: relative;
  min-height: 1em;
  
  --tip-size: 2em;
  --path: polygon(
    0 100%,
    calc(100% - var(--tip-size)) 100%,
    100% calc(100% - var(--tip-size)),
    100% 0,
    var(--tip-size) 0,
    0 var(--tip-size)
  );
  clip-path: var(--path);
  
  &:hover {
    background-color: hsla(var(--bg2), 0.4);
  }
  &.accent {
    color: inherit !important;
    border: 2px solid hsl(var(--acc));
  
    &::before, &::after {
      content: "";
      position: absolute;
      border: calc(var(--tip-size) / 2) solid hsl(var(--acc));
    }
    &::before {
      top: 0; left: 0;
      border-right-color: transparent;
      border-bottom-color: transparent;
    }
    &::after {
      bottom: 0; right: 0;
      border-top-color: transparent;
      border-left-color: transparent;
    }
  }
  &.button {
    padding-block: 0.5em;
    --tip-size: 1em;
  }
}
</style>