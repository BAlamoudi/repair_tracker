class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

         enum :role, { customer: 'customer', workshop: 'workshop', admin: 'admin' }
end
