export default class SendBookBorrowDemandWithUserPopoverLink {
  constructor(elenemt) {
    this.$elenemt = $(elenemt)
    this.initPopover()
    this.bindCancelAction()
  }

  initPopover() {
    this.$elenemt.popover({
      trigger: 'manual',
      html: true,
      title: '送出借書請求',
      placement: 'bottom',
      content: this.getContent.bind(this),
    })

    this.$elenemt.click((e) => {
      if (e.metaKey || e.ctrlKey) return true
      e.preventDefault()
      if (!this.$elenemt.attr('aria-describedby')) {
        this.$elenemt.popover('show')
      }
      return false
    })

    this.$elenemt.on('show.bs.popover', () => {
      this.bindCancelAction()

      $.ajax({
        url: `${this.$elenemt.attr('href')}?layout=false`,
        success: (c) => {
          const content = `
            <div style="position: relative;">
              ${c}
              <button class="btn btn-danger cancel" style="position: absolute; bottom: 0; right: 0;">取消</button>
            </div>
          `
          this.content = content
          const popoverID = this.$elenemt.attr('aria-describedby')
          const $popover = $(`#${popoverID}`)
          $popover.find('.popover-content').html(content)
          this.bindCancelAction()
        },
      })
    })
  }

  getContent() {
    if (this.content) return this.content
    return `
      <div style="position: relative;">
        <div style="width: 202px; height: 234px; display: flex; justify-content: center; align-items: center;">
          Loading
        </div>
        <button class="btn btn-danger cancel" style="position: absolute; bottom: 0; right: 0;">取消</button>
      </div>
    `
  }

  bindCancelAction() {
    const popoverID = this.$elenemt.attr('aria-describedby')
    const $popover = $(`#${popoverID}`)
    $popover.find('.cancel').click(() => {
      if (!confirm('確定要捨棄內容並取消嗎？')) return
      this.$elenemt.popover('hide')
    })
  }
}
