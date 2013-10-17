# -*- encoding : utf-8 -*-
class ConvocationFireman < ActiveRecord::Base

  belongs_to :convocation
  belongs_to :fireman

  delegate :title, :place, :date, :to => :convocation, :prefix => true
  delegate :firstname, :lastname, :to => :fireman, :prefix => true

  scope :newer, -> { order('convocations.date DESC').includes(:convocation).limit(5) }
  scope :with_email, -> { includes(:fireman).where(["COALESCE(firemen.email, '') <> ''"])
                                            .references(:fireman) }

  before_create :set_grade_and_status

  scope :with_sha1, lambda { |sha1|
    where(['SHA1(id) = ?', sha1])
  }

  protected

  def set_grade_and_status
    self.grade = self.fireman.grade
    self.status = self.fireman.status
  end

end
