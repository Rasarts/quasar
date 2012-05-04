RESTYPES = Dir.glob("#{Rails.root}/app/models/resources/*").map do |file|
  File.basename(file).split(".").first.classify
end