class CreateUniforms < ActiveRecord::Migration
  def self.up
    create_table :uniforms do |t|
      t.string(:code)
      t.string(:title)
      t.string(:description)
      t.references(:station)
      t.timestamps
    end
  end

  def self.down
    drop_table :uniforms
  end
end
