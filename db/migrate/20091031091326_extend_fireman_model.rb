class ExtendFiremanModel < ActiveRecord::Migration
  def self.up
    add_column(:firemen, :grade, :integer)
    add_column(:firemen, :status, :integer)
    add_column(:firemen, :grade_category, :integer)
    add_column(:firemen, :birthday, :date)
  end

  def self.down
    remove_column(:firemen, :birthday)
    remove_column(:firemen, :grade_category)
    remove_column(:firemen, :status)
    remove_column(:firemen, :grade)
  end
end
