# -*- encoding : utf-8 -*-
class ConvocationValidator < ActiveModel::Validator

  def validate(record)
    record.errors[:base] << "This is some custom error message" if !record.editable?
  end

end
