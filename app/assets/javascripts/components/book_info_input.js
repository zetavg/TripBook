export default class BookInfoInput {
  constructor(elenemt) {
    this.$elenemt = $(elenemt)
    this.allowCreate = this.$elenemt.data('allow-create')

    this.$isbnSelect = this.$elenemt.find('[data-isbn-select]')
    this.initSelect()

    if (this.allowCreate) {
      this.$newInfoBlock = this.$elenemt.find('[data-new-info-block]')

      const selectVal = this.$isbnSelect.val()
      const infoVal = this.$newInfoBlock.find('input').map((i, input) => $(input).val()).toArray().join('')

      if (!selectVal && infoVal) {
        this.enableCreateMode()
      } else {
        this.enableSelectMode()
      }
    }
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
      } else if (obj.new) {
        if (obj.text) {
          $item = $(`
            <div class="book-info-select-item">
              <div class="loading-text">新增「${obj.text}⋯⋯」</div>
            </div>
          `)
        } else {
          $item = $(`
            <div class="book-info-select-item">
              <div class="loading-text">新增⋯⋯</div>
            </div>
          `)
        }
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

    this.$isbnSelect2 = this.$isbnSelect.select2({
      ajax: {
        url: this.$elenemt.data('api-book-infos-path'),
        dataType: 'json',
        delay: 250,
        data: params => ({
          query: params.term,
        }),
        processResults: (data, params) => {
          let results = data.map(bookInfo => ({
            id: bookInfo.isbn,
            text: bookInfo.name,
            ...bookInfo,
          }))

          results = results.filter(item => item.id)

          if (this.allowCreate) {
            results.push({ new: true, text: params.term, id: `__new__${params.term}` })

            if (params.term === '__new__') {
              results.push({ new: true, text: '新增', id: '__new__' })
            }
          }

          return { results }
        },
        cache: true,
      },
      templateResult: templateItem,
      templateSelection: templateItem,
      minimumInputLength: 2,
    })

    if (this.$elenemt.data('value')) {
      const data = {
        id: this.$elenemt.data('value'),
        text: this.$elenemt.data('info-name'),
        name: this.$elenemt.data('info-name'),
        language: this.$elenemt.data('info-language'),
        author: this.$elenemt.data('info-author'),
        publisher: this.$elenemt.data('info-publisher'),
        publish_date: this.$elenemt.data('info-publish-date'),
      }

      if (this.$elenemt.data('info-cover-image-url')) {
        data.cover_image = { thumbnail_url: this.$elenemt.data('info-cover-image-url') }
      }

      this.$isbnSelect2.select2('trigger', 'select', { data })
    }

    if (this.allowCreate) {
      this.$isbnSelect2.on('select2:select', (e) => {
        if (e.params.data.id.match(/^__new__/)) {
          this.enableCreateMode(e.params.data.text)
        } else {
          this.enableSelectMode()
        }
        return true
      })
    }

    window.$isbnSelect2 = this.$isbnSelect2
  }

  enableCreateMode(text) {
    this.$isbnSelect.attr('name', `_${this.$isbnSelect.attr('name')}`)

    this.$newInfoBlock.find('input').map((i, input) => {
      const $input = $(input)
      $input.attr('name', $input.attr('name').replace(/^_+/, ''))
      return true
    })
    this.$newInfoBlock.css('display', 'block')

    if (text) {
      if (text.match(/^[0-9-]+$/)) {
        const $newInfoIsbnInput = this.$newInfoBlock.find('.book_info_isbn input')
        if (!$newInfoIsbnInput.val()) $newInfoIsbnInput.val(text)
      } else {
        const $newInfoNameInput = this.$newInfoBlock.find('.book_info_name input')
        if (!$newInfoNameInput.val()) $newInfoNameInput.val(text)
      }
    }

    if (!this.$isbnSelect2.val()) {
      this.$isbnSelect2.select2('trigger', 'select', { data: { id: '__new__', new: true, text: '' } })
    }
  }

  enableSelectMode() {
    this.$isbnSelect.attr('name', this.$isbnSelect.attr('name').replace(/^_+/, ''))

    this.$newInfoBlock.find('input').map((i, input) => {
      const $input = $(input)
      $input.attr('name', `_${$input.attr('name')}`)
      return true
    })
    this.$newInfoBlock.css('display', 'none')
  }
}
