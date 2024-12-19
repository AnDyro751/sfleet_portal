require 'rails_helper'

RSpec.describe Api::V1::CarsController, type: :controller do
  render_views
  let(:user) { create(:user) }
  let(:valid_attributes) { attributes_for(:car) }
  let(:invalid_attributes) { attributes_for(:car, plate_number: nil) }
  let(:valid_headers) {
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
  }

  before do
    sign_in user
  end

  describe "GET #index" do
    context "when user is not authenticated" do
      before do
        sign_out user
      end

      it "returns unauthorized status" do
        get :index, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user is authenticated" do
      login_user(with_content_type: true)

      let!(:cars) { create_list(:car, 3) }

      it "returns a success response" do
        get :index, format: :json, params: { format: :json }
        expect(response).to be_successful
      end

      it "returns all user's cars" do
        get :index, format: :json
        json_response = JSON.parse(response.body)
        expect(json_response['cars'].length).to eq(3)
      end

      it "paginates results" do
        create_list(:car, 10)
        get :index, format: :json
        json_response = JSON.parse(response.body)
        # Because the limit is 6, we expect 2 pages
        expect(json_response['pagination']['total_pages']).to eq(3)
      end
    end
  end

  describe "GET #show" do
    let(:car) { create(:car) }

    context "when user is not authenticated" do
      before do
        sign_out user
      end

      it "returns unauthorized status" do
        get :show, params: { id: car.id }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user is authenticated" do
      login_user(with_content_type: true)
      it "returns a success response" do
        get :show, params: { id: car.id }, format: :json
        expect(response).to be_successful
      end

      it "returns the requested car" do
        get :show, params: { id: car.id }, format: :json
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(car.id)
      end
    end
  end

  describe "POST #create" do
    context "when user is not authenticated" do
      before do
        sign_out user
      end

      it "returns unauthorized status" do
        post :create, params: { car: valid_attributes }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user is authenticated" do
      context "with valid params" do
        login_user(with_content_type: true)

        it "creates a new Car" do
          expect {
            post :create, params: { car: valid_attributes }, format: :json
          }.to change(Car, :count).by(1)
        end

        it "renders a JSON response with the new car" do
          post :create, params: { car: valid_attributes }, format: :json
          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end

      context "with invalid params" do
        login_user(with_content_type: true)

        it "renders a JSON response with errors" do
          post :create, params: { car: invalid_attributes }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end
  end

  describe "PUT #update" do
    let(:car) { create(:car) }
    let(:new_attributes) { { plate_number: "NEW123" } }

    context "when user is not authenticated" do
      before do
        sign_out user
      end

      it "returns unauthorized status" do
        put :update, params: { id: car.id, car: new_attributes }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user is authenticated" do
      context "with valid params" do
        login_user(with_content_type: true)

        it "updates the requested car" do
          put :update, params: { id: car.id, car: new_attributes }, format: :json
          car.reload
          expect(car.plate_number).to eq("NEW123")
        end

        it "renders a JSON response with the car" do
          put :update, params: { id: car.id, car: new_attributes }, format: :json
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end

      context "with invalid params" do
        login_user(with_content_type: true)

        it "renders a JSON response with errors" do
          put :update, params: { id: car.id, car: invalid_attributes }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:car) { create(:car) }

    context "when user is not authenticated" do
      before do
        sign_out user
      end

      it "returns unauthorized status" do
        delete :destroy, params: { id: car.id }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user is authenticated" do
      login_user(with_content_type: true)

      it "destroys the requested car" do
        expect {
          delete :destroy, params: { id: car.id }, format: :json
        }.to change(Car, :count).by(-1)
      end

      it "returns a no content response" do
        delete :destroy, params: { id: car.id }, format: :json
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
