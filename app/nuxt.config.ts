import tailwindcss from "@tailwindcss/vite";

// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2025-05-15',
  devtools: { enabled: true },
  modules: ['@nuxt/icon', '@nuxtjs/tailwindcss'],
  ssr: false,
  vite: {
    plugins: [tailwindcss()],
  },
  css: ["~/assets/app.css"],
  runtimeConfig: {
    public: {
      apiBase: 'http://43.208.18.94/api'
    }
  }
})
