module ConversationsHelper

  def class_tr_message(conversation)
    conversation.is_read?(current_user) ? "read" : "unread"
  end

  def format_participants(mailbox_type, conversation)
    participants = conversation.participants
                               .reject { |p| p == current_user }
                               .collect { |p| p.email }
                               .uniq
                               .join(", ")

    if mailbox_type == 'sentbox'
      participants = 'À : ' + participants
    end
    participants
  end
end
