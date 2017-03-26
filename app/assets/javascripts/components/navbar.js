const NAVBAR_MINIMIZE_THRESHOLD = 8

export default class Navbar {
  constructor(elenemt) {
    this.$elenemt = $(elenemt)
    $(window).scroll(this.windowScrollListener.bind(this))
    this.windowScrollListener()
  }

  windowScrollListener() {
    const scrollTop = $(window).scrollTop()

    if (this.isMinimized()) {
      if (scrollTop > NAVBAR_MINIMIZE_THRESHOLD) return
      this.minimize(false)
    } else {
      if (scrollTop <= NAVBAR_MINIMIZE_THRESHOLD) return
      this.minimize(true)
    }
  }

  isMinimized() {
    return this.$elenemt.hasClass('minimized')
  }

  minimize(minimize) {
    if (minimize) {
      this.$elenemt.addClass('minimized')
    } else {
      this.$elenemt.removeClass('minimized')
    }
  }
}
