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

# Crear permisos
permissions = ["manage_users", "manage_products", "manage_sales"].map do |permission_name|
  permission = Permission.find_or_create_by!(name: permission_name)
  puts "Permiso creado: #{permission.name}"
  permission
end

# Crear roles y asignar permisos
roles = {
  "admin" => ["manage_users", "manage_products", "manage_sales"],
  "gerente" => ["manage_users,manage_products", "manage_sales"],
  "empleado" => ["manage_products", "manage_sales"]
}

roles.each do |role_name, role_permissions|
  role = Role.find_or_create_by!(name: role_name)
  puts "Rol creado: #{role.name}"
  role_permissions.each do |permission_name|
    permission = Permission.find_by(name: permission_name)
    if permission
      RolePermission.find_or_create_by!(role: role, permission: permission)
      puts "Asignado permiso '#{permission.name}' al rol '#{role.name}'"
    else
      puts "Permiso '#{permission_name}' no encontrado"
    end
  end
end
# Crear usuarios con Devise
roles.keys.each do |role_name|
  role = Role.find_by(name: role_name)
  User.find_or_create_by!(
    username: "#{role_name}_user",
    email: "#{role_name}@example.com",
    phone: "1234567890",
    role: role,
    join_date: Date.today
  ) do |user|
    user.password = "password"
    user.password_confirmation = "password"
  end
end