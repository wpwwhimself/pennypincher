<script setup lang="ts">
definePageMeta({
  title: "Kokpit",
  icon: "house-chimney",
  order: 1,
})
</script>

<template>
  <div class="flex-down">
    <AppSegment>
      <Shoutout label="Całkowity stan konta" />
    </AppSegment>

    <div class="grid-2">
      <AppSegment v-for="ac in [1, 2, 3]">
        <p>
          Tu będzie bilans dla konkretnego konta.
          Po kliknięciu przenosi do transakcji tylko dla tego konta
        </p>
      </AppSegment>
  
    </div>
  </div>
</template>