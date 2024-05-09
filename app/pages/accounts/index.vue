<script setup lang="ts">
definePageMeta({
  title: "Konta",
  icon: "bank",
  order: 4,
})
const { data: accounts } = await useFetch<Account[]>("http://localhost:8000/api/accounts/")
</script>

<template>
  <div class="flex-down">
    <AppButton @click="navigateTo('/accounts/create')" icon="add" label="Dodaj nowe" />

    <AppSegment v-if="!accounts?.length">
      Brak utworzonych kont. Dodaj nowe konto.
    </AppSegment>
    <div class="grid-2" v-else>
      <AppSegment v-for="account of accounts">
        <div class="flex-down">
          <div>
            <h2>
              <AccountRender :account="account" />
            </h2>
            <p v-if="account.description">{{ account.description }}</p>
          </div>

          <div class="flex-right tight">
            <AppButton label="Edytuj" @click="navigateTo(`/accounts/edit/${account.id}`)" icon="edit" />
            <AppButton label="Transakcje" @click="navigateTo({ path: `/transactions`, query: { account: account.id }})" icon="group-list" />
          </div>
        </div>
      </AppSegment>
    </div>
  </div>
</template>