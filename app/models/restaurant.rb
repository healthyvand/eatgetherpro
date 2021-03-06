# == Schema Information
#
# Table name: restaurants
#
#  id          :integer          not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :string
#

class Restaurant < ApplicationRecord
  has_many :posts, :through => :post_restaurant ,source: :post
  has_many :post_restaurants
  has_many :photos, :as => :photoable
end
