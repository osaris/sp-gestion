# -*- encoding : utf-8 -*-
class InterventionValidator < ActiveModel::Validator

  def validate(record)
    if (!record.end_date.blank? and !record.start_date.blank? )
      record.errors[:end_date] << "Ne peut pas être avant la date de début !" if record.end_date < record.start_date
      record.errors[:start_date] << "Ne peut pas être dans le futur !" if record.start_date > Time.now
      record.errors[:end_date] << "Ne peut pas être dans le futur !" if record.end_date > Time.now
    end
  end

end
