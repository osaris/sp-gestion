# -*- encoding : utf-8 -*-
class AddCityToInterventions < ActiveRecord::Migration
  def self.up
    add_column(:interventions, :city, :string)
  end

  def self.down
    remove_column(:interventions, :city)
  end
end
