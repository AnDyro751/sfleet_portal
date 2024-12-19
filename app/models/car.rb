class Car < ApplicationRecord
  LIMIT_PER_PAGE = 6

  has_many :maintenance_services, dependent: :destroy

  validates :plate_number, presence: true, uniqueness: { case_sensitive: false }, length: { in: 1..30 }
  validates :model_number, presence: true, length: { in: 1..50 }
  validates :year, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1900, less_than_or_equal_to: Date.today.year }

  before_save :set_plate_number_to_uppercase

  def self.ransackable_attributes(auth_object = nil)
    [ "plate_number" ]
  end

  private

  def set_plate_number_to_uppercase
    return if plate_number.blank?
    self.plate_number = plate_number.parameterize.upcase
  end
end
