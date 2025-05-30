class AuditLog < ApplicationRecord
  belongs_to :user
  belongs_to :auditable, polymorphic: true
end
