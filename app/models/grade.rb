class Grade < ActiveRecord::Base
  
  belongs_to :fireman
  
  GRADE_CATEGORY = {
    'Officier' => 1,
    'Sous-officier' => 2,
    'Homme du rang' => 3
  }.freeze  
  
  GRADE = {
    'Colonel' => 14, 'Lieutenant-colonel' => 13, 'Commandant' => 12, 'Capitaine' => 11, 'Lieutenant' => 10, 'Major' => 9,
    'Adjudant-chef' => 8, 'Adjudant' => 7, 'Sergent-chef' => 6, 'Sergent' => 5,
    'Caporal-chef' => 4, 'Caporal' => 3, '1ère classe' => 2, '2e classe' => 1
  }.freeze
    
  GRADE_CATEGORY_MATCH = { 1 => 3, 2 => 3, 3 => 3, 4 => 3, 
                           5 => 2, 6 => 2, 7 => 2, 8 => 2, 
                           9 => 1, 10 => 1, 11 => 1, 12 => 1, 13 => 1, 14 => 1}
  
  def self.new_defaults
    GRADE.sort_by {|grade| 1-grade[1] }.inject([]) do |result, grade|
      result << Grade.new(:kind => grade[1])
    end
  end
  
  def validate
    self.errors.add(:date, "Ne peut pas être dans le futur !") if !date.blank? and date > Date.today
  end
  
end
