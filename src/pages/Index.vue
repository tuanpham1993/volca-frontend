<template>
  <q-page>
    <div class="row">
      <div class="col-2">
        <q-input bottom-slots v-model="newWord" label="New" counter>
          <template v-slot:after>
            <q-btn round dense flat icon="send" @click="addWord" />
          </template>
        </q-input>
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
    this.loadWord();

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
      ignored: false
    };
  },
  methods: {
    async addWord() {
      if (this.newWord) {
        try {
          await this.$axios.post("http://api.volca.tuanpa.wtf/words", {
            word: this.newWord
          });

          this.newWord = "";
          await this.loadWord();
        } catch (err) {
          alert("Exists or something went wrong");
        }
      }
    },
    async loadWord() {
      const { data } = await this.$axios.get(
        "http://api.volca.tuanpa.wtf/words",
        {
          params: {}
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
        }
      );
    },
    async saveNote(id, note) {
      await this.$axios.post(`http://api.volca.tuanpa.wtf/words/${id}/note`, {
        note
      });
    }
  }
};
</script>
