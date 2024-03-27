<script setup lang="ts">
const appConfig = useAppConfig()
const route = useRoute()
</script>

<template>
  <header class="flex-down">
    <AppSegment>
      <div class="flex-right">
        <AppLogo />
        <div>
          <h1>{{ route.meta.title }}</h1>
          <p class="accent">{{ appConfig.title }}</p>
        </div>
      </div>
      <div id="nav-container">
        <AppNav />
      </div>
    </AppSegment>
  </header>
</template>

<style scoped>
h1, p {
  margin: 0;
  text-align: left;
}
header {
  overflow: hidden;
  --height: calc(1.5em + 1em + 2em);
  height: var(--height);
}
#nav-container {
  opacity: 0;
}
header:hover {
  height: calc(var(--height) + 3em + 1em);

  & #nav-container {
    opacity: 1;
  }
}
</style>