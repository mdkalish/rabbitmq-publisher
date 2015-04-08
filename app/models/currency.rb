class Currency < ActiveRecord::Base
  before_validation :assign_unique_uuid
  validates :uuid, presence: true, uniqueness: true

  private

  def assign_unique_uuid
    loop do
      key = SecureRandom.uuid
      break self.uuid = key unless self.class.exists?(uuid: key)
    end
  end
end
