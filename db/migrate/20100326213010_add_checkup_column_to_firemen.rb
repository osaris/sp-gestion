# -*- encoding : utf-8 -*-
class AddCheckupColumnToFiremen < ActiveRecord::Migration
  def self.up
    add_column(:firemen, :checkup, :date)
  end

  def self.down
    remove_column(:firemen, :checkup)
  end
end
