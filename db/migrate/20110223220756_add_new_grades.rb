class AddNewGrades < ActiveRecord::Migration
  def self.up
    # set new grade id for "Medecin"
    execute("UPDATE grades SET grades.kind = 19 WHERE grades.kind = 16")
    execute("UPDATE fireman_interventions SET grade = 19 WHERE grade = 16")
    execute("UPDATE convocation_firemen SET grade = 19 WHERE grade = 16")

    say_with_time("Add new grades to all existings firemen") do
      Grade.select('DISTINCT fireman_id').each do |grade|
        # be careful, no 19 here
        new_grades = [12, 13, 14, 15, 16, 17, 18, 20, 21, 22]
        values = new_grades.collect { |kind| '(' + kind.to_s + ',' + grade.fireman_id.to_s + ')' }.join(",")

        execute ("INSERT INTO grades (kind, fireman_id) VALUES #{values}")
      end
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
