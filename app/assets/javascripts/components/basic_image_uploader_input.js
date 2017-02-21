export default class BasicImageUploaderInput {
  constructor(elenemt) {
    this.$elenemt = $(elenemt)
    this.uploadAPIPath = this.$elenemt.data('upload-api-path')
    this.imageModelName = this.$elenemt.data('image-model-name')
    this.$uploadInput = this.$elenemt.find('[data-upload-input]')
    this.$imageThumbnail = this.$elenemt.find('.image-thumbnail')
    this.$imageIDInput = this.$elenemt.find('input.string')

    this.$uploadInput.fileupload({
      dataType: 'json',
      url: this.uploadAPIPath,
      paramName: `${this.imageModelName}[image]`,
      method: 'POST',
      dropZone: this.$input,
      maxNumberOfFiles: 1,
      progressall: (e, data) => {
      },
      done: (e, data) => {
        const id = data.result.id
        const thumbnailURL = data.result.thumbnail_url
        this.$imageThumbnail.find('img').attr('src', thumbnailURL)
        this.$imageIDInput.val(id)
      },
      error: () => {
      },
    })
  }
}
