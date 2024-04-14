<script setup lang="ts">
import { format } from "date-fns"

definePageMeta({
  title: "Transakcje",
  // icon: "house-chimney",
  order: 2,
})
const { data: transactions } = await useFetch<Transaction[]>("http://localhost:8000/api/transactions/")
</script>

<template>
  <div class="flex-down">
    <AppSegment @click="navigateTo('/transactions/create')">
      Dodaj nową
    </AppSegment>

    <AppSegment v-if="!transactions?.length">
      Brak transakcji.
    </AppSegment>
    <div v-else>
      <AppSegment v-for="transaction of transactions">
        <div class="grid-3">
          <Shoutout label="Data" :value="format(new Date(transaction.date), 'dd.MM.yyyy')" />

          <Shoutout label="Kategoria">
            <CategoryRender :category="transaction.category" />
          </Shoutout>

          <Shoutout label="Konto">
            <AccountRender :account="transaction.account" />
          </Shoutout>

          <Shoutout label="Opis" :value="transaction.description" />

          <Shoutout label="Kwota">
            <MoneyRender :amount="transaction.amount" />
          </Shoutout>

          <div class="flex-down tight center">
            <AppButton
              label="Edytuj"
              @click="navigateTo(`/transactions/edit/${transaction.id}`)"
            />
          </div>
        </div>
      </AppSegment>
    </div>
  </div>
</template>