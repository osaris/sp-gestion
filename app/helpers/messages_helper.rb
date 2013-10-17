# -*- encoding : utf-8 -*-
module MessagesHelper

  def class_tr_message(message)
    message.read? ? "read" : "unread"
  end

end
