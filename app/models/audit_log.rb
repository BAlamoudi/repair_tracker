class AuditLog < ApplicationRecord
    belongs_to :repair_request
    belongs_to :user
  end