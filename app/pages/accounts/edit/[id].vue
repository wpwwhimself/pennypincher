<script setup lang="ts">
definePageMeta({
  title: "Edytuj konto",
  // icon: "house-chimney",
})
const [route, router] = [useRoute(), useRouter()]

const { data, error } = await useFetch<Account>(`http://localhost:8000/api/accounts/${route.params.id}/`)

const name = ref(data.value?.name || "aaa")
const description = ref(data.value?.description || "bbb")
const color = ref(data.value?.color || "")

const updateRef = (target: string, val: string) => {
  const refTable = {
    name: name,
    description: description,
    color: color,
  };

  refTable[target as keyof typeof refTable].value = val;
}

const handleSubmit = async () => {
  const {data, error} = await useFetch(`http://localhost:8000/api/accounts/edit/${route.params.id}`, {
    method: "post",
    body: {
      name: name.value,
      description: description.value,
      color: color.value,
    }
  })

  if (error.value) {
    //todo error
  }

  navigateTo("/accounts")
}
</script>

<template>
  <div class="flex-down">
    <AppSegment @click="navigateTo('/accounts')">Wróć do listy</AppSegment>

    <div class="grid-2">
      <AppSegment>
        <AppInput
          name="name"
          label="Nazwa"
          :value="name"
          required
          @input="updateRef('name', $event.target.value)"
        />
      </AppSegment>
      <AppSegment>
        <AppInput
          name="description"
          label="Opis"
          :value="description"
          required
          @input="updateRef('description', $event.target.value)"
        />
      </AppSegment>
      <AppSegment>
        <AppInput type="color"
          name="color"
          label="Kolor"
          :value="color"
          required
          @input="updateRef('color', $event.target.value)"
        />
      </AppSegment>
    </div>

    <div class="grid-2">
      <AppSegment @click="handleSubmit">Popraw</AppSegment>
      <AppSegment @click="navigateTo(`/confirm/delete/accounts/${$route.params.id}`)">Usuń</AppSegment>
    </div>
  </div>
</template>