<script setup lang="ts">
definePageMeta({
  title: "Kategorie",
  icon: "archive",
  order: 3,
})
const { data: categories } = await useFetch<Category[]>("http://localhost:8000/api/categories/")
</script>

<template>
  <div class="flex-down">
    <AppButton @click="navigateTo('/categories/create')" label="Dodaj nową" icon="add" />

    <AppSegment v-if="!categories?.length">
      Brak utworzonych kategorii. Dodaj nową.
    </AppSegment>
    <div class="grid-2" v-else>
      <AppSegment v-for="category of categories">
        <div class="flex-down">
          <div>
            <h2>
              <CategoryRender :category="category" />
            </h2>
            <p v-if="category.description">{{ category.description }}</p>
          </div>

          <div class="flex-right tight">
            <AppButton label="Edytuj" icon="edit" @click="navigateTo(`/categories/edit/${category.id}`)" v-if="category.id != 1" />
            <AppButton label="Transakcje" icon="group-list" @click="navigateTo({
              path: `/transactions`,
              query: {
                category: category.id,
              }
            })" />
          </div>

          <div class="flex-down">
            <h3>Podkategorie:</h3>
            <div class="flex-right tight wrap">
              <AppButton v-for="subcat of category.subcategories" v-if="category.subcategories?.length && category.id != 1"
                :label="subcat.name"
                @click="navigateTo(`/categories/edit/${subcat.id}`)"
              />
              <AppButton v-for="subcat of category.subcategories" v-else-if="category.subcategories?.length"
                :label="subcat.name"
              />
              <span v-else>Brak</span>
            </div>
            <AppButton label="Dodaj" icon="add" @click="navigateTo(`/categories/create/forParent/${category.id}`)" v-if="category.id != 1" />
          </div>
        </div>
      </AppSegment>
    </div>
  </div>
</template>