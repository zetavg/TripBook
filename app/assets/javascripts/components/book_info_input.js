export default class BookInfoInput {
  constructor(elenemt) {
    this.$elenemt = $(elenemt)
    this.$isbnSelect = this.$elenemt.find('[data-isbn-select]')

    this.initSelect()
  }

  initSelect() {
    const templateItem = (obj) => {
      let $item

      if (obj.loading) {
        $item = $(`
          <div class="book-info-select-item">
            <div class="loading-text">Loading</div>
          </div>
        `)
      } else {
        const imageURL = obj.cover_image ?
                         obj.cover_image.thumbnail_url :
                         'http://placehold.it/150x210'
        $item = $(`
          <div class="book-info-select-item">
            <div class="image">
              <div class="img" style="background-image: url('${imageURL}')" />
            </div>
            <div class="info">
              <div class="name">
                ${obj.name}
              </div>
              <div class="isbn">
                ${obj.isbn}
              </div>
              <div class="author">
                ${obj.author}
              </div>
            </div>
          </div>
        `)
      }

      return $item
    }

    this.$isbnSelect.select2({
      ajax: {
        url: this.$elenemt.data('api-book-infos-path'),
        dataType: 'json',
        delay: 250,
        data: params => ({
          query: params.term,
        }),
        processResults: (data) => {
          let results = data.map(bookInfo => ({
            id: bookInfo.isbn,
            text: bookInfo.name,
            ...bookInfo,
          }))

          results = results.filter(item => item.id)

          return { results }
        },
        cache: true,
      },
      templateResult: templateItem,
      templateSelection: templateItem,
    })
  }
}
