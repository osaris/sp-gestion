# -*- encoding : utf-8 -*-
class Grade < ActiveRecord::Base

  belongs_to :fireman

  validates_date :date, :allow_blank => true, :on_or_before => :today

  after_save :update_intervention_editable_at

  GRADE_CATEGORY = {
    'Médecin'       => 5,
    'Infirmier'     => 4,
    'Officier'      => 1,
    'Sous-officier' => 2,
    'Homme du rang' => 3,
    'JSP'           => 6
  }.freeze

  GRADE_CATEGORY_PLURAL = {
    'Médecins'        => 5,
    'Infirmiers'      => 4,
    'Officiers'       => 1,
    'Sous-officiers'  => 2,
    'Hommes du rang'  => 3,
    'JSP'             => 6
  }

  GRADE = {
    'Médecin colonel'             => 22,
    'Médecin lieutenant-colonel'  => 21,
    'Médecin commandant'          => 20,
    'Médecin capitaine'           => 19,
    "Infirmier d'encadrement"     => 18,
    'Infirmier chef'              => 17,
    'Infirmier principal'         => 16,
    'Infirmier'                   => 15,
    'Colonel'                     => 14,
    'Lieutenant-colonel'          => 13,
    'Commandant'                  => 12,
    'Capitaine'                   => 11,
    'Lieutenant'                  => 10,
    'Major'                       => 9,
    'Adjudant-chef'               => 8,
    'Adjudant'                    => 7,
    'Sergent-chef'                => 6,
    'Sergent'                     => 5,
    'Caporal-chef'                => 4,
    'Caporal'                     => 3,
    '1ère classe'                 => 2,
    '2e classe'                   => 1,
    'JSP 4'                       => 0,
    'JSP 3'                       => -1,
    'JSP 2'                       => -2,
    'JSP 1'                       => -3
  }.freeze

  GRADE_CATEGORY_MATCH = { 1 => 3, 2 => 3, 3 => 3, 4 => 3,
                           5 => 2, 6 => 2, 7 => 2, 8 => 2,
                           9 => 1, 10 => 1, 11 => 1, 12 => 1, 13 => 1, 14 => 1,
                           15 => 4, 16 => 4, 17 => 4, 18 => 4,
                           19 => 5, 20 => 5, 21 => 5, 22 => 5,
                           0 => 6, -1 => 6, -2 => 6, -3 => 6}

  def self.new_defaults
    GRADE.sort_by {|grade| 1-grade[1] }.inject([]) do |result, grade|
      result << Grade.new(:kind => grade[1])
    end
  end

  private

  def update_intervention_editable_at
    self.fireman.station.update_intervention_editable_at if self.date_changed?
  end

end
