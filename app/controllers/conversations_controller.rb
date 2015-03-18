class ConversationsController < BackController

  # authorize_resource Mailboxer::Message

  before_action :load_message, :only => [:show, :reply]
  before_action :load_recipients, :only => [:new, :create]

  def index
    @mailbox_type  = params[:mailbox]
    @conversations = current_user.mailbox
                                 .conversations(:mailbox_type => params[:mailbox])
                                 .page(params[:page])
                                 .order('created_at')
  end

  def show
    @reply = Reply.new(@conversation, current_user)
  end

  def new
    @conversation = Conversation.new(@station, current_user)
  end

  def create
    @conversation = Conversation.new(@station, current_user, params[:conversation])
    if @conversation.save
      redirect_to conversation_path(@conversation)
    else
      render(:action => :new)
    end
  end

  def reply
    @reply = Reply.new(@conversation, current_user, params[:reply])
    if @reply.save
      redirect_to conversation_path(@conversation)
    else
      render(:action => :show)
    end
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
