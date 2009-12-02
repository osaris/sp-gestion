class CreateConvocationFiremen < ActiveRecord::Migration
  def self.up
    create_table :convocation_firemen do |t|
      t.references(:convocation)
      t.references(:fireman)
      t.boolean(:presence, :default => false)
      t.integer(:grade)
      t.integer(:status)
      t.timestamps
    end
  end

  def self.down
    drop_table :convocation_firemen
  end
end
