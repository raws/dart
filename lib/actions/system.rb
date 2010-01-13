module Dart::Actions
  def quit_action(action, sender, source, args)
    Thread.main.exit
  end
  
  alias :exit_action :quit_action
end
