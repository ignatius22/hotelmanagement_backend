class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
 
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  validates :full_name, presence: true, length: { maximum: 100 }
  validates :national_id, uniqueness: true, allow_blank: true
  enum role: { guest: "guest", customer: "customer", admin: "admin", staff: "staff" }

  before_validation :set_password_for_customers

  private

    def set_password_for_customers
      if customer? && encrypted_password.blank?
        errors.add(:password, "can't be blank for customers")
      end
    end

end
