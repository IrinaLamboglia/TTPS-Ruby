class AddDeviseToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      ## Confirmable (solo si planeas usarlo)
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Solo si usas confirmable

      ## Lockable (opcional)
      # t.integer  :failed_attempts, default: 0, null: false # Intentos fallidos
      # t.string   :unlock_token # Para desbloquear la cuenta
      # t.datetime :locked_at
    end

    # Agrega índices que falten
    # Si ya existen, usa una verificación para evitar conflictos
    add_index :users, :email, unique: true unless index_exists?(:users, :email)
    add_index :users, :reset_password_token, unique: true unless index_exists?(:users, :reset_password_token)
    # add_index :users, :confirmation_token, unique: true # Para confirmable
    # add_index :users, :unlock_token, unique: true # Para lockable
  end
end
