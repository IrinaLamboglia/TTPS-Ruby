# Create permissions
permissions = {
  "manage_users" => Permission.find_or_create_by!(name: "manage_users"),
  "manage_products" => Permission.find_or_create_by!(name: "manage_products"),
  "manage_sales" => Permission.find_or_create_by!(name: "manage_sales")
}

# Create roles with permissions
roles = {
  "admin" => Role.find_or_create_by!(name: "admin"),
  "gerente" => Role.find_or_create_by!(name: "gerente"),
  "empleado" => Role.find_or_create_by!(name: "empleado"),
  "comun" => Role.find_or_create_by!(name: "comun")
}

roles["admin"].permissions = permissions.values
roles["gerente"].permissions = permissions.values
roles["empleado"].permissions = [ permissions["manage_products"], permissions["manage_sales"] ]
roles["comun"].permissions = []

roles.each { |name, role| role.save! }

# Create categories
categories = {
  "Ropa" => Category.find_or_create_by!(name: "Ropa"),
  "Calzado" => Category.find_or_create_by!(name: "Calzado")
}

# Load products
productos = [
  {
    name: "Pantalón Casual",
    description: "Cómodo pantalón para uso diario.",
    price: 30.0,
    stock: 20,
    category: categories["Ropa"],
    images: [ "pantalon1.jpg", "pantalon2.jpg" ]
  },
  {
    name: "Remera Lisa",
    description: "Remera ideal para cualquier ocasión.",
    price: 15.0,
    stock: 50,
    category: categories["Ropa"],
    images: [ "remera1.jpg", "remera2.jpg", "remera3.jpg" ]
  },
  {
    name: "Zapatillas Vans",
    description: "Clásicas Vans, cómodas y con estilo.",
    price: 60.0,
    stock: 10,
    category: categories["Calzado"],
    images: [ "zapatillas1.jpg", "zapatillas2.jpg" ]
  }
]

productos.each do |producto|
  product = Product.new(
    name: producto[:name],
    description: producto[:description],
    price: producto[:price],
    stock: producto[:stock],
    category: producto[:category]
  )

  producto[:images].each do |image|
    image_path = Rails.root.join("app/assets/images", image)
    if File.exist?(image_path)
      product.images.attach(io: File.open(image_path), filename: image, content_type: "image/jpeg")
    else
      puts "Imagen no encontrada: #{image_path}"
    end
  end

  if product.save
    puts "Producto creado: #{product.name}"
  else
    puts "Error al crear producto: #{product.errors.full_messages.join(", ")}"
  end
end

# Crear usuarios
User.create!(
  username: "admin_user",
  email: "admin@example.com",
  phone: "1234567890",
  active: true,
  role: roles["admin"],
  join_date: Date.today,
  password: "password",
  password_confirmation: "password"
)

2.times do |i|
  User.create!(
    username: "gerente_user_#{i + 1}",
    email: "gerente#{i + 1}@example.com",
    phone: "123456789#{i + 1}",
    active: true,
    role: roles["gerente"],
    join_date: Date.today,
    password: "password",
    password_confirmation: "password"
  )

  User.create!(
    username: "empleado_user_#{i + 1}",
    email: "empleado#{i + 1}@example.com",
    phone: "123456780#{i + 1}",
    active: true,
    role: roles["empleado"],
    join_date: Date.today,
    password: "password",
    password_confirmation: "password"
  )

  User.create!(
    username: "comun_user_#{i + 1}",
    email: "comun#{i + 1}@example.com",
    phone: "123456770#{i + 1}",
    active: true,
    role: roles["comun"],
    join_date: Date.today,
    password: "password",
    password_confirmation: "password"
  )
end


puts "Seeds completados con éxito."
