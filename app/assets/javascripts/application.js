//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require select2-full

import BookInfoInput from './components/book_info_input'

const components = {}

$(document).on('turbolinks:load', () => {
  components.bookInfoInputs = $('.book_info_input').toArray().map(el => new BookInfoInput(el))
})
