export default class MeBooksIndexPage {
  constructor(elenemt) {
    this.$elenemt = $(elenemt)

    this.$showBook = this.$elenemt.find('.show-book')
    this.$showBookCard = this.$showBook.find('.show-book-card')
    this.$showBookContent = this.$showBook.find('.show-book-content')
    this.$showBookImage = this.$showBook.find('.show-book-image')

    this.$elenemt.find('.books-shelf .book-cover').click(this.handleIndexBookCoverClick.bind(this))
    this.$showBook.find('.close-area').click(this.handleShowBookAreaClick.bind(this))
  }

  handleShowBookAreaClick(e) {
    if (this.isShowBookAnimating()) return true
    if (e.target.classList.contains('close-area')) {
      this.closeBook(this.$currentBook)
      return false
    }
    return true
  }

  handleIndexBookCoverClick(e) {
    if (e.metaKey || e.ctrlKey) return true
    if (this.isShowBookAnimating()) return true
    e.preventDefault()
    this.$currentBook = $(e.target).parent('.book-cover')
    this.openBook(this.$currentBook)
    return false
  }

  isShowBookAnimating() {
    return this.$showBook.hasClass('pre-activating') ||
           this.$showBook.hasClass('activating') ||
           this.$showBook.hasClass('deactivating')
  }

  openBook($book) {
    this.setShowBookContentFor($book)

    setTimeout(() => {
      this.$showBook.addClass('pre-activating')
      this.setShowBookTransformFor($book)
    }, 50)

    setTimeout(() => {
      $book.css('opacity', '0')
      this.$showBook.addClass('activating')
      this.$showBook.removeClass('pre-activating')
    }, 100)


    setTimeout(() => {
      this.$showBook.addClass('active')
      this.$showBook.removeClass('activating')
    }, 300)
  }

  setShowBookContentFor($book) {
    const href = $book.attr('href')
    const imageSrc = $book.find('img').attr('src')
    this.$showBookImage.find('img').attr('src', imageSrc)

    $.ajax({
      url: href,
      type: 'GET',
      data: {
        layout: false,
      },
      success: (response) => {
        this.$showBookContent.html(response)
      },
      error: (xhr) => {
        console.error(xhr)
      },
    })
  }

  closeBook($book) {
    this.setShowBookTransformFor($book)

    this.$showBook.addClass('deactivating')
    this.$showBook.removeClass('active')

    setTimeout(() => {
      $book.css('opacity', '1')
      this.$showBook.removeClass('deactivating')
      this.$showBook.removeClass('activating')
      this.$showBookImage.css('transform', 'none')
      this.$showBookCard.css('transform', 'none')
    }, 300)
  }

  setShowBookTransformFor($book) {
    const { top: bookOffsetTop, left: bookOffsetLeft } = $book.offset()
    const bookWidth = $book.width()
    const bookHeight = $book.height()

    const { top: bookImageOffsetTop, left: bookImageOffsetLeft } = this.$showBookImage.offset()
    const bookImageWidth = this.$showBookImage.width()
    const bookImageHeight = this.$showBookImage.height()

    const bookImageTranslateX = bookOffsetLeft - bookImageOffsetLeft
    const bookImageTranslateY = bookOffsetTop - bookImageOffsetTop
    const bookImageScaleX = (bookWidth * 1.0) / bookImageWidth
    const bookImageScaleY = (bookHeight * 1.0) / bookImageHeight
    this.$showBookImage.css(
      'transform',
      `
        translateX(${bookImageTranslateX}px)
        translateY(${bookImageTranslateY}px)
        scaleX(${bookImageScaleX})
        scaleY(${bookImageScaleY})
      `,
    )

    const { top: showBookCardOffsetTop, left: showBookCardOffsetLeft } = this.$showBookCard.offset()
    const showBookCardWidth = this.$showBookCard.width()
    const showBookCardHeight = this.$showBookCard.height()

    const showBookCardTranslateX = (bookOffsetLeft + 32) - showBookCardOffsetLeft
    const showBookCardTranslateY = (bookOffsetTop + 32) - showBookCardOffsetTop
    const showBookCardScaleX = ((bookWidth - 64) * 1.0) / showBookCardWidth
    const showBookCardScaleY = ((bookHeight - 64) * 1.0) / showBookCardHeight
    this.$showBookCard.css(
      'transform',
      `
        translateX(${showBookCardTranslateX}px)
        translateY(${showBookCardTranslateY}px)
        scaleX(${showBookCardScaleX})
        scaleY(${showBookCardScaleY})
      `,
    )
  }
}
