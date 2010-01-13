class String
  def dartify(&b)
    vars = b.send(:binding)
    args = eval 'args', vars
    last = eval 'Thread.current[:last]', vars
    sender = eval 'sender', vars
    
    parse_last(last).
    parse_sender(sender).
    parse_args(args)
  end
  
  def parse_args(args)
    gsub(/%(\d+)/) do
      if (i = $1.to_i) == 0
        args.join(' ')
      else
        args[i]
      end
    end
  end
  
  def parse_last(last)
    gsub(/%last/i, last)
  end
  
  def parse_sender(sender)
    gsub(/%nick/i, sender[:nick]).
    gsub(/%host/i, sender[:hostname])
  end
end
