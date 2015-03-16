class Conversation

  include ActiveModel::Validations

  attr_accessor :recipients, :subject, :body

  validates_presence_of :recipients, :message => 'Le destinataire est obligatoire.'
  validates_presence_of :subject, :message => 'Le sujet est obligatoire.'
  validates_presence_of :body, :message => 'Le message est obligatoire.'

  def initialize(station, current_user, conversation_params = nil)
    @station = station
    @current_user = current_user
    unless conversation_params.blank?
      @recipients = conversation_params[:recipients]
      @subject = conversation_params[:subject]
      @body = conversation_params[:body]
    end
  end

  def save
    return false unless valid?
    recipients = @station.users.find(@recipients)
    conversation = @current_user.send_message(recipients, @subject, @body)
                                .conversation
  end
end
