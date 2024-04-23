<script setup lang="ts">
import { format } from "date-fns"

definePageMeta({
  title: "Transakcje",
  // icon: "house-chimney",
  order: 2,
})

const route = useRoute()

const { data: transactions } = await useFetch<Pagination>("http://localhost:8000/api/transactions/", {
  query: {
    page: route.params.page || 1
  }
})
</script>

<template>
  <div class="flex-down">
    <AppSegment @click="navigateTo('/transactions/create')">
      Dodaj nową
    </AppSegment>

    <AppSegment v-if="!transactions?.data.length">
      Brak transakcji.
    </AppSegment>
    <div v-else class="flex-down">
      <AppSegment>
        <Shoutout label="Strona">
          {{ transactions.current_page }} z {{ transactions.last_page }}
        </Shoutout>
      </AppSegment>

      <template v-for="(t_group, date) of Object.groupBy(transactions.data, ({date}) => format(new Date(date), 'dd.MM.yyyy'))">
        <AppSegment>
          <h2>
            {{ date }}
          </h2>
          <div class="flex-down">
            <AppSegment v-for="transaction of t_group"
              @click="navigateTo(`/transactions/edit/${transaction.id}`)"
            >
              <div class="transactions-list-container">
                <!-- <Shoutout label="Data" :value="format(new Date(transaction.date), 'dd.MM.yyyy')" /> -->
      
                <Shoutout label="Kategoria">
                  <CategoryRender :category="transaction.category" />
                </Shoutout>
      
                <Shoutout label="Konto">
                  <AccountRender :account="transaction.account" />
                </Shoutout>
      
                <Shoutout label="Opis" :value="transaction.description" no-bold />
      
                <Shoutout label="Kwota">
                  <MoneyRender :amount="transaction.amount" />
                </Shoutout>
              </div>
            </AppSegment>
          </div>
        </AppSegment>
      </template>

      <div class="flex-right center tight">
        <AppButton label="Wstecz" />
        <AppButton label="aaa" />
        <AppButton label="Dalej" />
      </div>
    </div>
  </div>
</template>

<style scoped>
.transactions-list-container {
  display: grid;
  --columns: 4;
  grid-template-columns: repeat(var(--columns), 1fr);
}

@media screen and (max-width: 800px) {
  .transactions-list-container {
    --columns: 2;
  }
}

@media screen and (max-width: 500px) {
  .transactions-list-container {
    --columns: 2;
  }
}
</style>