module Dart::Actions
  def message_action(action, sender, source, args)
    privmsg action[:message], action[:to] || source
  end
  
  def notice_action(action, sender, source, args)
    response "NOTICE #{action[:to] || source} :#{action[:message]}"
  end
end
