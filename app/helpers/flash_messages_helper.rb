# frozen_string_literal: true
module FlashMessagesHelper
  def class_for_flash_message(flash_type)
    {
      success: "alert-success",
      error: "alert-danger",
      alert: "alert-danger",
      warning: "alert-warning",
      notice: "alert-info"
    }[flash_type.to_sym] || "alert-info"
  end
end
