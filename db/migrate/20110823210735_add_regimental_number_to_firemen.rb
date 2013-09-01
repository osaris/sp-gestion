class AddRegimentalNumberToFiremen < ActiveRecord::Migration
  def self.up
    add_column(:firemen, :regimental_number, :string)
  end

  def self.down
    remove_column(:firemen, :regimental_number)
  end
end
