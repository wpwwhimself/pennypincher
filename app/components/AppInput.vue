<script setup lang="ts">
const props = withDefaults(defineProps<{
  type?: string,
  name: string,
  label: string,
  description?: string,
  value: string,
}>(), {
  type: "text",
});
</script>

<template>
  <div class="input-container flex-down tight">
    <label :for="name">{{ label }}</label>
    <input :type="type" :id="name" :name="name" :value="value" :="$attrs" />
  </div>
</template>

<style scoped>
.input-container {
  justify-content: stretch;

  & input{
    background: none;
    border: none;
    border-bottom: 2px solid hsl(var(--fg), 0.3);
    box-sizing: border-box;
    color: inherit;
    font-family: inherit;
    font-weight: bold;
    font-size: 1.25em;
    outline: 0 none;
    padding: 0;

    &:focus {
      border-color: hsl(var(--acc));
    }
  }
}
</style>
