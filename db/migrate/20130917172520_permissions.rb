class Permissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references(:group)
      t.references(:resource)
      t.boolean(:can_show)
      t.boolean(:can_create)
      t.boolean(:can_update)
      t.boolean(:can_destroy)
      t.timestamps
    end
  end
end
