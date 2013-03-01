module Meetup
  class Client
    @@api_key = nil
    @@group = nil
    @@end_point = 'api.meetup.com'
    @logger = nil

    cattr_accessor :api_key, :group, :end_point, :logger

    def self.get(path, options = {})
      options = default_options.merge(options)
      format = default_options.delete(:format)
      query_string = options.collect { |k,v| "#{k}=#{v}" }.join('&')

      url = "https://#{end_point}#{path}.#{format}?#{query_string}"

      logger.debug("MEETUP Sending request #{url}")

      Nestful.get(url)
    end

  protected

    def self.default_options
      { format: 'json', key: api_key }
    end
  end

  class Profile
    def self.get(member_id, options = {})
      options = { group_urlname: Client.group, member_id: member_id }.merge(options)
      JSON.parse(Client.get('/2/profiles', options))['results'][0]
    end
  end

  class Member
    def self.all(options = {})
      options = { group_urlname: Client.group, offset: 0 }.merge(options)

      results = []
      while true
        response = JSON.parse(Client.get('/2/members', options))
        break if response['results'].empty?
        results += response['results']
        options[:offset] += 1
      end

      results
    end
  end
end
