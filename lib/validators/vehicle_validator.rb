class VehicleValidator < ActiveModel::Validator

  def validate(record)
    if !record.date_delisting.blank? and
      record.station.confirm_intervention_editable_at?(record.date_delisting) and
      (record.validate_date_delisting_update.to_i != 1)

      record.errors[:validate_date_delisting_update] << "Erreur"
    end
  end
end
