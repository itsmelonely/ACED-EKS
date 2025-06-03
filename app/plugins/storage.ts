export default defineNuxtPlugin({
    name: 'storage',
    parallel: true,
    async setup (nuxtApp) {
        
        const project = ref<string>()
        
        return {
            provide: {
                project: project
            }
        }
    },
})
