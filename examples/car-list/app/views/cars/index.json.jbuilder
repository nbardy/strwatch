json.array!(@cars) do |car|
  json.extract! car, :brand, :type, :top_speed, :weight
  json.url car_url(car, format: :json)
end