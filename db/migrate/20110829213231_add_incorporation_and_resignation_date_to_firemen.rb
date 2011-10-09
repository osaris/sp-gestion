class AddIncorporationAndResignationDateToFiremen < ActiveRecord::Migration
  def self.up
    add_column(:firemen, :incorporation_date, :date)
    add_column(:firemen, :resignation_date, :date)
  end

  def self.down
    remove_column(:firemen, :resignation_date)    
    remove_column(:firemen, :incorporation_date)    
  end
end
