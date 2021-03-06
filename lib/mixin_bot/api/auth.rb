module MixinBot
  class API
    module Auth
      def access_token(method, uri, body, exp_in=10.minutes)
        sig = Digest::SHA256.hexdigest (method + uri + body)
        iat = Time.now.utc.to_i
        exp = (Time.now.utc + exp_in).to_i
        jti = SecureRandom.uuid
        payload = {
          uid: client_id,
          sid: session_id,
          iat: iat,
          exp: exp,
          jti: jti,
          sig: sig
        }
        JWT.encode payload, private_key, 'RS512'
      end

      def oauth_token(code)
        path = 'oauth/token'
        payload = {
          client_id: client_id,
          client_secret: client_secret,
          code: code
        }
        r = client.post(path, json: payload)

        raise r.inspect if r['error'].present?

        return r['data']['access_token']
      end

      def request_oauth(options={})
        scope = options[:scope]
        scope ||= (MixinBot.scope || 'PROFILE:READ')
        format('https://mixin.one/oauth/authorize?client_id=%s&scope=%s&response_type=code', client_id, scope)
      end
    end
  end
end
