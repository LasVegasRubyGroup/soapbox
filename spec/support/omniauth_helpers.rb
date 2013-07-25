module OmniauthHelpers
  def set_omniauth_for(user, is_organizer)
    OmniAuth.config.test_mode = true
    organizer_hash = is_organizer ? {"role" => "Organizer" } : {}
    auth_hash = { 
      'provider' => 'meetup',
      'uid' => user.uid,
      'info' => { 'name' => user.name },
      'extra' => {}
    }
    OmniAuth.config.mock_auth[:meetup] = OmniAuth::AuthHash.new(auth_hash)
    Meetup::Profile.stub(:get).and_return(organizer_hash)
  end

  def signin_as(user)
    visit root_path
    set_omniauth_for user, user.organizer 
    click_link 'Sign In'
  end
end
