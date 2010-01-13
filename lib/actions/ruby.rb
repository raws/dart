module Dart::Actions
  def ruby_action(action, sender, source, args)
    output = eval action[:code]
    privmsg output, action[:to] || source unless action[:silent]
  end
end
