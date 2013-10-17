# -*- encoding : utf-8 -*-
class CreateConvocations < ActiveRecord::Migration
  def self.up
    create_table :convocations do |t|
      t.string(:title)
      t.datetime(:date)
      t.references(:uniform)
      t.references(:station)
      t.timestamps
    end
  end

  def self.down
    drop_table :convocations
  end
end
