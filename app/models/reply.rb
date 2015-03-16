class Reply

  include ActiveModel::Validations

  attr_accessor :body

  validates_presence_of :body, :message => 'Le message est obligatoire.'

  def initialize(conversation, current_user, reply_params = nil)
    @conversation = conversation
    @current_user = current_user
    @body = reply_params[:body] unless reply_params.blank?
  end

  def save
    return false unless valid?
    @current_user.reply_to_conversation(@conversation, @body)
  end
end
