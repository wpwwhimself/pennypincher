<script setup lang="ts">
definePageMeta({
  title: "Konta",
  // icon: "house-chimney",
  order: 4,
})
const router = useRouter()
const accounts = [1, 2, 3]
</script>

<template>
  <div class="flex-down">
    <AppSegment
      @click="navigateTo('accounts/add')"
      extra-classes="clickable"
    >
      Dodaj nowe
    </AppSegment>

    <div class="grid-2">
      <AppSegment v-for="account of accounts">
        <h2>Konto {{ account }}</h2>
        <p>Opis konta</p>
        <div class="flex-right tight">
          <AppButton label="Edytuj" @click="navigateTo(`accounts/modify/${account}`)" />
          <AppButton label="Transakcje" @click="" />
        </div>
      </AppSegment>
    </div>
  </div>
</template>