<script setup lang="ts">
import { Icon } from '#components';
import Configuration from './components/configuration.vue';
import Console from './components/console.vue';
import Launch from './components/launch.vue';
import Loading from './components/loading.vue';
import ProjectProfile from './components/projectProfile.vue';
import Step from './components/step.vue';
import TemplatesSelect from './components/templatesSelect.vue';

const isReady = ref(true)
const step = ref(0)
const selectedTemplate = ref<{ name: string, file: string }>()
const projectProfile = ref<{
    projectName: string;
    accessKey: string;
    secretKey: string;
    region: string;
}>({
    projectName: '',
    accessKey: '',
    secretKey: '',
    region: 'ap-southeast-7'
})
const configuration = ref<{[key:string]: any}>({})

function changeStep (page:number) {
  step.value = page
}

function selectTemplate(template:{name:string, file:string}) {
  console.log('Selected template', template)
  selectedTemplate.value = template
  step.value = 1
}

function updateProjectProfile(data:{
    projectName: string;
    accessKey: string;
    secretKey: string;
    region: string;
}) {
  console.log('Updated project profile', data)
  projectProfile.value = data
  const config = useRuntimeConfig()
  isReady.value = false
  fetch(`${config.public.apiBase}/api/v1/projects`, {
    method: 'post',
    headers: {
      'content-type': 'application/json'
    },
    body: JSON.stringify({
      template:selectedTemplate.value,
      profile: projectProfile.value
    })
  })
    .then(res => res.json())
    .then(res => {
        isReady.value = true
        console.log(res)
        step.value = 2
    })
    .catch(err => {
        console.error(err)
    })

}

function updateConfiguration (result: any) {
  configuration.value = result
  step.value = 3
}

function launchTerraform () {
  const config = useRuntimeConfig()
  fetch(`${config.public.apiBase}/api/v1/project/${projectProfile.value.projectName}/launch`,
        {
            method: 'post',
            headers: {
            'content-type': 'application/json'
            },
            body: JSON.stringify({
              accessKey: projectProfile.value.accessKey,
              secretKey: projectProfile.value.secretKey,
              region: projectProfile.value.region,
            })
        })
        .then(res => res.json())
        .then(res => console.log(res))
        .catch(err => {
            console.error(err)
            alert(err)
        })
  step.value = 4
}

</script>

<template>
  <div class="w-screen h-screen bg-base-300">
    <div class="flex justify-center items-center h-full">
      <div class="card bg-base-100">
        <div class="card-body">
          <div class="flex justify-between">
            <h2 class="text-3xl font-bold">DevOps Pipeline Wizard</h2>
          </div>
          <Step :step="step" @goto="changeStep"></Step>
          <div v-if="isReady" class="max-h-[60vh] overflow-y-auto p-2">
            <TemplatesSelect 
              v-if="step == 0" 
              @select="selectTemplate">
            </TemplatesSelect>
            <ProjectProfile 
              v-if="step == 1" 
              :projectProfile="projectProfile" 
              @next="updateProjectProfile">
            </ProjectProfile>
            <Configuration 
              v-if="step == 2" 
              :projectName="projectProfile.projectName"
              @next="updateConfiguration">
            </Configuration>
            <Launch 
              :selectedTemplate="selectedTemplate"
              :projectProfile="projectProfile"
              :configuration="configuration"
              @next="launchTerraform"
              v-if="step == 3">
            </Launch>
            <Console 
              v-if="step == 4">
            </Console>
          </div>
          <div v-else>
            <Loading />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
