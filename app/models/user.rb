class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  validates :full_name, presence: true, length: { maximum: 100 }
  validates :national_id, uniqueness: true, allow_blank: true
  validates :role, inclusion: { in: ->(_) { User.roles.keys } } # Fixed validation with lambda
  validates :is_authenticated, inclusion: { in: [true, false] }

  # Enum for roles
  enum role: { guest: "guest", customer: "customer", admin: "admin", staff: "staff" }

  # Callbacks
  before_validation :set_password_for_customers
  before_create :set_default_authentication_status

  # Instance Methods
  def authenticate!
    update!(is_authenticated: true)
  end

  def unauthenticate!
    update!(is_authenticated: false)
  end

  private

  # Set a default password for customers if none is provided
  def set_password_for_customers
    if customer? && encrypted_password.blank?
      errors.add(:password, "can't be blank for customers")
    end
  end

  # Set default value for `is_authenticated` before creating a user
  def set_default_authentication_status
    self.is_authenticated = false if is_authenticated.nil?
  end
end
