# -*- encoding : utf-8 -*-
class ConvocationFireman < ActiveRecord::Base

  belongs_to :convocation
  belongs_to :fireman

  scope :newer, includes(:convocation).order('convocations.date DESC').limit(5)
  scope :with_email, includes(:fireman).where(["COALESCE(firemen.email, '') <> ''"])

  before_create :set_grade_and_status

  scope :find_by_sha1, lambda { |sha1|
    where(['SHA1(id) = ?', sha1])
  }

  protected

  def set_grade_and_status
    self.grade = self.fireman.grade
    self.status = self.fireman.status
  end

end
