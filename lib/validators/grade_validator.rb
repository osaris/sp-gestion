# -*- encoding : utf-8 -*-
class GradeValidator < ActiveModel::Validator

  def validate(record)
    record.errors[:date] << "Ne peut pas être dans le futur !" if !record.date.blank? and record.date > Date.today
  end

end
