class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def meetup
    @user = User.find_for_meetup_oauth(request.env['omniauth.auth'], current_user)

    if @user.persisted?
      @user.set_organizer_flag(request.env['omniauth.auth'])
      sign_in_and_redirect(@user, event: :authentication)
    else
      redirect_to(root_path, notice: 'You are not a member of this meetup group. Please join first.')
    end
  end
end
