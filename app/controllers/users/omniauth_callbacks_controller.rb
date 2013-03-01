class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def meetup
    @user = User.find_for_meetup_oauth(request.env['omniauth.auth'], current_user)

    if @user.persisted?
      sign_in_and_redirect(@user, event: :authentication)
    else
      session['devise.meetup_data'] = request.env['omniauth.auth']
      redirect_to(root_path)
    end
  end
end
