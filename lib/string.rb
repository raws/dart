class String
  def dartify(sender, args)
    gsub(/%nick/i, sender[:nick]).
    gsub(/%host/i, sender[:hostname]).
    gsub(/%(\d+)/) do
      if (i = $1.to_i) == 0
        args.join(' ')
      else
        args[i]
      end
    end
  end
end
