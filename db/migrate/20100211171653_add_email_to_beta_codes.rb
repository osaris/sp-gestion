class AddEmailToBetaCodes < ActiveRecord::Migration
  def self.up
    add_column(:beta_codes, :email, :string)
  end

  def self.down
    remove_column(:beta_codes, :email)
  end
end
