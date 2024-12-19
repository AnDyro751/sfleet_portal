class MaintenanceServicesController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :set_maintenance_service, only: %i[ show edit update destroy ]
  before_action :set_car, except: %i[ index ]

  # GET /maintenance_services/new
  def new
    @maintenance_service = MaintenanceService.new
  end

  def index
    @q = MaintenanceService.includes(:car).ransack(params[:q])
    @pagy, @maintenance_services = pagy(@q.result, limit: Car::LIMIT_PER_PAGE)
  end


  # POST /maintenance_services or /maintenance_services.json
  def create
    @maintenance_service = @car.maintenance_services.new(maintenance_service_params)

    respond_to do |format|
      if @maintenance_service.save
        @pagy, @maintenance_services = pagy(@car.maintenance_services, limit: Car::LIMIT_PER_PAGE)
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace("maintenance_services_list", partial: "maintenance_services/list", locals: {
              maintenance_services: @maintenance_services,
              pagy: @pagy
            }),
            turbo_stream.remove("modal_create_maintenance_service")
          ]
        }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /maintenance_services/1 or /maintenance_services/1.json
  def update
    respond_to do |format|
      if @maintenance_service.update(maintenance_service_params)
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace("maintenance_service_#{@maintenance_service.id}", partial: "maintenance_services/maintenance_service", locals: {
              maintenance_service: @maintenance_service
            }),
            turbo_stream.remove("modal_create_maintenance_service")
          ]
        }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /maintenance_services/1 or /maintenance_services/1.json
  def destroy
    @maintenance_service.destroy!

    respond_to do |format|
      format.html { redirect_to request.referer, status: :see_other, notice: "Servicio de mantenimiento eliminado correctamente." }
    end
  end

  private
    def set_car
      if params[:car_id].present?
        @car = Car.find(params[:car_id])
      elsif @maintenance_service.present?
        @car = @maintenance_service.car
      else
        redirect_to maintenance_services_path, alert: "No se pudo encontrar el coche."
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
