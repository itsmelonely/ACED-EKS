<script setup>
import Loading from './loading.vue'

const config = useRuntimeConfig()
const isReady = ref(false)
const data = ref([])
fetch(`${config.public.apiBase}/api/v1/templates`, { method: 'get' })
    .then(res => res.json())
    .then(res => {
        isReady.value = true
        data.value = res.templates
        console.log(res)
    })
    .catch(err => {
        console.error(err)
    })

</script>

<template>
    <div>
        <ul class="list bg-base-100 rounded-box shadow-md" v-if="isReady">
            <li class="list-row" v-for="[key, template] of Object.entries(data)" :key="key">
                <div class="text-4xl font-thin opacity-30 tabular-nums">{{ parseInt(key)+1 }}</div>
                <div class="list-col-grow">
                    <div>{{ template.name }}</div>
                    <div class="text-xs font-semibold opacity-60">{{ template.file }}</div>
                </div>
                <button class="btn btn-square btn-ghost" @click="$emit('select', template)">
                    <Icon name="line-md:pause-to-play-transition" size="3em" />
                </button>
            </li>
        </ul>
        <Loading v-else></Loading>
    </div>
</template>