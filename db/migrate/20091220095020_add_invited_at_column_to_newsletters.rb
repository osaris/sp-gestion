class AddInvitedAtColumnToNewsletters < ActiveRecord::Migration
  def self.up
    add_column(:newsletters, :invited_at, :datetime)
  end

  def self.down
    remove_column(:newsletters, :invited_at)
  end
end
