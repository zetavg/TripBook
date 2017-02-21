export default class BasicImageUploaderInput {
  constructor(elenemt) {
    this.$elenemt = $(elenemt)
    this.uploadAPIPath = this.$elenemt.data('upload-api-path')
    this.imageModelName = this.$elenemt.data('image-model-name')
    this.$uploadInput = this.$elenemt.find('[data-upload-input]')
    this.$imageThumbnail = this.$elenemt.find('.image-thumbnail')
    this.$imageIDInput = this.$elenemt.find('[data-uploader="id_input"]')
    this.$addImageBtn = this.$elenemt.find('.add-image')

    this.initPreviewArea()
    this.initUploader()
    this.bindFormSubmitPreventer()
  }

  initPreviewArea() {
    if (this.$imageThumbnail.find('img').attr('src')) {
      this.$imageThumbnail.css('display', 'inline-block')
    } else {
      this.$imageThumbnail.css('display', 'none')
    }
  }

  initUploader() {
    this.$uploadInput.fileupload({
      dataType: 'json',
      url: this.uploadAPIPath,
      paramName: `${this.imageModelName}[image]`,
      method: 'POST',
      dropZone: this.$input,
      maxNumberOfFiles: 1,
      progressall: (e, data) => {
        const progress = parseInt((data.loaded / data.total) * 100, 10)
        this.setProgress(progress)
      },
      done: (e, data) => {
        const id = data.result.id
        this.showPreviewImage(data.result)
        this.$imageIDInput.val(id)
        this.setProgress('ready')
      },
      error: () => {
        this.setProgress('ready')
      },
    })
  }

  bindFormSubmitPreventer() {
    this.$elenemt.parents('form').on('submit', () => {
      if (this.state === 'uploading') {
        const notify = window.alert
        notify('請等待圖片上傳完成')
        return false
      }

      return true
    })
  }

  showPreviewImage(image) {
    this.$imageThumbnail.find('a').attr('href', image.url)
    this.$imageThumbnail.find('img').attr('src', image.thumbnail_url)
    this.$imageThumbnail.css('display', 'inline-block')
  }

  setProgress(progress) {
    if (progress === 'ready') {
      this.state = 'ready'
      this.$addImageBtn.contents().first().replaceWith('上傳圖片')
      this.$addImageBtn.removeClass('disabled')
      this.$addImageBtn.css('pointer-events', 'auto')
    } else {
      this.state = 'uploading'
      this.$addImageBtn.contents().first().replaceWith(`上傳中⋯⋯ ${progress}%`)
      this.$addImageBtn.addClass('disabled')
      this.$addImageBtn.css('pointer-events', 'none')
    }
  }
}
