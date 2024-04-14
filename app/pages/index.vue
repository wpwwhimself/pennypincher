<script setup lang="ts">
definePageMeta({
  title: "Kokpit",
  icon: "house-chimney",
  order: 1,
})

const {data: accounts, error} = await useFetch<Account[]>(`http://localhost:8000/api/accounts/`)
</script>

<template>
  <div class="flex-down">
    <AppSegment>
      <Shoutout label="Całkowity stan konta" />
    </AppSegment>

    <div class="grid-2">
      <AppSegment v-for="ac of accounts"
        @click="navigateTo(`/transactions/account/${ac.id}`)"
      >
        <Shoutout :label="ac.name" :color-in-label="ac.color" />
      </AppSegment>
  
    </div>
  </div>
</template>