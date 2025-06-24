<template>
  <nav class="modern-breadcrumb-nav">
    <ol class="modern-breadcrumb">
      <li
        v-for="(crumb, ci) in crumbs"
        :key="ci"
        class="modern-breadcrumb-item"
        :class="{ active: isLast(ci) }"
      >
        <router-link
          v-if="!isLast(ci)"
          :to="crumb.href"
          class="modern-breadcrumb-link"
          @click="selected(crumb)"
        >
          {{ crumb.text }}
        </router-link>
        <span v-else class="modern-breadcrumb-current">{{ crumb.text }}</span>
        <span v-if="!isLast(ci)" class="modern-breadcrumb-sep">›</span>
      </li>
    </ol>
  </nav>
</template>

<script>
export default {
  props: {
    crumbs: {
      type: Array,
      required: true,
    },
  },
  methods: {
    isLast(index) {
      return index === this.crumbs.length - 1;
    },
    selected(crumb) {
      this.$emit('selected', crumb);
    },
  },
};
</script>

<style scoped>
.modern-breadcrumb-nav {
  padding: 1.2rem 0 0.5rem 0;
  display: flex;
  justify-content: flex-start;
}
.modern-breadcrumb {
  display: flex;
  align-items: center;
  list-style: none;
  background: linear-gradient(135deg, #e3f2fd 0%, #f8fafc 100%);
  border-radius: 2rem;
  box-shadow: 0 2px 8px rgba(67,233,123,0.07);
  padding: 0.5rem 1.2rem;
  margin: 0;
  gap: 0.2rem;
}
.modern-breadcrumb-item {
  display: flex;
  align-items: center;
  font-size: 1.08rem;
  font-weight: 500;
  color: #43e97b;
}
.modern-breadcrumb-link {
  background: #fff;
  border-radius: 1.2rem;
  padding: 0.4rem 1.1rem;
  color: #43e97b;
  text-decoration: none;
  transition: background 0.18s, color 0.18s;
  font-weight: 600;
  box-shadow: 0 1px 4px rgba(67,233,123,0.07);
}
.modern-breadcrumb-link:hover {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: #fff;
}
.modern-breadcrumb-current {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: #fff;
  border-radius: 1.2rem;
  padding: 0.4rem 1.1rem;
  font-weight: 700;
  box-shadow: 0 2px 8px rgba(67,233,123,0.10);
}
.modern-breadcrumb-sep {
  margin: 0 0.5rem;
  color: #a18cd1;
  font-size: 1.2rem;
  font-weight: 700;
  user-select: none;
}
@media (max-width: 600px) {
  .modern-breadcrumb {
    padding: 0.3rem 0.5rem;
    font-size: 0.98rem;
  }
  .modern-breadcrumb-link, .modern-breadcrumb-current {
    padding: 0.3rem 0.7rem;
  }
}
</style>