module AuthHelpers
    def current_user
      return @current_user if @current_user
  
      token = headers['Authorization']&.split(' ')&.last
      return nil unless token
  
      begin
        jwt_payload = Warden::JWTAuth::TokenDecoder.new.call(token)
        @current_user = User.find(jwt_payload['sub'])
      rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
        error!('Unauthorized. Invalid or expired token.', 401)
      end
    end
  
    def authenticate!
      error!('Unauthorized. Please log in.', 401) unless current_user
    end
  end
  