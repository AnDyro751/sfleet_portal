require 'rails_helper'

RSpec.describe Api::SessionsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:valid_params) do
      {
        user: {
          email: user.email,
          password: user.password
        }
      }
    end

    let(:invalid_params) do
      {
        user: {
          email: user.email,
          password: 'wrong_password'
        }
      }
    end

    context 'with valid credentials' do
      it 'returns success status' do
        post :create, params: valid_params
        expect(response).to have_http_status(:ok)
      end

      it 'returns JWT token in response' do
        post :create, params: valid_params
        expect(JSON.parse(response.body)['status']['token']).to be_present
      end


      it 'sets Authorization header' do
        post :create, params: valid_params
        expect(response.headers['Authorization']).to be_present
        expect(response.headers['Authorization']).to start_with('Bearer ')
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized status' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error message' do
        post :create, params: invalid_params
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Email o contraseña inválidos')
      end
    end

    context 'with missing parameters' do
      it 'returns error for missing email' do
        post :create, params: { user: { password: 'password123' } }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error for missing password' do
        post :create, params: { user: { email: user.email } }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
