# frozen_string_literal: true

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
10.times do
  Account.create(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    role: Account.roles[:user],
    address: Faker::Address.full_address,
    phone_number: Faker::PhoneNumber.phone_number,
    password_digest: BCrypt::Password.create(Faker::Internet.password)
  )
end

brands.each do |brand_name|
  category = Category.create(name: brand_name)
  5.times do |n|
    product = Product.create(
      name: "#{brand_name} Phone #{n + 1}",
      description: "Description for #{brand_name} Phone #{n + 1}",
      price: rand(5..200) * 1_000_000,
      quantity: rand(1..50),
      category_id: category.id,
      is_deleted: false
    )

    file_path = "/home/huynhductruong/Downloads/image#{n + 1}.jpeg"
    File.open(file_path) do |file|
      product.image.attach(io: file, filename: "#{product.name}.jpg")
    end
  end
end

50.times do
  order = Order.create(
    account_id: rand(1..Account.count),
    status: rand(0..3),
    receiver_name: Faker::Name.name,
    receiver_address: Faker::Address.full_address,
    receiver_phone_number: Faker::PhoneNumber.phone_number,
    message: Faker::Lorem.sentence
  )
  rand(1..5).times do
    OrderHistory.create(
      order_id: order.id,
      product_id: rand(1..Product.count),
      quantity: rand(1..5),
      current_price: rand(5..200) * 1_000_000
    )
  end
end

50.times do
  Comment.create(
    account_id: rand(1..Account.count),
    product_id: rand(1..Product.count),
    content: Faker::Lorem.paragraph,
    rating: rand(1..5)
  )
end

Rails.logger.debug("Categories, Products, Orders, Comments, and OrderHistories seeded successfully!")
