require 'rails_helper'

RSpec.describe Api::V1::MaintenanceServicesController, type: :controller do
  render_views

  let(:user) { create(:user) }
  let(:car) { create(:car) }
  let(:valid_attributes) { attributes_for(:maintenance_service, car_id: car.id) }
  let(:invalid_attributes) { attributes_for(:maintenance_service, description: nil) }

  before do
    sign_in user
  end

  describe "GET #index" do
    context "when user is not authenticated" do
      before { sign_out user }

      it "returns unauthorized status" do
        get :index, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user is authenticated" do
      login_user(with_content_type: true)

      let!(:maintenance_services) { create_list(:maintenance_service, 3, car: car) }

      it "returns a success response" do
        get :index, format: :json
        expect(response).to be_successful
        expect(response.content_type).to include('application/json')
      end

      it "returns paginated results" do
        create_list(:maintenance_service, 10, car: car)
        get :index, format: :json
        json_response = JSON.parse(response.body)
        expect(json_response['pagination']['total_pages']).to eq(3)
      end
    end
  end

  describe "GET #show" do
    let(:maintenance_service) { create(:maintenance_service, car: car) }

    context "when user is not authenticated" do
      before { sign_out user }

      it "returns unauthorized status" do
        get :show, params: { id: maintenance_service.id }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user is authenticated" do
      login_user(with_content_type: true)

      it "returns the requested maintenance service" do
        get :show, params: { id: maintenance_service.id }, format: :json
        expect(response).to be_successful
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(maintenance_service.id)
      end
    end
  end

  describe "POST #create" do
    context "when user is not authenticated" do
      before { sign_out user }

      it "returns unauthorized status" do
        post :create, params: { car_id: car.id, maintenance_service: valid_attributes }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user is authenticated" do
      login_user(with_content_type: true)

      context "with valid params" do
        it "creates a new maintenance service" do
          expect {
            post :create, params: {
              car_id: car.id,
              maintenance_service: valid_attributes
            }, format: :json
          }.to change(MaintenanceService, :count).by(1)
        end

        it "renders a json response" do
          post :create, params: {
            car_id: car.id,
            maintenance_service: valid_attributes
          }, format: :json
          expect(response.media_type).to eq Mime[:json]
        end
      end

      context "with invalid params" do
        it "returns unprocessable entity status" do
          post :create, params: {
            car_id: car.id,
            maintenance_service: invalid_attributes
          }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe "PATCH #update" do
    let(:maintenance_service) { create(:maintenance_service, car: car) }
    let(:new_attributes) { { description: "Updated description" } }

    context "when user is not authenticated" do
      before { sign_out user }

      it "returns unauthorized status" do
        patch :update, params: {
          id: maintenance_service.id,
          maintenance_service: new_attributes
        }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user is authenticated" do
      login_user(with_content_type: true)

      context "with valid params" do
        it "updates the requested maintenance service" do
          patch :update, params: {
            id: maintenance_service.id,
            maintenance_service: new_attributes
          }, format: :json
          maintenance_service.reload
          expect(maintenance_service.description).to eq("Updated description")
        end

        it "renders a json response" do
          patch :update, params: {
            id: maintenance_service.id,
            maintenance_service: new_attributes
          }, format: :json
          expect(response.media_type).to eq Mime[:json]
        end
      end

      context "with invalid params" do
        it "returns unprocessable entity status" do
          patch :update, params: {
            id: maintenance_service.id,
            maintenance_service: invalid_attributes
          }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:maintenance_service) { create(:maintenance_service, car: car) }

    context "when user is not authenticated" do
      before { sign_out user }

      it "returns unauthorized status" do
        delete :destroy, params: { id: maintenance_service.id }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user is authenticated" do
      login_user(with_content_type: true)

      it "destroys the requested maintenance service" do
        expect {
          delete :destroy, params: { id: maintenance_service.id }, format: :json
        }.to change(MaintenanceService, :count).by(-1)
      end

      it "returns a no content response" do
        delete :destroy, params: { id: maintenance_service.id }, format: :json
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
