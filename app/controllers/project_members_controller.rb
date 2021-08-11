# frozen_string_literal: true

##
# Controller for managing members of a specific project.
#
class ProjectMembersController < ApplicationController
  before_action :set_project
  before_action :set_project_member, only: %i[update destroy]
  before_action :authorize

  def index; end

  def create
    project_member = ProjectMember.new(project_member_create_params.merge({ project_id: @project.id }))
    if project_member.save
      flash.notice = 'Successfully created project member.'
    else
      flash.alert = "Unable to create project member. #{project_member.errors.full_messages}"
    end
    redirect_to action: 'index'
  end

  def update
    if @project_member.update(project_member_update_params)
      flash.notice = 'Successfully updated project member.'
    else
      flash.alert = "Unable to updated project member. #{@project_member.errors.full_messages}"
    end
    redirect_to action: 'index'
  end

  def destroy
    if @project_member.destroy
      flash.notice = 'Successfully removed project member.'
    else
      flash.alert = "Unable to remove project member. #{@project_member.errors.full_messages}"
    end
    redirect_to action: 'index'
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
    @project_members = @project.project_members
  end

  def set_project_member
    @project_member = ProjectMember.where(project: @project).find(params[:id])
  end

  def authorize
    return if current_user.can_admin_project?(@project)

    raise(NotAuthorizedError, 'You are not authorized to manage this project.')
  end

  def project_member_create_params
    params.require(:project_member).permit(:user_id, :role)
  end

  def project_member_update_params
    params.require(:project_member).permit(:role)
  end
end