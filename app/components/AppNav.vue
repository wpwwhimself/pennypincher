<script setup lang="ts">
const router = useRouter()

const navigatable = router.getRoutes()
  .filter(route => route.name?.toString().indexOf("-") == -1)
  .sort((a, b) => (a.meta.order as number) - (b.meta.order as number))
</script>

<template>
  <nav class="flex-right">
    <AppButton v-for="x in navigatable"
      :label="(x.meta.title as string)"
      @click="navigateTo(x)"
    />
  </nav>
</template>

<style scoped>
nav{
  text-align: right;
  gap: 0.2em 0.5em !important;
}
</style>