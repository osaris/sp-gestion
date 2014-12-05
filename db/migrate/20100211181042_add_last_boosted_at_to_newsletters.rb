class AddLastBoostedAtToNewsletters < ActiveRecord::Migration
  def self.up
    add_column(:newsletters, :last_boosted_at, :datetime)
  end

  def self.down
    remove_column(:newsletters, :last_boosted_at)
  end
end
