<script setup lang="ts">
definePageMeta({
  title: "Ostrożnie!",
  icon: "warning",
})

const [route, router] = [useRoute(), useRouter()]

const dict = {
  "delete": ["usunięcie", "usunąć", "usuń"],

  "accounts": ["konta", "konto"],
  "categories": ["kategorii", "kategorię"],
}
const _ = {
  action: dict[route.params.action as keyof typeof dict],
  entity: dict[route.params.entity as keyof typeof dict],
}

const { data: entity, error } = await useFetch<Account>(`http://localhost:8000/api/${route.params.entity}/${route.params.id}/`)

const action = async () => {
  const { data, error } = await useFetch<Account>(`http://localhost:8000/api/${route.params.entity}/${route.params.action}/${route.params.id}/`, {
    method: route.params.action == "delete" ? "delete" : "post",
  })

  if (error.value) {
    //todo error
  }

  navigateTo(`/${route.params.entity}/`)
}
const back = () => {
  navigateTo(`/${route.params.entity}/edit/${route.params.id}/`)
}
</script>

<template>
  <div class="flex-down">
    <AppSegment>
      <h2>Potwierdź {{ _.action[0] }} {{ _.entity[0] }}</h2>
      <p>
        Czy na pewno chcesz {{ _.action[1] }} {{ _.entity[1] }} <strong>{{ entity?.name }}</strong>?
      </p>
    </AppSegment>

    <div class="grid-2">
      <AppButton @click="action" :label="`Tak, ${_.action[2]}`" icon="accept" />
      <AppButton @click="back" label="Nie, wróć" icon="cancel" />
    </div>
  </div>
</template>

<style scoped>
</style>