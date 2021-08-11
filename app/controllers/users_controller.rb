# frozen_string_literal: true

##
# Controller for managing members of a specific project.
#
class UsersController < ApplicationController
  before_action :authorize_admin
  before_action :set_user, only: %i[update destroy]

  def index
    @users = User.alphabetical
  end

  def update
    if @user.update(user_update_params)
      flash.notice = 'Successfully updated user.'
    else
      flash.alert = "Unable to updated user. #{@user.errors.full_messages}"
    end
    redirect_to action: 'index'
  end

  def destroy
    if @user.destroy
      flash.notice = 'Successfully removed user.'
    else
      flash.alert = "Unable to remove user. #{@user.errors.full_messages}"
    end
    redirect_to action: 'index'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_update_params
    params.require(:user).permit(:admin)
  end
end
