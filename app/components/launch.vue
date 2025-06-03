<script setup>
const props = defineProps(['selectedTemplate','projectProfile','configuration'])
</script>

<template>
    <div>
        <div class="py-3">
            <p class="text-xl py-2">Template</p>
            <div class="p-3 border border-base-300 flex flex-col">
                <p v-for="[key,value] of Object.entries(props.selectedTemplate)">{{ key }} : {{ value }}</p>
            </div>
        </div>
        <div class="py-3">
            <p class="text-xl py-2">Project Profile</p>
            <div class="p-3 border border-base-300 flex flex-col">
                <p v-for="[key,value] of Object.entries(props.projectProfile)">{{ key }} : {{ value }}</p>
            </div>
        </div>
        <div class="py-3">
            <p class="text-xl py-2">Project Configuration</p>
            <div class="p-3 border border-base-300 flex flex-col">
                <p v-for="[key,value] of Object.entries(props.configuration)">{{ key }} : {{ value }}</p>
            </div>
        </div>

        <button class="btn btn-primary w-full my-3" @click="$emit('next')">Launch</button>
    </div>
</template>