class Micropost < ApplicationRecord
  belongs_to :user
  
  has_many :favorites, dependent: :destroy
  has_many :users_who_add_favorite, through: :favorites, source: :user
  
  validates :content, presence: true, length: {maximum: 255}
  
  def count_users
    if self.users_who_add_favorite == nil
      return 0
    else
      return self.users_who_add_favorite.count
    end
  end
  
end
