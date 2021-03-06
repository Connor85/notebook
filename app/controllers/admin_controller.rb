class AdminController < ApplicationController
  layout 'admin'

  before_action :authenticate_user!
  before_action :require_admin_access, except: [:masquerade]

  def dashboard
  end

  def content_type
    type_whitelist = Rails.application.config.content_types[:all].map(&:name)

    type = params[:type]
    unless type_whitelist.include? type
      return
    end

    @content_type = type.constantize
    @relation_name = type.downcase.pluralize.to_sym
  end

  def universes
  end

  def characters
  end

  def locations
  end

  def items
  end

  def masquerade
    # Do not allow masquerading in production, even for admins.
    return unless Rails.env.development?

    masqueree = User.find_by(id: params[:user_id])
    sign_in masqueree
    redirect_to root_path
  end

  private

  def require_admin_access
    unless user_signed_in? && current_user.site_administrator
      redirect_to root_path, notice: "You don't have permission to view that!"
    end
  end
end
