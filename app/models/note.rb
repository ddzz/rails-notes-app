class Note < ApplicationRecord
  belongs_to :user
  before_validation :set_title, on: [:create, :update]
  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 30 }
  validates :body, length: { maximum: 1000 }
  attr_accessor :email_address

  private

  def set_title
    self.title = self.body.truncate(30, omission: "") if self.title.blank?
  end
end
