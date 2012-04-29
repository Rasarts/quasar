DOCTYPES = Dir.glob("#{Rails.root}/app/models/documents/*").map do |file|
  File.basename(file).split(".").first.classify
end