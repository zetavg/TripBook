export default class MeBooksIndexPage {
  constructor(elenemt) {
    this.$elenemt = $(elenemt)
    this.$showBook = this.$elenemt.find('.show-book')
    this.$showBookCard = this.$showBook.find('.show-book-card')
    this.$showBookContent = this.$showBook.find('.show-book-content')
    this.$bookImage = this.$showBook.find('.book-image')

    this.$elenemt.find('.l-books-index-page-show-book-layers').click((e) => {
      if (e.target.classList.contains('cl')) {
        this.closeBook(this.$currentBook)
      }
    })

    this.$elenemt.find('.book-cover').click((e) => {
      if (e.metaKey || e.ctrlKey) return true
      e.preventDefault()
      this.$currentBook = $(e.target).parent('.book-cover')
      this.openBook(this.$currentBook)
      return false
    })
  }

  openBook($book) {
    const href = $book.attr('href')
    const imageSrc = $book.find('img').attr('src')
    this.$bookImage.find('img').attr('src', imageSrc)

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

    const { top: bookOffsetTop, left: bookOffsetLeft } = $book.offset()
    const bookWidth = $book.width()
    const bookHeight = $book.height()

    this.$showBook.addClass('activating')

    const { top: bookImageOffsetTop, left: bookImageOffsetLeft } = this.$bookImage.offset()
    const bookImageWidth = this.$bookImage.width()
    const bookImageHeight = this.$bookImage.height()

    const bookImageTranslateX = bookOffsetLeft - bookImageOffsetLeft
    const bookImageTranslateY = bookOffsetTop - bookImageOffsetTop
    const bookImageScaleX = (bookWidth * 1.0) / bookImageWidth
    const bookImageScaleY = (bookHeight * 1.0) / bookImageHeight
    this.$bookImage.css(
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

    setTimeout(() => {
      $book.css('opacity', '0')
      this.$showBook.addClass('active')
      this.$showBookCard.removeClass('activating')
    }, 10)
  }

  closeBook($book) {
    const { top: bookOffsetTop, left: bookOffsetLeft } = $book.offset()
    const bookWidth = $book.width()
    const bookHeight = $book.height()

    const { top: bookImageOffsetTop, left: bookImageOffsetLeft } = this.$bookImage.offset()
    const bookImageWidth = this.$bookImage.width()
    const bookImageHeight = this.$bookImage.height()

    const bookImageTranslateX = bookOffsetLeft - bookImageOffsetLeft
    const bookImageTranslateY = bookOffsetTop - bookImageOffsetTop
    const bookImageScaleX = (bookWidth * 1.0) / bookImageWidth
    const bookImageScaleY = (bookHeight * 1.0) / bookImageHeight
    this.$bookImage.css(
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

    this.$showBook.addClass('deactivating')
    this.$showBook.removeClass('active')
    setTimeout(() => {
      $book.css('opacity', '1')
      this.$showBook.removeClass('deactivating')
      this.$showBook.removeClass('activating')
      this.$bookImage.css('transform', 'none')
      this.$showBookCard.css('transform', 'none')
    }, 300)
  }
}
