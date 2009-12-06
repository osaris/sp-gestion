class Convocation < ActiveRecord::Base
  
  belongs_to :station
  belongs_to :uniform
  has_many :convocation_firemen, :dependent => :destroy, :order => 'convocation_firemen.grade DESC'
  has_many :firemen, :through => :convocation_firemen
  
  validates_presence_of :title, :message => "Le titre est obligatoire."
  validates_presence_of :date, :message => "La date est obligatoire."
  validates_presence_of :uniform, :message => "La tenue est obligatoire."
  validates_presence_of :firemen, :message => "Les personnes convoquées sont obligatoires."
  
  def pdf
    pdf = Prawn::Document.new(:page_size => "A5", :page_layout => :landscape)
    self.convocation_firemen.each do |convocation_fireman|
      fireman = convocation_fireman.fireman
      grade = convocation_fireman.grade.nil? ? "" : Grade::GRADE.index(convocation_fireman.grade)
      
      pdf.text(self.station.name)
      pdf.text("CONVOCATION")
      pdf.text(grade + " " + fireman.firstname + " " + fireman.lastname)
      pdf.text("Date et heure : " + self.date.to_s(:short))
      pdf.text("Motif : " + self.title)
      pdf.start_new_page unless (pdf.page_count == self.firemen.size)
    end
    pdf
  end
  
  def validate
    self.errors.add(:date, "Ne peut pas être dans le passé !") if !editable?
  end
  
  def editable?
    !(self.date.blank?) and (self.date > Time.now)
  end
    
end
