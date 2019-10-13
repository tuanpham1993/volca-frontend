<template>
  <q-page>
    <q-table
      title="Words"
      :data="data"
      :columns="columns"
      row-key="name"
      :pagination.sync="pagination"
    ></q-table>
  </q-page>
</template>

<script>
export default {
  name: "PageIndex",
  data() {
    this.$axios
      .get("http://api.volca.tuanpa.wtf/words")
      .then(res => (this.data = res.data));

    return {
      pagination: {
        rowsPerPage: 3000
      },
      columns: [
        {
          name: "word",
          required: true,
          label: "Content",
          align: "left",
          field: row => row.word,
          format: val => `${val}`,
          sortable: true
        }
      ],
      data: []
    };
  }
};
</script>
