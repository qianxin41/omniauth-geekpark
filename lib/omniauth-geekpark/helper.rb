module OmniAuth
  module GeekPark
    module Helper
      def token
        token? ? super : refresh_token!
      end

      def token?
        self[:token].present? && (Time.current < expires_at)
      end

      def refresh_token!
        return unless refresh_token.present?

        res = conn.post do |req|
          req.url '/oauth2/token'
          req.body = { grant_type: 'refresh_token',
                       refresh_token: refresh_token,
                       client_id: ENV['GEEKPARK_KEY'],
                       client_secret: ENV['GEEKPARK_SECRET'] }
        end

        if res.status == 200
          body = JSON.parse(res.body)
          update(token: body["access_token"], expires_at: (Time.now + body['expires_in']), refresh_token: body['refresh_token'])
          return body['access_token']
        else
          nil
        end
      end

      def extra_info
        res = conn.get do |req|
          req.url '/api/v1/user/extra_info'
          req.params[:query] = %w(email mobile)
          req.params[:access_token] = token
        end

        if res.status == 200
          JSON.parse(res.body)
        else
          nil
        end
      end

      private

      def conn
        @conn ||= Faraday.new(url: 'http://account_test.geekpark.net') do |faraday|
          faraday.request  :url_encoded
          faraday.adapter  Faraday.default_adapter
        end
      end
    end
  end
end
