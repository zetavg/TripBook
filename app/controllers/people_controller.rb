# frozen_string_literal: true
class PeopleController < ApplicationController
  private

  def people_scope
    User.all
  end

  def find_person
    @person = people_scope.find(params[:person_id] || params[:id])
  end
end
