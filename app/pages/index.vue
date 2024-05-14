<script setup lang="ts">
definePageMeta({
  title: "Kokpit",
  icon: "home",
  showInNav: true,
  order: 1,
})

const {data: accounts, error} = await useLazyFetch<Account[]>(`http://localhost:8000/api/accounts/`, {server: false})
watch(accounts, (refreshed) => {})
</script>

<template>
  <Loader v-if="!accounts" />
  <div v-else class="flex-down">
    <AppSegment>
      <Shoutout label="Całkowity stan konta">
        <MoneyRender :amount="accounts?.reduce((a, b) => a + b.balance, 0) || 0" />
      </Shoutout>
    </AppSegment>

    <div class="grid-2">
      <AppSegment v-for="account of accounts"
        @click="navigateTo({
          path: `/transactions`,
          query: {account: account.id}
        })"
      >
        <Shoutout>
          <template v-slot:label><AccountRender :account="account" /></template>
          <MoneyRender :amount="account.balance" />
        </Shoutout>
      </AppSegment>
    </div>
  </div>
</template>