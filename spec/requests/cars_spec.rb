require 'rails_helper'

RSpec.describe CarsController, type: :controller do
  let(:valid_attributes) { attributes_for(:car) }
  let(:invalid_attributes) { attributes_for(:car, plate_number: nil) }

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

      it "returns cars" do
        car = create(:car)
        get :index
        expect(controller.instance_variable_get(:@cars)).to include(car)
      end

      it "paginates the results" do
        get :index
        expect(controller.instance_variable_get(:@pagy)).to be_a(Pagy)
      end
    end
  end

  describe "GET /show" do
    context "when user is not logged in" do
      it "redirects to login page" do
        car = create(:car)
        get :show, params: { id: car.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      login_user

      it "returns success" do
        car = create(:car)
        get :show, params: { id: car.id }
        expect(response).to be_successful
      end

      it "returns maintenance services" do
        car = create(:car)
        maintenance_service = create(:maintenance_service, car: car)
        get :show, params: { id: car.id }
        expect(controller.instance_variable_get(:@maintenance_services)).to include(maintenance_service)
      end
    end
  end

  describe "GET /new" do
    context "when user is not logged in" do
      it "redirects to login page" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      login_user

      it "returns success" do
        get :new
        expect(response).to be_successful
      end

      it "initializes a new car" do
        get :new
        expect(controller.instance_variable_get(:@car)).to be_a_new(Car)
      end
    end
  end

  describe "POST /create" do
    context "when user is not logged in" do
      it "redirects to login page" do
        post :create, params: { car: valid_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      login_user

      context "with valid params" do
        it "creates a new car" do
          expect {
            post :create, params: { car: valid_attributes }
          }.to change(Car, :count).by(1)
        end

        it "redirects to the created car" do
          post :create, params: { car: valid_attributes }
          expect(response).to redirect_to(Car.last)
        end

        it "sets a success notice" do
          post :create, params: { car: valid_attributes }
          expect(flash[:notice]).to eq("Se ha creado el coche correctamente.")
        end
      end

      context "with invalid params" do
        it "does not create a new car" do
          expect {
            post :create, params: { car: invalid_attributes }
          }.not_to change(Car, :count)
        end

        it "returns unprocessable entity status" do
          post :create, params: { car: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe "GET /edit" do
    context "when user is not logged in" do
      it "redirects to login page" do
        car = create(:car)
        get :edit, params: { id: car.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      login_user

      it "returns success" do
        car = create(:car)
        get :edit, params: { id: car.id }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "when user is not logged in" do
      it "redirects to login page" do
        car = create(:car)
        patch :update, params: { id: car.id, car: valid_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      login_user
      let(:car) { create(:car) }
      let(:new_attributes) { { plate_number: "NEW123" } }

      context "with valid params" do
        it "updates the requested car" do
          patch :update, params: { id: car.id, car: new_attributes }
          car.reload
          expect(car.plate_number).to eq("NEW123")
        end

        it "redirects to the car" do
          patch :update, params: { id: car.id, car: new_attributes }
          expect(response).to redirect_to(car)
        end

        it "sets a success notice" do
          patch :update, params: { id: car.id, car: new_attributes }
          expect(flash[:notice]).to eq("Se ha actualizado el coche correctamente.")
        end
      end

      context "with invalid params" do
        it "returns unprocessable entity status" do
          patch :update, params: { id: car.id, car: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe "DELETE /destroy" do
    context "when user is not logged in" do
      it "redirects to login page" do
        car = create(:car)
        delete :destroy, params: { id: car.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      login_user
      let!(:car) { create(:car) }

      it "destroys the requested car" do
        expect {
          delete :destroy, params: { id: car.id }
        }.to change(Car, :count).by(-1)
      end

      it "redirects to the cars list" do
        delete :destroy, params: { id: car.id }
        expect(response).to redirect_to(cars_path)
      end

      it "sets a success notice" do
        delete :destroy, params: { id: car.id }
        expect(flash[:notice]).to eq("Se ha eliminado el coche correctamente.")
      end
    end
  end
end
