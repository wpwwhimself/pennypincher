<script setup lang="ts">
definePageMeta({
  title: "Dodaj konto",
  icon: "add",
})
const [route, router] = [useRoute(), useRouter()]

let name = ref("")
let description = ref("")
let color = ref("")

const updateRef = (target: string, val: string) => {
  const refTable = {
    name: name,
    description: description,
    color: color,
  };

  refTable[target as keyof typeof refTable].value = val;
}

const handleSubmit = async () => {
  const {data, error} = await useFetch(`http://localhost:8000/api/accounts/create`, {
    method: "post",
    body: {
      name: name.value,
      description: description.value,
      color: color.value,
    }
  })

  if (error.value) {
    //todo error
    console.error(error.value)
  }

  navigateTo("/accounts")
}
</script>

<template>
  <div class="flex-down">
    <AppButton @click="navigateTo('/accounts')" label="Wróć do listy" icon="back" />

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

    <AppButton @click="handleSubmit" label="Utwórz" icon="accept" />
  </div>
</template>