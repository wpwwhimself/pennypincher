<script setup lang="ts">
definePageMeta({
  title: "Edytuj konto",
  icon: "edit",
})
const [route, router] = [useRoute(), useRouter()]

const { data: category, error } = await useFetch<Category>(`http://localhost:8000/api/categories/${route.params.id}/`)

const name = ref(category.value?.name || "")
const description = ref(category.value?.description || "")
const color = ref(category.value?.color || "")

const updateRef = (target: string, val: string) => {
  const refTable = {
    name: name,
    description: description,
    color: color,
  };

  refTable[target as keyof typeof refTable].value = val;
}

const handleSubmit = async () => {
  const {data, error} = await useFetch(`http://localhost:8000/api/categories/edit/${route.params.id}`, {
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

  navigateTo("/categories")
}
</script>

<template>
  <div class="flex-down">
    <AppButton @click="navigateTo('/categories')" label="Wróć do listy" icon="back" />

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
      <AppSegment v-if="!category?.parent_id">
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
      <AppButton @click="handleSubmit" label="Popraw" icon="accept" />
      <AppButton @click="navigateTo(`/confirm/delete/categories/${$route.params.id}`)" label="Usuń" icon="delete" />
    </div>
  </div>
</template>