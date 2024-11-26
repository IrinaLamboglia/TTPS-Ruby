# db/seeds.rb
# Crear categorías
categories = ["Ropa", "Accesorios", "Calzado"].map do |category_name|
  Category.find_or_create_by!(name: category_name)
end

# Crear productos
10.times do |i|
  product = Product.new(
    name: "Producto #{i + 1}",
    description: "Descripción del producto #{i + 1}",
    price: rand(10..100),
    stock: rand(1..50),
    category: categories.sample
  )

  # Adjuntar una imagen
  begin
    product.images.attach(io: File.open(Rails.root.join("app/assets/images/ejemplo.jpg")), filename: "ejemplo.jpg", content_type: "image/jpg")
    product.save!(validate: false) # Guardar sin validaciones
    product.save! # Guardar con validaciones
  rescue => e
    puts "Error al adjuntar imagen para producto #{product.name}: #{e.message}"
  end
end

# Crear roles
roles = ["admin", "gerente", "empleado"].map do |role_name|
  Role.find_or_create_by!(name: role_name)
end

# Crear usuarios con Devise
roles.each do |role|
  user = User.find_or_create_by!(
    username: "#{role.name}_user",
    email: "#{role.name}@example.com",
    phone: "1234567890",
    role: role,  # Pasar el objeto `role`, no el nombre
    join_date: Date.today
  ) do |user|
    user.password = "password"
    user.password_confirmation = "password"
  end
end

# Crear ventas
users = User.all
products = Product.all
5.times do
  sale = Sale.create!(
    date: Date.today,
    total: rand(100..500),
    employee: users.sample,
    customer: users.sample 
  )
  3.times do
    sale.sale_items.create!(
      product: products.sample,
      quantity: rand(1..5),
      price: rand(10..100)
    )
  end
end