class ConversationsController < BackController

  # authorize_resource Mailboxer::Message

  before_action :load_message, :only => [:show]
  before_action :load_recipients, :only => [:new]

  def index
    @conversations = current_user.mailbox
                                 .conversations(:mailbox_type => params[:mailbox])
                                 .page(params[:page])
                                 .order('created_at')
  end

  def show
  end

  def new
    @conversation =  current_user.mailbox.conversations.new
  end

  def create
    conversation = current_user.
      send_message(recipients, *conversation_params(:body, :subject)).conversation

    redirect_to conversation_path(conversation)
  end

  private

  def load_recipients
    @recipients = @station.users.recipients(current_user)
  end

  def load_message
    @conversation = current_user.mailbox.conversations.find(params[:id])
    @conversation.mark_as_read(current_user)
   rescue ActiveRecord::RecordNotFound
    flash[:error] = "Le message n'existe pas."
    redirect_to(messages_path)
  end
end
