class RepairRequest < ApplicationRecord
    belongs_to :customer, class_name: 'User', foreign_key: 'customer_id'
    belongs_to :workshop, class_name: 'User', foreign_key: 'workshop_id', optional: true
  
    STATUSES = %w[submitted under_review quoted approved rejected].freeze
  
    validates :vehicle_details, presence: true
    validates :problem_description, presence: true
    validates :status, inclusion: { in: STATUSES }
  end
