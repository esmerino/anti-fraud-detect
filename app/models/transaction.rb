class Transaction < ApplicationRecord
  after_initialize :init

  enum recommendation: { analyzing: 0, approve: 1, deny: 2 }

  def init
    self.device_id ||= 0
  end
end
