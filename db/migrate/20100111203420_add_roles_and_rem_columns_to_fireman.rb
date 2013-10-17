class AddRolesAndRemColumnsToFireman < ActiveRecord::Migration
  def self.up
    add_column(:firemen, :rem, :text)
    add_column(:firemen, :chief, :boolean)
    add_column(:firemen, :chief_assistant, :boolean)
    add_column(:firemen, :quartermaster, :boolean)
    execute("UPDATE firemen SET chief='F', chief_assistant='F', quartermaster='F'")
  end

  def self.down
    remove_column(:firemen, :rem)
    remove_column(:firemen, :chief)
    remove_column(:firemen, :chief_assistant)
    remove_column(:firemen, :quartermaster)
  end
end
