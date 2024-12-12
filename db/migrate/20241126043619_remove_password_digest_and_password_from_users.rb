class RemovePasswordDigestAndPasswordFromUsers < ActiveRecord::Migration[6.1]
  def change
    if column_exists?(:users, :password_digest)
      remove_column :users, :password_digest
    end
    if column_exists?(:users, :password)
      remove_column :users, :password
    end
  end
end
