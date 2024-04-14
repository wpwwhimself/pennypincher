<script setup lang="ts">
import { format } from 'date-fns';

definePageMeta({
  title: "Dodaj transakcję",
  // icon: "house-chimney",
})
const [route, router] = [useRoute(), useRouter()]

let date = ref(format(new Date(), "yyyy-MM-dd"))
let category_id = ref("")
let account_id = ref("")
let description = ref("")
let amount = ref("")

const updateRef = (target: string, val: string) => {
  const refTable = {
    date: date,
    category_id: category_id,
    account_id: account_id,
    description: description,
    amount: amount,
  };

  refTable[target as keyof typeof refTable].value = val;
}

const handleSubmit = async () => {
  const {data, error} = await useFetch(`http://localhost:8000/api/transactions/create`, {
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
</script>

<template>
  <div class="flex-down">
    <AppSegment @click="navigateTo('/transactions')">Wróć do listy</AppSegment>

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
      <AppSegment>
        <div class="flex-down">
          <AppInput type="number" step="0.01"
            name="amount"
            label="Kwota [zł]"
            :value="amount"
            required
            @input="updateRef('amount', $event.target.value)"
          />
          <AppInput type="date"
            name="date"
            label="Data"
            :value="date"
            required
            @input="updateRef('date', $event.target.value)"
          />
        </div>
      </AppSegment>
    </div>

    <AppSegment @click="handleSubmit">Utwórz</AppSegment>
  </div>
</template>