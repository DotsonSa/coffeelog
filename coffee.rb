#!/usr/bin/env ruby
class Coffee
  # option parser commands
  require 'optparse'

  options = {}
  optparse = OptionParser.new do |opts|
    # banner that lists options
    opts.banner = "Usage: coffee.rb [options]"

    opts.on( '-d', 'Run method "drank_at"') do |v|
      options[:d] = true
    end

    opts.on( '-l', 'Run method "last_coffee"') do |v|
      options[:l] = true
    end
    
    opts.on( '-b', 'Run method "b"') do |v|
      options[:b] = true
    end

    options[:verbose] = false
    opts.on( '-v', '--verbose', 'Output more information' ) do
      options[:verbose] = true
    end

    opts.on( '-h', '--help', 'Display this screen' ) do
      puts opts
      exit
    end
  end.parse!

  # @time is unix time, nice because it's in seconds and an integer
  @time = Time.now.to_i
  @tmp_path = "/home/mine/workspace/practice/ruby/tmp/tmp_coffee"
  
  # writes the seconds integer into a file so it's somewhere
  def self.drank_at
    # simply to show last coffee
    self.last_coffee
    File.open(@tmp_path, "w+") do |f|
      f.write @time
    end
    puts "Coffee cup cleaned out"
  end
  
  # reads the file with the integer and takes the current time integer and subtracts for
  # the seconds between the two, the time since the drank_at command was entered
  def self.last_coffee
    t = File.open(@tmp_path).read.to_i
    remaining = @time - t

    # array of hours and minutes is made from dividing out seconds with a modulo for minutes
    hms = [remaining / 3600 % 24, remaining / 60 % 60]

    # not rounding minutes away for whatever reason, turns the array into HH:MM string 
    hms = hms.map { |t| t.to_s.rjust(2,'0') }.join(":") if hms[0] >= 1
 
    # takes string of either the minutes array element or the array itself and attaches
    # a message of minutes/hours so no conditional in the message, conditional in minutes
    # so when it's just 1 minute there's no pluralization
    hms = ("#{hms[1].to_s} minute#{:s if hms[1] != 1} now" if hms[0] === 0) || ("#{hms} hours now")

    # for replacing the zero minute where remaining isn't over a minute yet, just don't 
    # want it to display 0 minutes now, and not sure how to place a string in a conditional
    not_long = "not long now"
    
    # day in seconds = 86400 and it displays days passed if any 
    days = " #{remaining / 86400} day#{:s if remaining/86400 > 1 }, and"
    puts "Cup clean for#{days if remaining >= 86400} #{hms}"
  end

  # these if options have to be after the method or else it fails to call
  if options[:d]
    self.drank_at
  end
  
  if options[:l]
    self.last_coffee
  end
end
