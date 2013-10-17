# -*- encoding : utf-8 -*-
class FiremanValidator < ActiveModel::Validator

  def validate(record)
    if record.status != Fireman::STATUS['JSP']
      if record.grades.reject{ |grade| grade.date.blank? }.empty?
        record.errors[:grades] << "Une personne ayant le statut actif ou vétéran doit avoir un grade."
      elsif record.station.confirm_last_grade_update_at?(record.max_grade_date) and (record.validate_grade_update.to_i != 1)
        record.errors[:validate_grade_update] << "Erreur"
      end
    end
  end

end
