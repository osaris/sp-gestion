class RenameInterventionsSubtypeToSubkind < ActiveRecord::Migration
  def self.up
    rename_column(:interventions, :subtype, :subkind)
  end

  def self.down
    rename_column(:interventions, :subkind, :subtype)
  end
end
