<script setup lang="ts">
const router = useRouter()
</script>

<template>
  <nav>
    <AppSegment>
      <div class="flex-right">
        <AppButton v-for="x of router.getRoutes()" 
          :label="(x.meta.title as string)"
          @click="navigateTo(x)"
        />
      </div>
    </AppSegment>
  </nav>
</template>

<style scoped>
nav{
  text-align: right;
  gap: 0.2em 0.5em !important;
}
</style>