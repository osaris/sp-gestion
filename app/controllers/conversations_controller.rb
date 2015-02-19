class ConversationsController < BackController

  # authorize_resource Mailboxer::Message

  before_action :load_message, :except => :index
  skip_before_action :require_html_request, :only => [:mark_as_read]

  def index
    @conversations = current_user.mailbox
                                 .inbox
                                 .page(params[:page])
                                 .order('created_at')
  end

  def show
  end

  private

  def load_message
    @conversation = current_user.mailbox.conversations.find(params[:id])
    @conversation.mark_as_read(current_user)
   rescue ActiveRecord::RecordNotFound
    flash[:error] = "Le message n'existe pas."
    redirect_to(messages_path)
  end
end
