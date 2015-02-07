class AddDaybookPermission < ActiveRecord::Migration
  def up
    Resource.create(:title    => 'Main courante',
                    :name     => 'Daybook',
                    :category => 'Général')
  end

  def down
    Resource.delete_all(:name  => 'Daybook')
  end
end
