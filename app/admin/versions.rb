# frozen_string_literal: true
ActiveAdmin.register Version do
  menu false

  actions :all, except: [:new, :create, :edit, :update, :destroy]
end
