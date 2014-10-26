# -*- encoding : utf-8 -*-
class FiremanAvailability < ActiveRecord::Base

  belongs_to :station
  belongs_to :fireman

  validates_datetime :availability, :after => Date.today

  validates_presence_of :fireman_id
  validates_presence_of :availability
  validates_presence_of :station_id

  validates_uniqueness_of :fireman_id, :scope => :availability

  before_destroy :check_valid_date

  scope :count_by_availability, ->(range) {
    where(:availability => range)
    .group(:availability)
    .count
  }

  scope :count_by_availability_for_grade, ->(range, grade) {
    joins(:fireman)
    .where('firemen.grade_category = ?', grade)
    .count_by_availability(range)
  }

  scope :count_by_availability_for_training, ->(range, training) {
    joins(:fireman => :fireman_trainings)
    .where('fireman_trainings.training_id = ?', training)
    .count_by_availability(range)
  }

  scope :firemen_for_range, ->(range) {
    select('DISTINCT firemen.*')
    .joins(:fireman)
    .where(:availability => range)
    .order('firemen.grade DESC, firemen.lastname ASC')
  }

  scope :firemen_for_range_and_grade, ->(range, grade) {
    firemen_for_range(range)
    .where('firemen.grade_category = ?', grade)
  }

  scope :firemen_for_range_and_training, ->(range, training) {
    firemen_for_range(range)
    .joins(:fireman => :fireman_trainings)
    .where('fireman_trainings.training_id = ?', training)
  }

  private

  def check_valid_date
    availability > Date.today
  end
end
