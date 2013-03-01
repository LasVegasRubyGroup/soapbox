require Rails.root.join('lib', 'meetup', 'meetup')

Meetup::Client.api_key = ENV['MEETUP_API_KEY']
Meetup::Client.group = ENV['MEETUP_GROUP']
Meetup::Client.logger = Rails.logger
