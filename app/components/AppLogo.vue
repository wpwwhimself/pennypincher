<script setup lang="ts">
const params = defineProps<{
  small?: boolean,
}>()
</script>

<template>
  <img
    src="/icon.svg" alt="logo"
    :class="[
      small && 'small',
    ].filter(Boolean).join(' ')"
  >
</template>

<style scoped>
img {
  max-width: 3.5em;

  &.small {
    height: 1.75em;
  }
}
footer{
  background-color: black;
  color: white;
  padding: 1em 2em;
  display: grid;
  grid-template-columns: auto 1fr 5em;
  align-items: center;
  width: 100vw;
  box-sizing: border-box;
  flex-shrink: 0;
}
footer .titles *{
  text-align: right;
}
</style>