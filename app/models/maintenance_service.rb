class MaintenanceService < ApplicationRecord
  belongs_to :car

  default_scope { order(date: :desc) }

  validates :description, presence: true, length: { in: 1..255 }
  validates :status, presence: true
  validates :date, presence: true

  enum :status, { pending: 0, in_progress: 1, completed: 2 }, prefix: true

  validate :date_is_a_valid_date

  def self.ransackable_attributes(auth_object = nil)
    [ "status" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "car" ]
  end

  ransacker :status, formatter: proc { |v| statuses[v] } do |parent|
    parent.table[:status]
  end

  private

  def date_is_a_valid_date
    if date.present? && date > Date.current
      errors.add(:date, "Debe ser una fecha válida")
    end
  end
end
