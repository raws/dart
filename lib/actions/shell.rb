module Dart::Actions
  def shell_action(action, sender, source, args)
    output = `#{action[:command]}`
    privmsg output, source unless action[:silent] or output.nil? or output =~ /^\s*$/
  end
  
  alias :terminal_action :shell_action
  alias :term_action :shell_action
end
