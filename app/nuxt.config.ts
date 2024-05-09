// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  devtools: { enabled: true },
  css: ['~/assets/css/main.css'],
  app: {
    pageTransition: { name: "slide", mode: "out-in" },
    head: {
      link: [{
        rel: "icon",
        href: "icon.svg",
        type: "image/svg+xml",
      }]
    }
  },
  modules: [
    "nuxt-icon",
  ],
})
