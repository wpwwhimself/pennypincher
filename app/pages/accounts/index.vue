<script setup lang="ts">
definePageMeta({
  title: "Konta",
  // icon: "house-chimney",
  order: 4,
})
const router = useRouter()
const accounts = [1, 2, 3]
</script>

<template>
  <div class="flex-down">
    <AppSegment>
      <AppButton label="Dodaj nowe" @click="navigateTo('accounts/add')" />
    </AppSegment>

    <div class="grid-2">
      <AppSegment v-for="account of accounts">
        <p>Tu będzie lista wszystkich kont</p>
      </AppSegment>
    </div>
  </div>
</template>