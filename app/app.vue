<template>
  <AppHeader />
  <NuxtLoadingIndicator />
  <div id="main-wrapper">
    <NuxtPage />
  </div>
  <AppFooter />
</template>

<style scoped>
#main-wrapper{
  box-sizing: border-box;
  flex: 1 0 auto;
}
</style>