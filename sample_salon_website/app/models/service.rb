class Service < ApplicationRecord
  validates :servicename, presence: true
  validates :servicecategory, presence: true
  validates :servicekeyword, presence: true
  validates :servicetime, presence: true
  validates :serviceprice, presence: true

  def get_service_categories
    service_category_list = [
      "カット",
      "パーマ",
      "カラー",
      "その他"
    ]
    return service_category_list
  end
end
