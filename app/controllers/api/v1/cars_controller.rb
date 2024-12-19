class Api::V1::CarsController < ApplicationController
  include Pagy::Backend
  respond_to :json
  before_action :authenticate_user!
  before_action :set_car, only: %i[ show update destroy ]

  # GET /cars or /cars.json
  def index
    @pagy, @cars = pagy(Car.all, limit: Car::LIMIT_PER_PAGE)
    respond_to do |format|
      format.json { render :index }
    end
  end

  # GET /cars/1 or /cars/1.json
  def show
    @pagy, @maintenance_services = pagy(@car.maintenance_services, limit: Car::LIMIT_PER_PAGE)
  end

  # POST /cars or /cars.json
  def create
    @car = Car.new(car_params)

    respond_to do |format|
      if @car.save
        format.json { render :show, status: :created, location: @car }
      else
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cars/1 or /cars/1.json
  def update
    respond_to do |format|
      if @car.update(car_params)
        format.json { render :show, status: :ok, location: @car }
      else
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cars/1 or /cars/1.json
  def destroy
    @car.destroy!

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  def set_car
    @car = Car.find(params[:id])
  end

  def car_params
    params.expect(car: [ :plate_number, :model_number, :year ])
  end
end
