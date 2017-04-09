# frozen_string_literal: true
class API::UsersController < ApplicationController
  def index
    query = params[:query].split(',')
    @users = User.where(
      'id IN (?) OR username IN (?) OR name IN (?) OR email IN (?) OR mobile IN (?)',
      query.map(&:to_i), query, query, query, query
    )
  end
end
