<script setup lang="ts">
import { format } from "date-fns"

const config = useAppConfig()
definePageMeta({
  title: "Transakcje",
  icon: "group-list",
  showInNav: true,
  order: 2,
})

const route = useRoute()

const { data: transactions } = await useLazyFetch<Pagination>(`${config.apiUrl}transactions/`, {
  query: {
    page: (route.params.query && route.params.query[0] == "page") ? route.params.query[1] : 1,
    account: route.query.account,
    category: route.query.category,
  },
  server: false,
})
watch(transactions, (refreshed) => {})

const changePage = (p: number) => {
  navigateTo({
    path: `/transactions/page/${p}`,
    query: route.query
  })
  window.scroll({
    top: 0,
    behavior: "smooth",
  })
}
</script>

<template>
  <Loader v-if="!transactions" />
  <div v-else class="flex-down">
    <AppButton @click="navigateTo('/transactions/create')" label="Dodaj nową" icon="add" />

    <AppSegment v-if="transactions?.data.length == 0">
      Brak transakcji.
    </AppSegment>

    <div class="flex-down" v-else>
      <Paginator
        v-if="transactions!.data.length != 0"
        :data="transactions"
        @change-page="changePage"
      />

      <template v-for="(t_group, date) of transactions!.data">
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
        v-if="transactions!.data.length != 0"
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