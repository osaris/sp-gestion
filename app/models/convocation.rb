# -*- encoding : utf-8 -*-
class Convocation < ActiveRecord::Base

  belongs_to :station
  belongs_to :uniform
  has_many :convocation_firemen, -> { order 'convocation_firemen.grade DESC' }, :dependent => :destroy
  has_many :firemen, :through => :convocation_firemen

  delegate :url, :name, :to => :station, :prefix => true
  delegate :description, :title, :to => :uniform, :prefix => true

  validates_presence_of :title, :message => "Le titre est obligatoire."
  validates_presence_of :date, :message => "La date est obligatoire."
  validates_presence_of :place, :message => "Le lieu est obligatoire."
  validates_presence_of :uniform, :message => "La tenue est obligatoire."
  validates_presence_of :firemen, :message => "Les personnes convoquées sont obligatoires."
  validates_datetime :date
  validates_with ConvocationValidator

  scope :newer, -> { order('date DESC') }
  scope :with_sha1, lambda { |sha1|
    where(['SHA1(id) = ?', sha1])
  }
  scope :confirmable, -> { where(confirmable: true) }

  def initialize(params = nil, *args)
    super
    self.confirmable ||= false
  end

  def presence
    ConvocationFireman.select("COUNT(*) AS total, SUM(IF(presence = 0,1,0)) AS missings, SUM(IF(presence=1,1,0)) as presents, status") \
                      .where(:convocation_id => self.id) \
                      .group(:status)
  end

  def editable?
    !(self.date.blank?) and (self.date > Time.now)
  end

  def send_emails(user_email)
    nb_email = 0
    # send convocations
    self.convocation_firemen.with_email.each do |convocation_fireman|
      ConvocationMailer.convocation(self, convocation_fireman, user_email).deliver
      nb_email += 1
    end
    # send confirmation to user who started the job
    ConvocationMailer.sending_confirmation(self, user_email).deliver
    # store last emailed time
    self.update_attribute(:last_emailed_at, Time.now)
    # update station attributes
    self.station.update_attributes(:last_email_sent_at => Time.now,
                                   :nb_email_sent => station.nb_email_sent + nb_email)
  end
end
