# config/initializers/active_storage.rb
Rails.application.configure do
    config.after_initialize do
      ActiveStorage::Current.url_options = {
        host: 'localhost',
        port: 3000,
        protocol: 'http'
      }
    end
  end
  