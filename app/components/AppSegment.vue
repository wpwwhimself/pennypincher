<script setup lang="ts">
const props = defineProps<{
  extraClasses?: string,
}>()
const slots = useSlots()
</script>

<template>
  <div :class="`segment flex-right ${props.extraClasses}`">
    <div class="icon" v-if="slots.icon">
      <slot name="icon" />
    </div>
    <div class="content flex-down">
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
    border: 0.2em solid hsl(var(--acc));
    color: inherit !important;
    padding-block: 0.5em;

    --tip-size: 1em;

    &:hover {
      background-color: hsl(var(--acc));
    }
    &::before, &::after {
      content: "";
      position: absolute;
      border: calc(var(--tip-size) / 2 - 1px) solid hsl(var(--acc));
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
}
</style>