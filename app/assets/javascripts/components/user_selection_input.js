export default class UserSelectionInput {
  constructor(elenemt) {
    this.$elenemt = $(elenemt)

    this.$userIDSelect = this.$elenemt.find('[data-user-id-select]')
    this.initSelect()
  }

  initSelect() {
    const templateItem = (obj) => {
      let $item

      if (obj.loading) {
        $item = $(`
          <div class="user-selection-input-select-item">
            <div class="loading-text">載入中⋯⋯</div>
          </div>
        `)
      } else if (!obj.id) {
        $item = $(`
          <div class="user-selection-input-select-item">
            <div class="loading-text">${obj.text}</div>
          </div>
        `)
      } else {
        const imageURL = obj.picture ?
                         obj.picture.small_url :
                         'http://placehold.it/128x128'
        $item = $(`
          <div class="user-selection-input-select-item">
            <div class="image">
              <div class="img" style="background-image: url('${imageURL}')" />
            </div>
            <div class="data">
              <div class="text">
                ${obj.text}
              </div>
            </div>
          </div>
        `)
      }

      return $item
    }

    this.$userIDSelect2 = this.$userIDSelect.select2({
      placeholder: '請選擇使用者',
      language: {
        noResults: () => '請輸入完整的姓名、使用者名稱或 email 搜尋',
        inputTooShort: () => '請輸入完整的姓名、使用者名稱或 email 搜尋',
      },
      ajax: {
        url: this.$elenemt.data('api-users-path'),
        dataType: 'json',
        delay: 250,
        data: params => ({
          query: params.term ? params.term : this.$elenemt.data('preload-user-ids'),
        }),
        processResults: (data) => {
          let results = data.map(user => ({
            id: user.id,
            text: user.username || user.name,
            ...user,
          }))

          results = results.filter(item => item.id)

          return { results }
        },
        cache: true,
      },
      templateResult: templateItem,
      templateSelection: templateItem,
      minimumInputLength: 0,
    })

    if (this.$elenemt.data('value')) {
      const data = {
        id: this.$elenemt.data('value'),
        text: this.$elenemt.data('user-username') || this.$elenemt.data('user-name'),
        name: this.$elenemt.data('user-name'),
      }

      if (this.$elenemt.data('user-picture-url')) {
        data.picture = { small_url: this.$elenemt.data('user-picture-url') }
      }

      this.$userIDSelect2.select2('trigger', 'select', { data })
    }
  }
}
