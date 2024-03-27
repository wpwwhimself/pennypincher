<template>
  <AppHeader />
  <AppNav />
  <div id="main-wrapper">
    <NuxtPage />
  </div>
  <AppFooter />
</template>

<style scoped>
#main-wrapper{
  margin: 0 auto;
  padding: 1em 0;
  box-sizing: border-box;
  width: 90vw;
  flex: 1 0 auto;
}
</style>