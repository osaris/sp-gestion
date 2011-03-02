# -*- encoding : utf-8 -*-
class ReplaceRolesByTagsForFiremen < ActiveRecord::Migration
  def self.up
    add_column(:firemen, :cached_tag_list, :string)
        
    say_with_time("Replacing roles by tags for each fireman") do
      Fireman.find_each(:batch_size => 30) do |fireman|
        tags = []
        tags << "Chef de centre" if fireman.chief
        tags << "Adjoint" if fireman.chief_assistant
        tags << "Fourrier" if fireman.quartermaster
        
        unless tags.blank?
          fireman.tag_list = tags
          fireman.save(false)
        end
      end
    end
    
    remove_column(:firemen, :chief)
    remove_column(:firemen, :chief_assistant)
    remove_column(:firemen, :quartermaster)
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
