<script setup lang="ts">
const config = useAppConfig()
const props = defineProps<{
  value: string,
  click: (target: string, val: string) => void,
}>()

const current_value = ref(props.value)
const current_category = ref<Category>()
const {data: allCategories, error: catError} = await useLazyFetch<Category[]>(`${config.apiUrl}categories/-1`, {server: false})
watch(allCategories, (refreshed) => {})
const categories = ref<Category[]>()

const listCategories = (parent?: Category) => {
  categories.value = (parent)
    ? [parent, ...(parent.subcategories || [])]
    : categories.value = allCategories.value?.filter(cat => !cat.parent_id) || []
}

onMounted(() => {
  if (props.value) {
    current_category.value = allCategories.value?.find(cat => cat.id.toString() == props.value)
  }
  listCategories(current_category.value?.parent || current_category.value)
})

const update = (category: Category) => {
  props.click("category_id", category.id.toString())
  current_value.value = category.id.toString()
  current_category.value = category

  if (!category.parent_id) listCategories(category)
}

const reset = () => {
  props.click("category_id", "")
  current_value.value = ""
  current_category.value = undefined
  listCategories()
}
</script>

<template>
  <Loader v-if="!categories" />
  <div v-else class="category-selector-container flex-down tight">
    <label for="category_id">Kategoria</label>
    <input type="hidden" id="category_id" name="category_id" :value="current_value" :="$attrs">
    <div class="flex-right tight wrap">
      <AppButton v-if="current_category"
        label="Wróć"
        text-color="gray"
        @click="reset()"
      />
      <AppButton v-for="category of categories"
        :label="category.name"
        :icon="category.color ? 'circle-fill' : undefined"
        :icon-color="category.color"
        :highlighted="category.id.toString() == current_value"
        @click="update(category)"
      />
    </div>
  </div>
</template>

<style scoped>
</style>