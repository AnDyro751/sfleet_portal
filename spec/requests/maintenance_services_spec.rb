require 'rails_helper'

RSpec.describe MaintenanceServicesController, type: :controller do
  describe "GET /new" do
    context "when user is not logged in" do
      before do
        get :new, params: { car_id: 1 }
      end

      it "returns 302 status" do
        expect(response).to have_http_status(:found)
      end
    end

    context "when user is logged in" do
      login_user

      it "returns 200 status" do
        get :new, params: { car_id: create(:car).id }
        expect(response).to have_http_status(:success)
      end

      it "redirects to root path with alert" do
        get :new, params: { car_id: nil }
        expect(response).to redirect_to(maintenance_services_path)
        expect(flash[:alert]).to eq("No se pudo encontrar el coche.")
      end
    end
  end

  describe "GET /index" do
    context "when user is not logged in" do
      before do
        get :index
      end

      it "returns 302 status" do
        expect(response).to have_http_status(:found)
      end

      it "redirects to the login page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      login_user

      it "returns 200 status" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "POST /create" do
    let(:valid_attributes) { attributes_for(:maintenance_service) }
    let(:invalid_attributes) { attributes_for(:maintenance_service, description: nil) }
    let(:car) { create(:car) }

    context "when user is not logged in" do
      it "redirects to login page" do
        post :create, params: { car_id: car.id, maintenance_service: valid_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      login_user

      context "with valid params" do
        it "creates a new maintenance service" do
          expect {
            post :create, params: {
              car_id: car.id,
              maintenance_service: valid_attributes
            }, format: :turbo_stream
          }.to change(MaintenanceService, :count).by(1)
        end

        it "renders turbo stream on success" do
          post :create, params: {
            car_id: car.id,
            maintenance_service: valid_attributes
          }, format: :turbo_stream
          expect(response.media_type).to eq Mime[:turbo_stream]
        end
      end

      context "with invalid params" do
        it "returns unprocessable entity status" do
          post :create, params: { car_id: car.id, maintenance_service: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe "PATCH /update" do
    let(:maintenance_service) { create(:maintenance_service, car: car) }
    let(:new_attributes) { { description: "Updated description" } }
    let(:invalid_attributes) { { description: nil } }
    let(:car) { create(:car) }

    context "when user is not logged in" do
      it "redirects to login page" do
        patch :update, params: {
          id: maintenance_service.id,
          maintenance_service: new_attributes
        }, format: :turbo_stream
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      login_user

      context "with valid params" do
        it "updates the requested maintenance service" do
          patch :update, params: {
            id: maintenance_service.id,
            maintenance_service: new_attributes
          }, format: :turbo_stream
          maintenance_service.reload
          expect(maintenance_service.description).to eq("Updated description")
        end

        it "renders turbo stream on success" do
          patch :update, params: {
            id: maintenance_service.id,
            maintenance_service: new_attributes
          }, format: :turbo_stream
          expect(response.media_type).to eq Mime[:turbo_stream]
        end
      end

      context "with invalid params" do
        it "returns unprocessable entity status" do
          patch :update, params: {
            id: maintenance_service.id,
            maintenance_service: invalid_attributes
          }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe "DELETE /destroy" do
    let(:car) { create(:car) }
    let!(:maintenance_service) { create(:maintenance_service, car: car) }

    context "when user is not logged in" do
      it "redirects to login page" do
        delete :destroy, params: { id: maintenance_service.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      login_user

      it "destroys the requested maintenance service" do
        # Set the referer to maintenance_services_path
        # because it's the path that the user is redirected to after deleting a maintenance service
        request.env["HTTP_REFERER"] = maintenance_services_path
        expect {
          delete :destroy, params: { id: maintenance_service.id }
        }.to change(MaintenanceService, :count).by(-1)
      end

      it "redirects back to referer" do
        request.env["HTTP_REFERER"] = maintenance_services_path
        delete :destroy, params: { id: maintenance_service.id }
        expect(response).to redirect_to(maintenance_services_path)
      end
    end
  end
end
