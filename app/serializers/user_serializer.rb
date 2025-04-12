class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :full_name, :role, 
             :is_authenticated, :nationality, :country_flag, :national_id
end
