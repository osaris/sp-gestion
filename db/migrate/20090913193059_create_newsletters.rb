# -*- encoding : utf-8 -*-
class CreateNewsletters < ActiveRecord::Migration
  def self.up
    create_table :newsletters do |t|
      t.string :email
      t.string :activation_key, :limit => 64
      t.datetime :activated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :newsletters
  end
end
