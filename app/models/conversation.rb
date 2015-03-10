class Conversation

  include ActiveModel::Validations

  attr_accessor :recipients, :subject, :body

  validates_presence_of :recipients, :subject, :body

  def initialize(conversation_params = nil)
    unless conversation_params.blank?
      @recipients = conversation_params[:recipients]
      @subject = conversation_params[:subject]
      @body = conversation_params[:body]
    end
  end
end
