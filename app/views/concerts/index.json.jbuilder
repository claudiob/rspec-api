json.array!(@concerts) do |concert|
  json.extract! concert, :where, :year
end
