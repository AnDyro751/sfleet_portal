module Api
  class SessionsController < Devise::SessionsController
    protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token
    skip_before_action :authenticate_user!, only: [ :create ]
    respond_to :json

    def create
      user = User.find_by(email: sign_in_params[:email])

      if user && user.valid_password?(sign_in_params[:password])
        sign_in(user)
        respond_with(user)
      else
        render json: {
          error: "Email o contraseña inválidos"
        }, status: :unauthorized
      end
    end

    private

    def respond_with(resource, _opt = {})
      headers["Authorization"] = "Bearer #{current_token}"

      render json: {
        status: {
          code: 200,
          token: current_token
        }
      }, status: :ok
    end

    def current_token
      request.env["warden-jwt_auth.token"] ||
        JWT.encode(
          {
            sub: current_user.id,
            jti: current_user.jti,
            scp: "user",
            exp: (Time.now + 24.hours).to_i
          },
          Rails.application.credentials.devise_jwt_secret_key!,
          "HS256"
        )
    end

    def sign_in_params
      params.require(:user).permit(:email, :password)
    end

    def respond_to_on_destroy
      jwt_token = request.headers["Authorization"]&.split("Bearer ")&.last

      if jwt_token
        begin
          jwt_payload = JWT.decode(
            jwt_token,
            Rails.application.credentials.devise_jwt_secret_key!,
            true,
            algorithm: "HS256"
          ).first

          current_user = User.find(jwt_payload["sub"])
          sign_out(current_user)

          render json: {
            status: 200,
            message: "Sesión cerrada correctamente."
          }, status: :ok
        rescue JWT::DecodeError, ActiveRecord::RecordNotFound
          render json: {
            status: 401,
            message: "Token inválido."
          }, status: :unauthorized
        end
      else
        render json: {
          status: 401,
          message: "No se pudo encontrar una sesión activa."
        }, status: :unauthorized
      end
    end
  end
end
