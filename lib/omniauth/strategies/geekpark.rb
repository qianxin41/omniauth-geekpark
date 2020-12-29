module OmniAuth
  module Strategies
    class GeekPark < OmniAuth::Strategies::OAuth2
      option :client_options, {
        site: 'http://account_test.geekpark.net',
        authorize_url: '/oauth2/authorize',
        token_url: '/oauth2/token'
      }

      uid { raw_info['id'] }

      info do
        {
          nickname: raw_info['nickname'],
          city: raw_info['city'],
          realname: raw_info['realname'],
          gender: raw_info['gender'],
          birthday: raw_info['birthday'],
          company: raw_info['company'],
          title: raw_info['title'],
          bio: raw_info['bio'],
          avatar_url: raw_info['avatar_url'],
          email: raw_info['email'],
          mobile: raw_info['mobile']
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v1/user').parsed
      end
    end
  end
end

OmniAuth.config.add_camelization 'geekpark', 'GeekPark'
