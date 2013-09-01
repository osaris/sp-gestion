class RenameFiremanTrainingAchievementToAchievedAt < ActiveRecord::Migration
  def change
  rename_column(:fireman_trainings, :achievement, :achieved_at)
  end
end
