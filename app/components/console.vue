<script setup>

const disableKillSwitch = ref(true)

function checkKillSwitch (ev) {
    console.log(ev)
    disableKillSwitch.value = ev.target.value !== 'kill enable'
}

</script>

<style lang="css">
@keyframes rocket-shake {
  0%, 100% {
    transform: translate(0, 0) rotate(0deg);
  }
  10% {
    transform: translate(-2px, 1px) rotate(-1deg);
  }
  20% {
    transform: translate(2px, -1px) rotate(1deg);
  }
  30% {
    transform: translate(-2px, 1px) rotate(-1deg);
  }
  40% {
    transform: translate(2px, -1px) rotate(1deg);
  }
  50% {
    transform: translate(-1px, 0) rotate(0deg);
  }
  60% {
    transform: translate(1px, 1px) rotate(1deg);
  }
  70% {
    transform: translate(-1px, -1px) rotate(-1deg);
  }
  80% {
    transform: translate(1px, 1px) rotate(1deg);
  }
  90% {
    transform: translate(-1px, 0) rotate(0deg);
  }
}

.rocket-icon {
  display: inline-block;
  animation: rocket-shake 0.5s infinite;
  transform-origin: center;
}
</style>

<template>
    <div>
        <div class="flex justify-center py-5">
            <Icon name="noto:rocket" size="8em" class="rocket-icon" />
        </div>
        <div class="p-3 border border-base-300 text-center">
            L A U N C H I N G
        </div>

        <!-- <div class="pt-5">
            <input type="text" placeholder="Type 'kill enable' for enable kill switch" class="input w-full" @keyup="checkKillSwitch" />
            <button class="btn btn-error w-full my-3" :disabled="disableKillSwitch">Kill Switch</button>
        </div> -->
    </div>
</template>