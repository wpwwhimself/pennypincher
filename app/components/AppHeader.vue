<script setup lang="ts">
const appConfig = useAppConfig()
const route = useRoute()
</script>

<template>
  <header class="flex-down">
    <AppSegment>
      <div class="flex-down">
        <div class="flex-right">
          <AppLogo />
          <div>
            <h1>
              <Icon v-if="route.meta.icon" :name="route.meta.icon ? `fluent-mdl2:${route.meta.icon}` : ''" />
              {{ route.meta.title }}
            </h1>
            <p class="accent">{{ appConfig.title }}</p>
          </div>
        </div>
        <div id="nav-container">
          <AppNav />
        </div>
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
  --height: calc(2em + 1em + 2.5em);
  height: var(--height);
}
#nav-container {
  opacity: 0;
}
header:hover {
  height: calc(var(--height) + 3em + 0.5em);

  & #nav-container {
    opacity: 1;
  }
}
</style>