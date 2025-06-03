<template>
  <div>
    <ul class="timeline">
      <li>
        <div class="timeline-start timeline-box btn" @click="$emit('goto', 0)">Select Template</div>
        <div class="timeline-middle">
          <Icon
            name="line-md:circle-to-confirm-circle-transition"
            size="2em"
            :class="props.step >= 1 ? 'text-primary' : ''"
          />
        </div>
        <hr :class="props.step >= 1 ? 'bg-primary' : ''" />
      </li>
      <li>
        <hr :class="props.step >= 1 ? 'bg-primary' : ''" />
        <div class="timeline-start timeline-box btn" @click="$emit('goto', 1)">Create Project Profile</div>
        <div class="timeline-middle">
          <Icon
            name="line-md:circle-to-confirm-circle-transition"
            size="2em"
            :class="props.step >= 2 ? 'text-primary' : ''"
          />
        </div>
        <hr :class="props.step >= 2 ? 'bg-primary' : ''" />
      </li>
      <li>
        <hr :class="props.step >= 2 ? 'bg-primary' : ''" />
        <div class="timeline-start timeline-box btn" @click="$emit('goto', 2)">Configurations</div>
        <div class="timeline-middle">
          <Icon
            name="line-md:circle-to-confirm-circle-transition"
            size="2em"
            :class="props.step >= 3 ? 'text-primary' : ''"
          />
        </div>
        <hr :class="props.step >= 3 ? 'bg-primary' : ''" />
      </li>
      <li>
        <hr :class="props.step >= 3 ? 'bg-primary' : ''" />
        <div class="timeline-start timeline-box btn" @click="$emit('goto', 3)">Launch</div>
        <div class="timeline-middle">
          <Icon
            name="line-md:circle-to-confirm-circle-transition"
            size="2em"
            :class="props.step >= 4 ? 'text-primary' : ''"
          />
        </div>
      </li>
    </ul>
  </div>
</template>

<script setup>
const props = defineProps(['step'])

</script>