class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    UserDecorator.decorate(super || User.new)
  end

  def require_organizer
    unless current_user.organizer
      redirect_to(root_url, flash: { error: 'You need to be a meeting organizer to do that' })
    end
  end
end
