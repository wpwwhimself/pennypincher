<script setup lang="ts">
const config = useAppConfig()
const props = defineProps<{
  value: string,
  click: (target: string, val: string) => void,
}>()

const current_value = ref(props.value)
const {data: accounts, error} = await useLazyFetch<Account[]>(`${config.apiUrl}accounts`, {server: false})
watch(accounts, (refreshed) => {})

const update = (account: Account) => {
  props.click("account_id", account.id.toString())
  current_value.value = account.id.toString()
}
</script>

<template>
  <Loader v-if="!accounts" />
  <div v-else class="account-selector-container flex-down tight">
    <label for="account_id">Konto</label>
    <input type="hidden" id="account_id" name="account_id" :value="current_value" :="$attrs">
    <div class="flex-right tight wrap">
      <AppButton v-for="account of accounts"
        label="&#11044;"
        :label-on-hover="account.name"
        :text-color="account.color"
        :highlighted="account.id.toString() == current_value"
        @click="update(account)"
      />
    </div>
  </div>
</template>

<style scoped>
</style>