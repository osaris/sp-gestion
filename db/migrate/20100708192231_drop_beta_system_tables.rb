class DropBetaSystemTables < ActiveRecord::Migration
  def self.up
    drop_table(:beta_codes)
    drop_table(:newsletters)
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
