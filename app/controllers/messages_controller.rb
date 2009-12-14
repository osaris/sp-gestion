class MessagesController < BackController
  
  navigation(:messages)
  
  before_filter :load_message, :except => :index
  
  def index
    @messages = current_user.messages.paginate(:page => params[:page], :order => 'created_at')
  end
  
  def show
    @message.mark_as_read
  end
  
  def mark_as_read
    @message.mark_as_read
    render(:nothing => :true)
  end
  
  private
  
  def load_message
    @message = current_user.messages.find(params[:id])
   rescue ActiveRecord::RecordNotFound
    redirect_to(messages_path)
  end
  
end
