<template>
  <div class="container">
    <div>
      <h2>{{ props.leftLabel }}</h2>
      <select class="form-select" multiple v-model="leftSelectedData" @dblclick="moveRight">
          <option v-for="(item, index) in props.leftData"
                  :value="item"
                  :key="item.id">
              {{item.name}}
          </option>
      </select>
    </div>

    <div class="middle">
      <button class="btn btn-primary" @click.prevent="moveRight">=&gt;</button>
      <button class="btn btn-primary" @click.prevent="moveLeft">&lt;=</button>
    </div>

    <div>
      <h2>{{ props.rightLabel }}</h2>
      <select class="form-select" multiple v-model="rightSelectedData" @dblclick="moveLeft">
          <option v-for="(item, index) in props.rightData"
                  :value="item"
                  :key="item.id">
              {{item.name}}
          </option>
      </select>
    </div>
  </div>
</template>

<script setup>
import { defineEmits } from 'vue';
let leftSelectedData = []
let rightSelectedData = []
const emit = defineEmits(['onChangeList'])
const props = defineProps({
  leftLabel: {
    type: String,
    required: true
  },
  rightLabel: {
    type: String,
    required: true
  },
  leftData: {
    type: Array,
    required: true
  },
  rightData: {
    type: Array,
    required: true
  }
})

function moveLeft() {
  if (!rightSelectedData.length) return;
  for (let i = rightSelectedData.length; i > 0; i--) {
    let idx = props.rightData.indexOf(rightSelectedData[i - 1]);
    props.rightData.splice(idx, 1);
    props.leftData.push(rightSelectedData[i - 1]);
    rightSelectedData.pop();
  }
  let leftData = props.leftData
  let rightData = props.rightData
  emit("onChangeList", {
    leftData,
    rightData
  });
}

function moveRight() {
  if (!leftSelectedData.length) return;
  for (let i = leftSelectedData.length; i > 0; i--) {
    let idx = props.leftData.indexOf(leftSelectedData[i - 1]);
    props.leftData.splice(idx, 1);
    props.rightData.push(leftSelectedData[i - 1]);
    leftSelectedData.pop();
  }
  let leftData = props.leftData
  let rightData = props.rightData
  emit("onChangeList", {
    leftData,
    rightData
  })
}


</script>

<style scoped>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  color: #2c3e50;
  margin-top: 60px;
}

.container {
  display: grid;
  grid-template-columns: 40% 10% 40%;
  align-items: center;
  gap: 1.5rem;
}

.container select {
  height: 260px;
  width: 100%;
  font-size: 1.05rem;
  border-radius: 0.7rem;
  border: 1px solid #e0e0e0;
  background: #f8fafc;
  padding: 0.5rem;
}

.container .middle {
  text-align: center;
}

.container button {
  width: 80%;
  margin-bottom: 5px;
  border-radius: 1.2rem;
  font-weight: 600;
  font-size: 1rem;
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: #fff;
  border: none;
  box-shadow: 0 2px 8px rgba(67,233,123,0.12);
  transition: background 0.2s, box-shadow 0.2s;
  cursor: pointer;
}
.container button:hover {
  background: linear-gradient(135deg, #fa8bff 0%, #2bd2ff 100%);
  box-shadow: 0 4px 16px rgba(250,139,255,0.15);
}
@media (max-width: 900px) {
  .container {
    grid-template-columns: 1fr;
    gap: 0.7rem;
  }
  .container select {
    height: 180px;
  }
  .container .middle {
    margin: 0.7rem 0;
  }
}
</style>
