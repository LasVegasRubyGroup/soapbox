class User < ActiveRecord::Base
  has_many :topics

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :registerable, :rememberable, :trackable, :omniauthable, :omniauth_providers => [:meetup]

  validates :name, presence: true

  attr_accessible :name, :provider, :uid, :email, :password, :password_confirmation, :remember_me, :organizer

  def self.with_points
    where('points > 0')
  end

  def self.by_points
    order('points DESC')
  end

  def self.find_for_meetup_oauth(auth, signed_in_resource = nil)
    user = User.where(provider: auth.provider, uid: auth.uid.to_s).first_or_create.tap do |u|
      u.name = auth.info.name
    end
    user.set_organizer_flag(auth)
    user
  end

  def voted_on?(topic)
    topic.voters.where(user_id: id).first || false
  end

  def volunteered_for?(topic)
    topic.volunteers.where(user_id: id).first || false
  end

  def vote_on!(topic)
    return false if voted_on?(topic)
    topic.voters.create(user_id: id)
  end

  def volunteer_for!(topic)
    return false if volunteered_for?(topic)
    topic.volunteers.create(user_id: id)
  end

  def earn_points!(earned)
    self.update_attribute(:points, points + earned)
    earned
  end

  def set_organizer_flag(auth)
    profile = Meetup::Profile.get(auth.uid)
    organizer = (profile['role'] == 'Co-Organizer' || profile['role'] == 'Organizer')
    update_attribute(:organizer, organizer)
  end
end
