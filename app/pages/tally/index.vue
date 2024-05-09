<script setup lang="ts">
definePageMeta({
  title: "Podliczacz",
  icon: "calculator",
  order: 5,
})

interface Term {
  label?: string,
  count?: number,
  multi: number,
}

const sum = ref(0)
const terms = ref<Term[]>([])
const target = ref(0)

const {data: accounts, error} = await useFetch<Account[]>(`http://localhost:8000/api/accounts/`)

const updateTarget = (val: number) => {
  target.value = val
}

const updateSum = () => {
  sum.value = terms.value?.reduce((total, term) => total + (term.count || 0) * term.multi, 0) || 0
}

const updateTerm = (index: number, field: "count" | "multi", val: number) => {
  terms.value[index][field] = val
  updateSum()
}

const addTerm = () => {
  const newItem: Term = {
    multi: 1,
  };
  terms.value = (terms.value) ? [...terms.value, newItem] : [newItem]
}

const prepareTemplate = (template_name: string) => {
  switch (template_name) {
    case "cash":
      terms.value = [
        {label: "500 zł", multi: 500},
        {label: "200 zł", multi: 200},
        {label: "100 zł", multi: 100},
        {label: "50 zł", multi: 50},
        {label: "20 zł", multi: 20},
        {label: "10 zł", multi: 10},
        {label: "5 zł", multi: 5},
        {label: "2 zł", multi: 2},
        {label: "1 zł", multi: 1},
        {label: "50 gr", multi: 0.5},
        {label: "20 gr", multi: 0.2},
        {label: "10 gr", multi: 0.1},
        {label: "5 gr", multi: 0.05},
        {label: "2 gr", multi: 0.02},
        {label: "1 gr", multi: 0.01},
      ]
      break
  }
}
</script>

<template>
  <div class="flex-down">
    <div class="grid-2">
      <AppSegment>
        <div class="flex-down">
          <Shoutout label="Suma">
            <MoneyRender :amount="sum" />
          </Shoutout>

          <AppInput
            type="number" step="0.01"
            name="target"
            label="Cel"
            :value="target.toString()"
            @input="updateTarget($event.target.value)"
          />
          
          <Shoutout label="Różnica względem celu">
            <MoneyRender :amount="sum - target" plus-green />
          </Shoutout>
        </div>
      </AppSegment>

      <AppSegment>
        <div class="flex-down">
          <h2>Szablony podliczacza</h2>

          <div class="flex-right tight">
            <AppButton label="Gotówka" icon="money" @click="prepareTemplate('cash')" />
          </div>

          <h2>Porównaj z kontem</h2>

          <div class="flex-right tight">
            <AppButton v-for="account in accounts"
              :label="account.name"
              @click="updateTarget(account.balance)"
            />
          </div>
        </div>
      </AppSegment>
    </div>

    <AppSegment>
      <span v-if="terms.length == 0">
        Brak składników do sumowania
      </span>

      <div class="grid-4" v-else v-for="(term, i) in terms">
        <AppInput
          name="label"
          :label="i == 0 ? 'Nazwa' : ''"
          :value="term.label || ''"
        />

        <AppInput
          type="number" step="0.01"
          name="multi"
          :label="i == 0 ? 'Mnożnik' : ''"
          :value="term.multi.toString()"
          @input="updateTerm(i, 'multi', $event.target.value)"
        />

        <AppInput
          type="number" step="0.01"
          name="count"
          :label="i == 0 ? 'Liczba' : ''"
          :value="(term.count || 0).toString()"
          @input="updateTerm(i, 'count', $event.target.value)"
        />

        <Shoutout
          :label="i == 0 ? 'Suma' : ''"
        >
          <MoneyRender :amount="(term.count || 0) * term.multi" />
        </Shoutout>
      </div>
    </AppSegment>

    <AppButton label="Dodaj składnik" @click="addTerm" icon="add" />
  </div>
</template>

<style scoped>
.row {
  justify-content: center;
  align-items: center;
}
</style>