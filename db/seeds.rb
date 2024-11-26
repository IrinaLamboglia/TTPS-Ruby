# db/seeds.rb
Role.create(name: 'Administrador')
Role.create(name: 'Gerente')
Role.create(name: 'Empleado')

User.create(username: 'admin', email: 'admin@example.com', phone: '123456789', password: 'password', role: Role.find_by(name: 'Administrador'), join_date: Date.today)
User.create(username: 'gerente', email: 'gerente@example.com', phone: '123456789', password: 'password', role: Role.find_by(name: 'Gerente'), join_date: Date.today)
User.create(username: 'empleado', email: 'empleado@example.com', phone: '123456789', password: 'password', role: Role.find_by(name: 'Empleado'), join_date: Date.today)

Category.create(name: 'Ropa Deportiva')
Category.create(name: 'Calzado')
Category.create(name: 'Accesorios')

Product.create(name: 'Camiseta Deportiva', description: 'Camiseta de alta calidad', price: 29.99, stock: 100, category: Category.find_by(name: 'Ropa Deportiva'))
Product.create(name: 'Zapatillas Deportivas', description: 'Zapatillas cómodas y duraderas', price: 59.99, stock: 50, category: Category.find_by(name: 'Calzado'))
Product.create(name: 'Gorra Deportiva', description: 'Gorra ajustable', price: 19.99, stock: 200, category: Category.find_by(name: 'Accesorios'))