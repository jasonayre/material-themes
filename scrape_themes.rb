require 'nokogiri'
require 'open-uri'
require 'pry'
require 'json'

doc = Nokogiri::HTML(open("https://material.io/guidelines/style/color.html#color-color-palette"))

groups = doc.css("#color-color-palette .col-list .module-module-module .module")

themes = {}

groups.each do |group|
  theme_name = group.css(".group").text.downcase.gsub(" ", "-")
  next if theme_name.length == 0  
  theme = themes[theme_name] = []

  group.css(".color-tag .details").to_a.each do |color|
    theme.push({
      shade: color.css(".shade").text,
      hex: color.css(".hex").text
    })    
  end
end

themes.values.map(&:shift)

File.open("material_theme_colors.json", "w+") do |f|
  f.puts JSON.generate(themes)
end