class MessagesController < BackController

  authorize_resource

  before_action :load_message, :except => :index
  skip_before_action :require_html_request, :only => [:mark_as_read]

  def index
    @messages = current_user.messages
                            .page(params[:page])
                            .order('created_at')
  end

  def show
    @message.read!
  end

  def mark_as_read
    authorize!(:update, Message)
    @message.read!
  end

  private

  def load_message
    @message = current_user.messages.find(params[:id])
   rescue ActiveRecord::RecordNotFound
    flash[:error] = "Le message n'existe pas."
    redirect_to(messages_path)
  end
end
