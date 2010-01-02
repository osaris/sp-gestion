class RenameMessagesRead < ActiveRecord::Migration
  def self.up
    add_column(:messages, :read_at, :timestamp, :default => nil)
    execute("UPDATE `messages` SET `read_at` = NOW() WHERE `read` = 1")
    remove_column(:messages, :read)
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
