module ConversationsHelper

  def class_tr_message(conversation)
    conversation.is_read?(current_user) ? "read" : "unread"
  end

end
