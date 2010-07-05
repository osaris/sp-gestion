class AddColumnsForConvocationsByEmail < ActiveRecord::Migration
  def self.up
    add_column(:convocations, :last_emailed_at, :datetime)
    add_column(:stations, :last_email_sent_at, :datetime)
    add_column(:stations, :nb_email_sent, :integer, :default => 0)
  end

  def self.down
    remove_column(:stations, :nb_email_sent)
    remove_column(:stations, :last_email_sent_at)
    remove_column(:convocations, :last_emailed_at)
  end
end
