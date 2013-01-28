class Car
  include Mongoid::Document

  field :brand, type: String
  field :type, type: String
  field :top_speed, type: Integer
  field :weight, type: Integer
end
