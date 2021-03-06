json.array!(@photos) do |photo|
  json.extract! photo, :id, :name, :description, :image_paths
  json.url photo_url(photo, format: :json)
end
