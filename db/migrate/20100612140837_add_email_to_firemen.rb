# -*- encoding : utf-8 -*-
class AddEmailToFiremen < ActiveRecord::Migration
  def self.up
    add_column(:firemen, :email, :string)
  end

  def self.down
    remove_column(:firemen, :email)
  end
end
