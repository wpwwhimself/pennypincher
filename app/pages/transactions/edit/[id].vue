<script setup lang="ts">
import { format } from 'date-fns';
import { create, all, round } from "mathjs"

definePageMeta({
  title: "Edytuj transakcję",
  icon: "edit",
})
const [route, router] = [useRoute(), useRouter()]

const { data: transaction, error } = await useLazyFetch<Transaction>(`http://localhost:8000/api/transactions/${route.params.id}/`)
watch(transaction, (refreshed) => {})

let date = ref(format(new Date(transaction.value?.date || ""), "yyyy-MM-dd"))
let category_id = ref(transaction.value?.category_id.toString() || "")
let account_id = ref(transaction.value?.account_id.toString() || "")
let description = ref(transaction.value?.description || "")
let amount = ref(transaction.value?.amount)
let formula = ref("")

const math = create(all)

const updateRef = (target: string, val: string) => {
  const refTable = {
    date: date,
    category_id: category_id,
    account_id: account_id,
    description: description,
    amount: amount,
    formula: formula,
  };

  refTable[target as keyof typeof refTable].value = val;

  switch (target) {
    case "formula": runFormula(); break
    case "amount": formula.value = ""; break
  }
}

const handleSubmit = async () => {
  const {data, error} = await useFetch(`http://localhost:8000/api/transactions/edit/${route.params.id}`, {
    method: "post",
    body: {
      date: date.value,
      category_id: category_id.value,
      account_id: account_id.value,
      description: description.value,
      amount: amount.value,
    }
  })

  if (error.value) {
    //todo error
    console.error(error.value)
  }

  navigateTo("/transactions")
}

const runFormula = () => {
  const f = formula.value.replace(/,/g, ".")

  try {
    const result: number = math.evaluate(f)
    amount.value = math.round(result, 2)
  } catch (err) {
    amount.value = undefined
  }
}
</script>

<template>
  <Loader v-if="!transaction" />
  <div v-else class="flex-down">
    <AppButton @click="navigateTo('/transactions')" label="Wróć do listy" icon="back" />

    <div class="grid-2">
      <AppSegment>
        <div class="flex-down">
          <AccountSelector
            :value="account_id"
            :click="updateRef"
          />
          <CategorySelector
            :value="category_id"
            :click="updateRef"
          />
          <AppInput
            name="description"
            label="Opis"
            :value="description"
            required
            @input="updateRef('description', $event.target.value)"
          />
        </div>
      </AppSegment>

      <div class="flex-down">
        <AppSegment>
          <div class="flex-down">
            <AppInput
              name="formula"
              label="Formuła"
              :value="formula"
              @input="updateRef('formula', $event.target.value)"
            />

            <Shoutout label="Kwota">
              <MoneyRender :amount="amount" />
            </Shoutout>
          </div>
        </AppSegment>

        <AppSegment>
          <AppInput type="date"
            name="date"
            label="Data"
            :value="date"
            required
            @input="updateRef('date', $event.target.value)"
          />
        </AppSegment>
      </div>
    </div>

    <div class="grid-2">
      <AppButton @click="handleSubmit" label="Popraw" icon="accept" />
      <AppButton @click="navigateTo(`/confirm/delete/transactions/${$route.params.id}`)" label="Usuń" icon="delete" />
    </div>
  </div>
</template>