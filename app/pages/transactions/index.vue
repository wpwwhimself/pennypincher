<script setup lang="ts">
import { format } from "date-fns"

definePageMeta({
  title: "Transakcje",
  // icon: "house-chimney",
  order: 2,
})

const route = useRoute()
const page = ref(1)

const { data: transactions } = await useFetch<Pagination>("http://localhost:8000/api/transactions/", {
  query: {
    page: page,
    account: route.query.account,
    category: route.query.category,
  },
})

const changePage = (p: number) => {
  navigateTo({
    query: {
      ...route.query,
      page: p,
    }
  })
  page.value = p
  window.scroll({
    top: 0,
    behavior: "smooth",
  })
}
</script>

<template>
  <div class="flex-down">
    <AppSegment @click="navigateTo('/transactions/create')">
      Dodaj nową
    </AppSegment>

    <AppSegment v-if="transactions?.data.length == 0">
      Brak transakcji.
    </AppSegment>

    <div class="flex-down" v-else>
      <template v-for="(t_group, date) of transactions.data">
        <AppSegment>
          <h2>
            {{ format(new Date(date), 'dd.MM.yyyy') }}
          </h2>
          <div class="flex-down">
            <AppSegment v-for="transaction of t_group"
              @click="navigateTo(`/transactions/edit/${transaction.id}`)"
            >
              <div class="transactions-list-container">
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

      <Paginator
        v-if="transactions.data.length != 0"
        :data="transactions"
        @change-page="changePage"
      />
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