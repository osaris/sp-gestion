class AddHideGradeToConvocations < ActiveRecord::Migration
  def self.up
    add_column(:convocations, :hide_grade, :boolean, :default => false)
  end

  def self.down
    remove_column(:convocations, :hide_grade)
  end
end
