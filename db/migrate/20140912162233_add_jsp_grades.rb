class AddJspGrades < ActiveRecord::Migration

  def up
    Fireman.find_each(:batch_size => 50) do |f|
      (-3..0).each do |kind|
        f.grades.create(:kind => kind)
      end
    end
  end

  def down
    Grade.where(kind: (-3..0)).delete_all
  end
end
