<script setup>
const props = defineProps(['projectProfile'])
const data = ref({
    projectName: '',
    accessKey: '',
    secretKey: '',
    region: 'ap-southeast-7'
})

data.value = props.projectProfile

</script>

<template>
    <div class="">
        <fieldset class="fieldset">
            <legend class="fieldset-legend">Project Name</legend>
            <input
                type="text"
                class="input w-full"
                placeholder="Project D"
                name="projectName"
                v-model="data.projectName"
            />
            <p class="label"></p>
        </fieldset>
        
        <fieldset class="fieldset">
            <legend class="fieldset-legend">AWS Access Key</legend>
            <input
                type="text"
                class="input w-full"
                placeholder="Type here"
                name="accessKey"
                v-model="data.accessKey"
            />
            <p class="label"></p>
        </fieldset>

        <fieldset class="fieldset">
            <legend class="fieldset-legend">AWS Secret Key</legend>
            <input
                type="text"
                class="input w-full"
                placeholder="Type here"
                name="secretKey"
                v-model="data.secretKey"
            />
            <p class="label"></p>
        </fieldset>

        <fieldset class="fieldset">
            <legend class="fieldset-legend">Region</legend>
            <input
                type="text"
                class="input w-full"
                value="ap-southeast-7"
                name="region"
                v-model="data.region"
                readonly
            />
            <p class="label"></p>
        </fieldset>

        <button class="btn btn-primary w-full my-3" @click="$emit('next', data)">Next</button>
    </div>
</template>