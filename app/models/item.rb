class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :shippingfrom

  belongs_to :buyer,  class_name: 'User', foreign_key: 'buyer_id', optional: true
  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id', optional: true

  has_many :photos
  belongs_to :category, optional: true

  accepts_nested_attributes_for :photos, allow_destroy: true

  validates :name, presence: true
  validates :description, presence: true
  validates :size, presence: true
  validates :status, presence: true
  validates :price, presence: true
  validates :shipping_fee, presence: true
  validates :shippingfrom, presence: true
  validates :shipping_days, presence: true
  validates :seller, presence: true
  validates :category, presence: true

end
