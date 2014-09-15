# -*- encoding : utf-8 -*-
class FiremanValidator < ActiveModel::Validator

  def validate(record)
    if record.status == Fireman::STATUS['JSP']
      current_grade = record.grades.reject{ |grade| grade.date.blank? }
                      .sort { |a,b| b.kind <=> a.kind }
                      .first
      if !current_grade.blank? and (current_grade.kind > Grade::GRADE['JSP 4'])
        record.errors[:grades] << "Un JSP ne peut pas avoir un grade plus élevé que vert."
      end
    else
      if record.grades.reject{ |grade| grade.date.blank? }.empty?
        record.errors[:grades] << "Une personne ayant le statut actif ou vétéran doit avoir un grade."
      elsif record.station.confirm_intervention_editable_at?(record.max_grade_date) and (record.validate_grade_update.to_i != 1)
        record.errors[:validate_grade_update] << "Erreur"
      end
    end
  end

end
