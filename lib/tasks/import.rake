require 'iconv'

namespace :import do
  namespace :meetup do
    task members: :environment do
      Meetup::Member.all.each do |member|
        ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
        valid_name = ic.iconv(member['name'] + ' ')[0..-2]
        User.find_or_create_by_name_and_provider_and_uid(valid_name, 'meetup', member['id'])
        print '.'
      end
    end
  end
end
