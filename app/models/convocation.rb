# The boring part
class Convocation < ActiveRecord::Base

  belongs_to :station
  belongs_to :uniform
  has_many :convocation_firemen, :dependent => :destroy, :order => 'convocation_firemen.grade DESC'
  has_many :firemen, :through => :convocation_firemen

  validates_presence_of :title, :message => "Le titre est obligatoire."
  validates_presence_of :date, :message => "La date est obligatoire."
  validates_presence_of :place, :message => "Le lieu est obligatoire."
  validates_presence_of :uniform, :message => "La tenue est obligatoire."
  # FIXME record is saved even if this validation failed, it's a Rails bug
  # https://rails.lighthouseapp.com/projects/8994/tickets/922-has_many-through-transaction-rollback
  validates_presence_of :firemen, :message => "Les personnes convoquées sont obligatoires."
  validates_datetime :date, :invalid_datetime_message => "Format incorrect (JJ/MM/AAAA HH:MM)"

  named_scope :newer, { :order => 'date DESC' }

  named_scope :limit, lambda { |num|
    {:limit => num }
  }

  def validate
    self.errors.add(:date, "Ne peut pas être dans le passé !") if !editable?
  end

  def presence
    result = ActiveRecord::Base.connection.select_all("SELECT
                                                       COUNT(*) AS total,
                                                       SUM(IF(presence = 0,1,0)) AS missings,
                                                       SUM(IF(presence=1,1,0)) as presents,
                                                       status
                                                       FROM convocation_firemen
                                                       WHERE convocation_id = #{self.id}
                                                       GROUP BY status")
    result.each { |line| line.symbolize_keys! }
  end

  def editable?
    !(self.date.blank?) and (self.date > Time.now)
  end

  def send_emails(user_email)
    nb_email = 0
    # send convocations
    self.convocation_firemen.with_email.each do |convocation_fireman|
      ConvocationMailer.send_later(:deliver_convocation, self, convocation_fireman, user_email)
      nb_email += 1
    end
    # send confirmation to user who started the job
    ConvocationMailer.deliver_sending_confirmation(self, user_email)
    # update station attributes
    self.station.update_attributes(:last_email_sent_at => Time.now,
                                   :nb_email_sent => station.nb_email_sent + nb_email)
  end

end
