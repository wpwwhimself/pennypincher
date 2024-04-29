<script setup lang="ts">
import pkg from "../package.json"

const appConfig = useAppConfig()

const displayYears = () => {
  const output = [2024, (new Date()).getFullYear()]
  return (output[0] == output[1])
    ? output[0].toString()
    : `${output[0]} – ${output[1]}`
}
</script>

<template>
  <footer>
    <AppSegment>
      <div id="footer-container" class="flex-right backwards">
        <AppLogo small />
        <div class="texts flex-right">
          <span>{{ appConfig.title }}, v. {{ pkg.version }}</span>
          <span class="ghost">Built by <a href="http://wpww.pl/" target="_blank">WPWW</a></span>
          <span>
            <a href="https://creativecommons.org/licenses/by-sa/3.0/pl/">&copy; CC BY-SA 3.0</a> {{ displayYears() }}
          </span>
        </div>
      </div>
    </AppSegment>
  </footer>
</template>

<style scoped>
#footer-container {
  align-items: center;
}

.texts {
  text-align: right;

  & span {
    display: block;
  }
}
</style>