<script setup lang="ts">
const router = useRouter()

const navigatable = router.getRoutes()
  .filter(route => route.meta.showInNav)
  .sort((a, b) => (a.meta.order as number) - (b.meta.order as number))
</script>

<template>
  <nav class="flex-right tight">
    <AppButton v-for="x in navigatable"
      :label="(x.meta.title as string)"
      :icon="(x.meta.icon as string)"
      @click="navigateTo(x)"
    />
  </nav>
</template>

<style scoped>
nav{
  text-align: right;
}
</style>