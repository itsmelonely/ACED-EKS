<script setup>
const props = defineProps(['projectName'])
const config = useRuntimeConfig()
const isReady = ref(false)
const data = ref([])
const emit = defineEmits(['next'])
isReady.value = true
fetch(`${config.public.apiBase}/api/v1/project/${props.projectName}/var`, { method: 'get' })
    .then(res => res.json())
    .then(res => {
        isReady.value = true
        data.value = parseTerraformVariables(res.file)
        console.log(data.value)

        fetch(`${config.public.apiBase}/api/v1/project/${props.projectName}/setting`, { method: 'get' })
            .then(res => res.json())
            .then(res => {
                isReady.value = true
                const tmp = parseTfvarsToJson(res.file)
                console.log(tmp)
                for (const [field, value] of Object.entries(tmp)) {
                    const row = data.value.find(f => f.name === field)
                    if(row) row.default = value
                }

            })
            .catch(err => {
                console.error(err)
            })

    })
    .catch(err => {
        console.error(err)
    })

const titleCase = (s) => s.replace(/^_*(.)|_+(.)/g, (s, c, d) => c ? c.toUpperCase() : ' ' + d.toUpperCase())
    
function parseTerraformVariables(tfString) {
  const variableBlocks = tfString.split(/variable\s+"([^"]+)"\s+{/).slice(1);
  const result = [];

  for (let i = 0; i < variableBlocks.length; i += 2) {
    const name = variableBlocks[i].trim();
    const body = variableBlocks[i + 1];

    const descriptionMatch = body.match(/description\s*=\s*"([^"]*)"/);
    const typeMatch = body.match(/type\s*=\s*([^\s"]+)/);
    const defaultMatch = body.match(/default\s*=\s*"([^"]*)"/);

    result.push({
      name,
      description: descriptionMatch ? descriptionMatch[1] : "",
      type: typeMatch ? typeMatch[1] : "",
      default: defaultMatch ? defaultMatch[1] : ""
    });
  }

  return result;
}

function parseTfvarsToJson(tfvarsStr) {
  const jsonResult = {};
  const lines = tfvarsStr.split('\n');

  for (const line of lines) {
    // Remove comments and trim whitespace
    const trimmed = line.split('#')[0].trim();
    if (!trimmed) continue;

    // Match key = "value" pattern
    const match = trimmed.match(/^(\w+)\s*=\s*"(.*)"$/);
    if (match) {
      const key = match[1];
      const value = match[2];
      jsonResult[key] = value;
    }
  }

  return jsonResult;
}

function parseJsonToTfvars(json) {
  let result = [];
  result.push(`# AUTOMATED ${new Date().toISOString()}`);

  for (const [key, value] of Object.entries(json)) {
    // Skip empty values
    if (value === "") continue;
    result.push(`${key} = "${value}"`);
  }

  return result.join("\n");
}

function formSubmit (ev) {
    ev.preventDefault()
    console.log(ev.target)

    let object = {};
    new FormData(ev.target).forEach(function(value, key){
        object[key] = value;
    });

    console.log(object)
    console.log()

    fetch(`${config.public.apiBase}/api/v1/project/${props.projectName}/setting`,
        {
            method: 'post',
            headers: {
            'content-type': 'application/json'
            },
            body: JSON.stringify({
                file:parseJsonToTfvars(object)
            })
        })
        .then(res => res.json())
        .then(res => emit('next', parseTfvarsToJson(res.file)))
        .catch(err => {
            console.error(err)
            alert(err)
        })
}

</script>


<template>
    <form @submit="formSubmit">
        <fieldset class="fieldset" v-for="field of data">
            <legend class="fieldset-legend uppercase">{{ titleCase(field.name) }}</legend>
            <input
                :name="field.name"
                :type="field.type == 'number' ? 'number': 'text'"
                class="input w-full"
                :value="field.default"
            />
            <p class="label">{{ field.description }}</p>
        </fieldset>
    
        <button class="btn btn-primary w-full my-3">Next</button>
    </form>
</template>