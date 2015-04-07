class Currency < ActiveRecord::Base
  before_validation :assign_unique_uuid
  validates :uuid, presence: true, uniqueness: true

  def self.generate_uuid
    SecureRandom.hex
  end

  private

  def assign_unique_uuid
    loop do
      key = self.class.generate_uuid
      break self.uuid = key unless self.class.exists?(uuid: key)
    end
  end
end
