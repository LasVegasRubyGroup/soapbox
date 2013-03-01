require 'iconv'
require 'open-uri'
require 'csv'

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

  namespace :old_site do
    task meetings: :environment do
      url = 'http://topics.lvrug.org/meetings.csv'
      CSV.parse(open(url).read, headers: true) do |row|
        meeting = Meeting.find_or_initialize_by_old_id(row['_id'])
        meeting.date = row['date']
        meeting.state = row['status']
        meeting.save!

        meeting.time_slots.delete_all

        row['time_slots'].split('|').each do |slot|
          data = slot.split(',')
          slot = TimeSlot.new
          slot.starts_at = data[0]
          slot.ends_at = data[1]
          slot.old_topic_id = data[2]
          slot.presenter = User.find_by_name(data[3])
          slot.meeting = meeting
          slot.save!
          print '+'
        end

        print '.'
      end
    end

    task topics: :environment do
      url = 'http://topics.lvrug.org/topics.csv'
      CSV.parse(open(url).read, headers: true) do |row|
        if user = User.find_by_name(row['Created by'])
          topic = Topic.find_or_initialize_by_old_id(row['_id'])
          topic.meeting = Meeting.find_by_old_id(row['meeting_id'])
          topic.user = user
          topic.title = row['title']
          topic.description = row['description']
          topic.state = row['status']
          topic.created_at = row['created_at']
          topic.updated_at = row['updated_at']
          topic.save!

          topic.voters.delete_all
          topic.volunteers.delete_all

          row['Voter Ids'].split(',').each do |name|
            if user = User.find_by_name(name)
              Voter.find_or_create_by_topic_id_and_user_id(topic.id, user.id)
            end
            print '+'
          end

          row['Volunteer Ids'].split(',').each do |name|
            if user = User.find_by_name(name)
              Volunteer.find_or_create_by_topic_id_and_user_id(topic.id, user.id)
            end
            print '+'
          end
        end
        print '.'
      end

      Topic.all.each do |topic|
        if slot = TimeSlot.find_by_old_topic_id(topic.old_id)
          slot.topic = topic
          slot.save
        end
        print '+'
      end
    end
  end
end
