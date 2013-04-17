module OmniauthHelpers
  def set_omniauth_for(user)
    OmniAuth.config.test_mode = true
    auth_hash = {
      'provider' => 'meetup',
      'uid' => user.uid,
      'extra' => {}
    }
    OmniAuth.config.mock_auth[:meetup] = OmniAuth::AuthHash.new(auth_hash)
    Meetup::Profile.stub(:get).and_return({})
  end

  def signin_as(user)
    visit root_path
    set_omniauth_for user
    click_link 'Sign In'
  end
end
