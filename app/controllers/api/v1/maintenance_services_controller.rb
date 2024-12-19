class Api::V1::MaintenanceServicesController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :set_maintenance_service, only: %i[ update destroy show ]

  def index
    @pagy, @maintenance_services = pagy(MaintenanceService.all, limit: Car::LIMIT_PER_PAGE)
  end

  def show
  end


  # POST /maintenance_services or /maintenance_services.json
  def create
    set_car
    @maintenance_service = @car.maintenance_services.new(maintenance_service_params)

    respond_to do |format|
      if @maintenance_service.save
        format.json { render :show, status: :created, location: @maintenance_service }
      else
        format.json { render json: @maintenance_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /maintenance_services/1 or /maintenance_services/1.json
  def update
    set_car
    respond_to do |format|
      if @maintenance_service.update(maintenance_service_params)
        format.json { render :show, status: :ok, location: @maintenance_service }
      else
        format.json { render json: @maintenance_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /maintenance_services/1 or /maintenance_services/1.json
  def destroy
    @maintenance_service.destroy!

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    def set_car
      if params[:car_id].present?
        @car = Car.find(params[:car_id])
      else
        @car = @maintenance_service.car
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_maintenance_service
      @maintenance_service = MaintenanceService.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def maintenance_service_params
      params.expect(maintenance_service: [ :car_id, :description, :status, :date ])
    end
end
