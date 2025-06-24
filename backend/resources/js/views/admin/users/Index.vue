<template>
  <div class="modern-table-container">
    <div class="modern-table-card">
      <div class="modern-table-header">
        <h5>Users</h5>
        <router-link v-if="can('user-list')" :to="{ name: 'users.create' }" class="modern-table-add-btn">
          Add New
        </router-link>
      </div>
      <div class="modern-table-search">
        <input v-model="search_global" type="text" placeholder="Search..." class="modern-table-search-input">
      </div>
      <div class="modern-table-responsive">
        <table class="modern-table">
          <thead>
            <tr>
              <th>
                <input v-model="search_id" type="text" class="modern-table-filter" placeholder="Filter by ID">
              </th>
              <th>
                <input v-model="search_title" type="text" class="modern-table-filter" placeholder="Filter by Name">
              </th>
              <th></th>
              <th></th>
              <th></th>
            </tr>
            <tr>
              <th @click="updateOrdering('id')" :class="{active: orderColumn === 'id'}">
                <span>ID</span>
                <span v-if="orderColumn === 'id'">
                  <span v-if="orderDirection === 'asc'">▲</span>
                  <span v-else>▼</span>
                </span>
              </th>
              <th @click="updateOrdering('title')" :class="{active: orderColumn === 'title'}">
                <span>Name</span>
                <span v-if="orderColumn === 'title'">
                  <span v-if="orderDirection === 'asc'">▲</span>
                  <span v-else>▼</span>
                </span>
              </th>
              <th @click="updateOrdering('email')" :class="{active: orderColumn === 'email'}">
                <span>Email</span>
                <span v-if="orderColumn === 'email'">
                  <span v-if="orderDirection === 'asc'">▲</span>
                  <span v-else>▼</span>
                </span>
              </th>
              <th @click="updateOrdering('created_at')" :class="{active: orderColumn === 'created_at'}">
                <span>Created at</span>
                <span v-if="orderColumn === 'created_at'">
                  <span v-if="orderDirection === 'asc'">▲</span>
                  <span v-else>▼</span>
                </span>
              </th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="post in users.data" :key="post.id">
              <td>{{ post.id }}</td>
              <td>{{ post.name }}</td>
              <td>{{ post.email }}</td>
              <td>{{ post.created_at }}</td>
              <td>
                <a href="#" v-if="can('user-delete')" @click.prevent="deleteUser(post.id)" class="modern-table-action delete">Delete</a>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="modern-table-footer">
        <Pagination :data="users" :limit="3"
          @pagination-change-page="page => getUsers(page, search_id, search_title, search_global, orderColumn, orderDirection)"
          class="mt-4"/>
      </div>
    </div>
  </div>
</template>

<script setup>
import {ref, onMounted, watch} from "vue";
import useUsers from "../../../composables/users";
import {useAbility} from '@casl/vue'

const search_id = ref('')
const search_title = ref('')
const search_global = ref('')
const orderColumn = ref('created_at')
const orderDirection = ref('desc')
const {users, getUsers, deleteUser} = useUsers()
const {can} = useAbility()
onMounted(() => {
    getUsers()
})
const updateOrdering = (column) => {
    orderColumn.value = column;
    orderDirection.value = (orderDirection.value === 'asc') ? 'desc' : 'asc';
    getUsers(
        1,
        search_id.value,
        search_title.value,
        search_global.value,
        orderColumn.value,
        orderDirection.value
    );
}
watch(search_id, (current, previous) => {
    getUsers(
        1,
        current,
        search_title.value,
        search_global.value
    )
})
watch(search_title, (current, previous) => {
    getUsers(
        1,
        search_id.value,
        current,
        search_global.value
    )
})
watch(search_global, _.debounce((current, previous) => {
    getUsers(
        1,
        search_id.value,
        search_title.value,
        current
    )
}, 200))
</script>

<style scoped>
.modern-table-container {
  padding: 2.5rem 0;
  display: flex;
  justify-content: center;
}
.modern-table-card {
  background: #fff;
  border-radius: 1.5rem;
  box-shadow: 0 8px 32px rgba(67,233,123,0.10), 0 1.5px 8px rgba(34,34,59,0.07);
  padding: 2rem 2rem 1.5rem 2rem;
  width: 100%;
  max-width: 1200px;
  display: flex;
  flex-direction: column;
}
.modern-table-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 1.2rem;
}
.modern-table-add-btn {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: #fff;
  padding: 0.6rem 1.5rem;
  border-radius: 1rem;
  font-weight: 600;
  font-size: 1rem;
  text-decoration: none;
  box-shadow: 0 2px 8px rgba(67,233,123,0.12);
  transition: background 0.2s, box-shadow 0.2s;
}
.modern-table-add-btn:hover {
  background: linear-gradient(135deg, #fa8bff 0%, #2bd2ff 100%);
  box-shadow: 0 4px 16px rgba(250,139,255,0.15);
}
.modern-table-search {
  margin-bottom: 1.2rem;
}
.modern-table-search-input {
  width: 260px;
  padding: 0.7rem 1.2rem;
  border-radius: 1rem;
  border: 1px solid #e0e0e0;
  background: #f8fafc;
  font-size: 1rem;
  outline: none;
  transition: border 0.2s;
}
.modern-table-search-input:focus {
  border: 1.5px solid #43e97b;
  background: #fff;
}
.modern-table-responsive {
  width: 100%;
  overflow-x: auto;
}
.modern-table {
  width: 100%;
  border-collapse: separate;
  border-spacing: 0;
  background: #fff;
  border-radius: 1.2rem;
  overflow: hidden;
  font-size: 1.05rem;
  box-shadow: 0 2px 8px rgba(67,233,123,0.07);
}
.modern-table thead tr {
  background: linear-gradient(135deg, #e3f2fd 0%, #f8fafc 100%);
}
.modern-table th, .modern-table td {
  padding: 1rem 1.2rem;
  text-align: left;
  white-space: nowrap;
}
.modern-table th {
  font-weight: 700;
  color: #43e97b;
  cursor: pointer;
  user-select: none;
  border-bottom: 2px solid #e3f2fd;
  background: #f8fafc;
  transition: background 0.18s;
}
.modern-table th.active, .modern-table th:hover {
  background: #e3f2fd;
  color: #22223b;
}
.modern-table-filter {
  width: 100%;
  padding: 0.4rem 0.7rem;
  border-radius: 0.7rem;
  border: 1px solid #e0e0e0;
  background: #f8fafc;
  font-size: 0.98rem;
  outline: none;
  margin-bottom: 0.2rem;
}
.modern-table tbody tr {
  transition: background 0.18s;
}
.modern-table tbody tr:hover {
  background: #f3f7fa;
}
.modern-table-action {
  padding: 0.4rem 1.1rem;
  border-radius: 1rem;
  font-weight: 600;
  font-size: 0.98rem;
  text-decoration: none;
  margin-right: 0.5rem;
  transition: background 0.18s, color 0.18s;
  cursor: pointer;
  border: none;
  display: inline-block;
}
.modern-table-action.edit {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: #fff;
}
.modern-table-action.edit:hover {
  background: linear-gradient(135deg, #fa8bff 0%, #2bd2ff 100%);
  color: #fff;
}
.modern-table-action.delete {
  background: linear-gradient(135deg, #fda085 0%, #f6d365 100%);
  color: #fff;
}
.modern-table-action.delete:hover {
  background: linear-gradient(135deg, #f85032 0%, #e73827 100%);
  color: #fff;
}
.modern-table-footer {
  margin-top: 1.5rem;
  display: flex;
  justify-content: flex-end;
}
@media (max-width: 900px) {
  .modern-table-card {
    padding: 1rem 0.2rem 1rem 0.2rem;
  }
  .modern-table-search-input {
    width: 100%;
  }
  .modern-table th, .modern-table td {
    padding: 0.7rem 0.5rem;
  }
}
</style>
