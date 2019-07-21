class Service < ApplicationRecord
  validates :servicename, presence: true
  validates :servicetypename, presence: true
  validates :servicekeyword, presence: true
  validates :serviceflg, presence: true
  validates :servicetime, presence: true
  validates :serviceprice, presence: true
end
