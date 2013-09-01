class RemoveTypusUsersTable < ActiveRecord::Migration
  def up
    drop_table(:typus_users)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
