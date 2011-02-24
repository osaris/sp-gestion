# Grade of fireman
class Grade < ActiveRecord::Base

  belongs_to :fireman

  validates_date :date, :allow_blank => true, :invalid_date_message => "Format incorrect (JJ/MM/AAAA)"
  validates_with GradeValidator

  after_save :set_last_grade_update_at

  GRADE_CATEGORY = {
    'Officier' => 1,
    'Sous-officier' => 2,
    'Homme du rang' => 3,
    'Médecin' => 4,
    'Infirmier' => 5
  }.freeze

  GRADE = {
    'Médecin capitaine' => 19, 'Médecin commandant' => 20, 'Médecin lieutenant-colonel' => 21, 'Médecin colonel' => 22,
    'Infirmier' => 15, 'Infirmier principal' => 16, 'Infirmier chef' => 17, "Infirmier d'encadrement" => 18,
    'Colonel' => 14, 'Lieutenant-colonel' => 13, 'Commandant' => 12,
    'Capitaine' => 11, 'Lieutenant' => 10, 'Major' => 9,
    'Adjudant-chef' => 8, 'Adjudant' => 7, 'Sergent-chef' => 6, 'Sergent' => 5,
    'Caporal-chef' => 4, 'Caporal' => 3, '1ère classe' => 2, '2e classe' => 1
  }.freeze

  GRADE_CATEGORY_MATCH = { 1 => 3, 2 => 3, 3 => 3, 4 => 3,
                           5 => 2, 6 => 2, 7 => 2, 8 => 2,
                           9 => 1, 10 => 1, 11 => 1, 12 => 1, 13 => 1, 14 => 1, 15 => 1, 16 => 1,
                           15 => 5, 17 => 5, 18 => 5, 19 => 5,
                           16 => 4, 20 => 4, 21 => 4, 22 => 4 }

  def self.new_defaults
    GRADE.sort_by {|grade| 1-grade[1] }.inject([]) do |result, grade|
      result << Grade.new(:kind => grade[1])
    end
  end

  private

  def set_last_grade_update_at
    self.fireman.station.reset_last_grade_update_at if self.date_changed?
  end

end