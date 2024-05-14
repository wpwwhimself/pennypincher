<script setup lang="ts">
import _ from 'lodash'

const params = defineProps<{
  data: Pagination | null,
}>()
const emit = defineEmits<{
  (e: 'changePage', page: number): void,
}>()

//// globals ////
const neighbourPagesRange = 2;

const route = useRoute()
const neighbourPages = ref<number[]>()
const currentPage = ref<number>((route.params.query && route.params.query[0] == "page") ? parseInt(route.params.query[1] as string) : 1)

const recountNeighbours = () => {
  if (params.data != null) {
    neighbourPages.value = _.union(
      _.range(currentPage.value - neighbourPagesRange, currentPage.value + neighbourPagesRange + 1)
        .filter(p => p >= 1 && p <= params.data!.pageCount),
      [1, params.data.pageCount]
    ).toSorted((a, b) => a - b)
  }
}

const changePage = (p: number) => {
  currentPage.value = p
  emit('changePage', p)

  recountNeighbours()
}

onMounted(() => {
  recountNeighbours()
})
</script>

<template>
  <div class="flex-right center tight">
    <AppButton
      v-for="p in neighbourPages"
      :label="p.toString()"
      :highlighted="p == currentPage"
      @click="() => changePage(p)"
    />
  </div>
</template>

<style scoped>
</style>