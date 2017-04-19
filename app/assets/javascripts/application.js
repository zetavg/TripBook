//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require tether
//= require bootstrap-sprockets
//= require select2-full
//= require jquery-fileupload/basic

import Navbar from './components/navbar'
import BookInfoInput from './components/book_info_input'
import UserSelectionInput from './components/user_selection_input'
import BasicImageUploaderInput from './components/basic_image_uploader_input'

import MeBooksIndexPage from './pages/me_books_index_page'

const components = {}
const pages = {}

$(document).on('turbolinks:load', () => {
  // Mount Components
  components.navbars = $('.navbar').toArray().map(el => new Navbar(el))
  components.bookInfoInputs = $('.book_info_input').toArray().map(el => new BookInfoInput(el))
  components.userSelectionInputs = $('.user-selection-input').toArray().map(el => new UserSelectionInput(el))
  components.basicImageUploaderInput =
    $('.basic_image_uploader_input').toArray().map(el => new BasicImageUploaderInput(el))

  // Mount Pages
  pages.meBooksIndexPages = $('.me-books-index-page').toArray().map(el => new MeBooksIndexPage(el))
})
