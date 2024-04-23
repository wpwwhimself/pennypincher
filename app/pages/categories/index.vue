<script setup lang="ts">
definePageMeta({
  title: "Kategorie",
  // icon: "house-chimney",
  order: 3,
})
const { data: categories } = await useFetch<Category[]>("http://localhost:8000/api/categories/")
</script>

<template>
  <div class="flex-down">
    <AppSegment @click="navigateTo('/categories/create')">
      Dodaj nową
    </AppSegment>

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
            <AppButton label="Edytuj" @click="navigateTo(`/categories/edit/${category.id}`)" />
            <AppButton label="Transakcje" @click="navigateTo({
              path: `/transactions`,
              query: {
                category: category.id,
              }
            })" />
          </div>

          <div class="flex-down">
            <h3>Podkategorie:</h3>
            <div class="flex-right tight wrap">
              <AppButton v-for="subcat of category.subcategories" v-if="category.subcategories?.length"
                :label="subcat.name"
                @click="navigateTo(`/categories/edit/${subcat.id}`)"
              />
              <span v-else>Brak</span>
            </div>
            <AppButton label="Dodaj" @click="navigateTo(`/categories/create/forParent/${category.id}`)" />
          </div>
        </div>
      </AppSegment>
    </div>
  </div>
</template>