# -*- encoding : utf-8 -*-
class InterventionValidator < ActiveModel::Validator

  def validate(record)
    if record.fireman_interventions.size < 1 || record.fireman_interventions.all? { |fi| fi.marked_for_destruction? }
      record.errors[:firemen] << "Le personnel est obligatoire."
    end
  end
end
