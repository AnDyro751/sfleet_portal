class CarsController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :set_car, only: %i[ show edit update destroy ]

  # GET /cars or /cars.json
  def index
    @pagy, @cars = pagy(Car.all, limit: Car::LIMIT_PER_PAGE)
  end

  # GET /cars/1 or /cars/1.json
  def show
    @pagy, @maintenance_services = pagy(@car.maintenance_services, limit: Car::LIMIT_PER_PAGE)
    @maintenance_service = @car.maintenance_services.new
  end

  # GET /cars/new
  def new
    @car = Car.new
  end

  # GET /cars/1/edit
  def edit
  end

  # POST /cars or /cars.json
  def create
    @car = Car.new(car_params)

    respond_to do |format|
      if @car.save
        format.html { redirect_to @car, notice: "Se ha creado el coche correctamente." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cars/1 or /cars/1.json
  def update
    respond_to do |format|
      if @car.update(car_params)
        format.html { redirect_to @car, notice: "Se ha actualizado el coche correctamente." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cars/1 or /cars/1.json
  def destroy
    @car.destroy!

    respond_to do |format|
      format.html { redirect_to cars_path, status: :see_other, notice: "Se ha eliminado el coche correctamente." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car
      @car = Car.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def car_params
      params.expect(car: [ :plate_number, :model_number, :year ])
    end
end
