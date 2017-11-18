#!/usr/bin/env ruby
class Coffee
  # option parser commands
  require 'optparse'

  ARGV << '-l' if ARGV.empty?

  options = {}
  optparse = OptionParser.new do |opts|
    opts.banner = "Usage: coffee.rb [options]"

    opts.on( '-d', 'Run method "coffee_drink"') do |v|
      options[:d] = true
    end

    opts.on( '-l', 'Run method "coffee_last"') do |v|
      options[:l] = true
    end
    
    opts.on( '-a', 'Run method "coffee_all"') do |v|
      options[:a] = true
    end

    opts.on( '--all-dates', 'Run method "coffee_date_all"') do |v|
      options[:all] = true
    end

    opts.on( '-p', 'Run method "coffee_past_day"') do |v|
      options[:p] = true
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

  # @time is unix time, it's in seconds and an integer which makes it nice to change into a string or do math with
  @@time = Time.now.to_i
  @@log_path = "/home/mine/workspace/practice/ruby/log/log_coffee"
  # more or less a reduction and makes the Marshal loading easier to read
<<<<<<< HEAD
  # has to check for the path so it doesn't throw an error for trying to call this
  @@log_read = Marshal.load(File.read( "/home/mine/workspace/practice/ruby/log/log_coffee")) if File.exists?(@@log_path)
=======
  @@log_read = Marshal.load(File.binread(@@log_path))
>>>>>>> aa813e0b0485cf391c61c36621dd71edabbeb181

  def coffee_drink
    # checks for log file existance so problems don't arise from calling a non-existing file
    if File.exists?(@@log_path)
      coffees = @@log_read
    else
      coffees = []
    end
    coffees << @@time
    limit = 10
    if coffees.length > limit
      until coffees.length <= limit
	coffees.shift
      end
    end

<<<<<<< HEAD
    File.open(@@log_path, 'w+') {|f| f.write(Marshal.dump(coffees))}
=======
    File.open(@@log_path, 'wb') {|f| f.write(Marshal.dump(obj))}
>>>>>>> aa813e0b0485cf391c61c36621dd71edabbeb181
    puts "Coffee time added"
  end

  def coffee_last
    Coffee.message(@@log_read.last)
  end

  def coffee_past_day
    i = 0

    @@log_read.each do |coffee|
      remaining = @@time - coffee

      if remaining/86400 < 1
	puts Coffee.message(coffee)
	i += 1	
      end

    end

    puts "#{i} Cup#{:s unless i == 1} in the past day"

  end

  def coffee_all
    @@log_read.each do |coffee|
      Coffee.message(coffee)
    end
  end

  def coffee_date_all
    @@log_read.each do |coffee|
      date = Time.at(coffee).strftime "%Y %B %d %H:%M:%S"
      puts "Cup emptied on #{date}"
    end
  end
  
  def self.message(time)
    remaining = @@time - time
    
    # here math is being done to figure out what amount of time it has been since the given time stamp
    # array of hours and minutes is made from dividing out seconds with a modulo for minutes
    hms = [remaining / 3600 % 24, remaining / 60 % 60]

    # not rounding minutes away for whatever reason, turns the array into HH:MM string 
    hms = hms.map { |t| t.to_s.rjust(2,'0') }.join(":") if hms[0] >= 1
 
    # takes string of either the minutes array element or the array itself and attaches
    # a message of minutes/hours so no conditional in the message, conditional in minutes
    # so when it's just 1 minute there's no pluralization
    hms = ("#{hms[1].to_s} minute#{:s if hms[1] != 1} now" if hms[0] === 0) || ("#{hms} hours now")

    # day in seconds = 86400 and it displays days passed if any 
    days = " #{remaining / 86400} day#{:s if remaining/86400 > 1 }, and"
    puts "Cup clean for#{days if remaining >= 86400} #{hms}"
  end

  # these if options have to be after the method or else it fails to call
  if options[:d]
    Coffee.new.coffee_drink
  end
  
  if options[:a]
    Coffee.new.coffee_all
  end

  if options[:all]
    Coffee.new.coffee_date_all
  end

  if options[:p]
    Coffee.new.coffee_past_day
  end

  if options[:l]
    Coffee.new.coffee_last
  end
end
