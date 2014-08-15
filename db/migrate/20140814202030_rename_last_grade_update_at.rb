class RenameLastGradeUpdateAt < ActiveRecord::Migration
  def change
    rename_column(:stations, :last_grade_update_at, :intervention_editable_at)
  end
end
