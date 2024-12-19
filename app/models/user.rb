class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::JTIMatcher

  before_create :set_jti

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true
  validates :jti, presence: true, uniqueness: true

  private

  def set_jti
    self.jti ||= SecureRandom.uuid
  end
end
