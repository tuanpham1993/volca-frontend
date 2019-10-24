<template>
  <q-page>
    <div class="row">
      <div class="col-2">
        <q-input bottom-slots v-model="newWord" label="New word" counter>
          <template v-slot:after>
            <q-btn round dense flat icon="send" @click="addWord" />
          </template>
        </q-input>
        <q-input bottom-slots v-model="newUser" label="New user" counter>
          <template v-slot:after>
            <q-btn round dense flat icon="send" @click="addUser" />
          </template>
        </q-input>
        <q-select v-model="user" :options="users" label="User" @input="loadWord" />
      </div>
      <div class="col-10">
        <!-- <q-toggle v-model="forgotten" label="Forgotten" color="yellow" />
        <q-toggle v-model="ignored" label="Ignored" color="green" />-->
        <q-table
          title="Words"
          :data="data"
          :columns="columns"
          row-key="name"
          :pagination.sync="pagination"
        >
          <template v-slot:body="props">
            <q-tr :props="props">
              <q-td key="index" :props="props">{{ props.row.index + 1 }}</q-td>
              <q-td key="word" :props="props">{{ props.row.word }}</q-td>
              <q-td key="rating" :props="props">{{ props.row.rating }}</q-td>
              <q-td>
                <q-rating
                  v-model="props.row.newRate"
                  size="2em"
                  color="green-5"
                  icon="star_border"
                  icon-selected="star"
                  :max="3"
                  @input="rate(props.row.id, props.row.newRate)"
                />
              </q-td>
              <q-td>
                <div v-html="props.row.note"></div>
                <q-popup-edit
                  buttons
                  v-model="props.row.note"
                  @save="saveNote(props.row.id, props.row.note)"
                >
                  <q-editor v-model="props.row.note" min-height="5rem" autofocus @keyup.enter.stop />
                </q-popup-edit>
              </q-td>
              <q-td>foo</q-td>
            </q-tr>
          </template>
        </q-table>
      </div>
    </div>
  </q-page>
</template>

<script>
export default {
  name: "PageIndex",
  data() {
    this.getUsers();

    return {
      pagination: {
        rowsPerPage: 3000
      },
      columns: [
        {
          name: "index",
          align: "left"
        },
        {
          name: "word",
          required: true,
          label: "Content",
          align: "left",
          field: row => row.word,
          format: val => `${val}`,
          sortable: true
        },
        {
          name: "rating",
          label: "Rating",
          align: "left",
          field: row => row.rating.join(", ")
        },
        {
          name: "rate",
          label: "Rate",
          align: "left"
        },
        {
          name: "note",
          label: "Note",
          align: "left",
          field: row => row.note
        }
      ],
      data: [],
      newWord: "",
      forgotten: false,
      ignored: false,
      users: [],
      user: null,
      newUser: ""
    };
  },
  methods: {
    async addWord() {
      if (this.newWord) {
        try {
          await this.$axios.post(
            "http://api.volca.tuanpa.wtf/words",
            {
              word: this.newWord
            },
            {
              headers: {
                Authorization: this.user
              }
            }
          );

          this.newWord = "";
          this.$q.notify({
            message: "Success!",
            color: "purple",
            position: "top-right"
          });
          await this.loadWord();
        } catch (err) {
          this.$q.notify({
            message: "Exists or something went wrong",
            color: "red",
            position: "top-right"
          });
        }
      }
    },
    async loadWord() {
      const { data } = await this.$axios.get(
        "http://api.volca.tuanpa.wtf/words",
        {
          params: {},
          headers: {
            Authorization: this.user
          }
        }
      );
      this.data = data.map((item, index) => ({
        ...item,
        index,
        newRate: 0
      }));
    },
    async rate(id, newRate) {
      await this.$axios.post(
        `http://api.volca.tuanpa.wtf/words/${id}/rate`,
        {
          rating: newRate
        },
        {
          headers: {
            Authorization: this.user
          }
        }
      );
    },
    async saveNote(id, note) {
      await this.$axios.post(
        `http://api.volca.tuanpa.wtf/words/${id}/note`,
        {
          note
        },
        {
          headers: {
            Authorization: this.user
          }
        }
      );
    },
    async addUser() {
      if (this.newUser) {
        try {
          await this.$axios.post("http://api.volca.tuanpa.wtf/users", {
            username: this.newUser
          });

          this.user = this.newUser;
          this.newUser = "";
          this.$q.notify({
            message: "Success!",
            color: "purple",
            position: "top-right"
          });
          await this.getUsers();
        } catch (err) {
          this.$q.notify({
            message: "Exists or something went wrong",
            color: "red",
            position: "top-right"
          });
        }
      }
    },
    async getUsers() {
      const { data } = await this.$axios.get(
        "http://api.volca.tuanpa.wtf/users"
      );

      this.users = data.map(({ username }) => username);
      this.user = this.users[0];
      await this.loadWord();
    }
  }
};
</script>
