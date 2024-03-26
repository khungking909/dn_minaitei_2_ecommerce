# frozen_string_literal: true

# db/seeds.rb

# db/seeds.rb

brands = %w[
  Apple
  Samsung
  Huawei
  Xiaomi
  Oppo
  OnePlus
  Google
  Sony
  LG
  Nokia
  Motorola
  HTC
  ASUS
  Lenovo
  Realme
  Vivo
  BlackBerry
  ZTE
  Alcatel
  Honor
  TCL
  Meizu
  Infinix
  Poco
  Razer
  Essential
]

brands.each do |brand_name|
  category = Category.create(name: brand_name)
  5.times do |n|
    Product.create(
      name: "#{brand_name} Phone #{n + 1}",
      description: "Description for #{brand_name} Phone #{n + 1}",
      price: rand(500..2000),
      quantity: rand(1..50),
      category_id: category.id
    )
  end
end

Rails.logger.debug("Categories and Products seeded successfully!")
