#!/usr/bin/env ruby
class Coffee
  require 'optparse'

  # @time is unix time, it's in seconds and an integer which makes it nice to change into a string or do math with
  @@time = Time.now.to_i
  @@log_path = "/home/mine/workspace/practice/ruby/log/log_coffee"
  # more or less a reduction and makes the Marshal loading easier to read
  # has to check for the path so it doesn't throw an error for trying to call this
  @@log_read = Marshal.load(File.read( "/home/mine/workspace/practice/ruby/log/log_coffee")) if File.exists?(@@log_path)

  def coffee_drink
    # checks for log file existance so problems don't arise from calling a non-existing file
    if File.exists?(@@log_path)
      coffees = @@log_read
    else
      coffees = []
    end
    coffees << @@time
    limit = 20
    if coffees.length > limit
      until coffees.length <= limit
	coffees.shift
      end
    end

    File.open(@@log_path, 'w+') {|f| f.write(Marshal.dump(coffees))}
    puts "Coffee time added"
  end
# commented out because I need to rewrite message/last because it won't read it correctly
#  def coffee_old(hours)
#    hour = @@time - (hours.to_i * 3600)
#    if File.exists?(@@log_path)
#      coffees = @@log_read
#    else
#      coffees = []
#    end
#    coffees << hour
#    limit = 20
#    if coffees.length > limit
#      until coffees.length <= limit
#	coffees.shift
#      end
#    end

#    File.open(@@log_path, 'w+') {|f| f.write(Marshal.dump(coffees))}
#    puts "Old coffee added"
#    puts @@time - hour
#
#  end

  def coffee_remove
    @@log_read.shift
    File.open(@@log_path, 'w+') {|f| f.write(Marshal.dump(@@log_read))}
    puts "Coffee time removed"
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

    week = 0
    day = remaining/86400
    until day < 7
      week += 1
      day -= 7
    end

    comma = ","
    conditional_and = " and"

    days = " #{:a if day == 1 }#{day if day >= 2 } day#{:s if day > 1 }#{comma if week >= 1 && day >= 1}#{conditional_and if day >=1 || week >= 1}"
    weeks = " #{:a if week == 1 }#{week if week >= 2 } week#{:s if week > 1 }#{comma if week >= 1 && day >= 1}#{conditional_and if day == 0}"
    message = "#{weeks if week >= 1}#{days if day >= 1} #{hms}"

    puts "Cup clean for#{message}"
  end

  # method for bug checking message time variables past days
  def message_day_hms(time)
    remaining = @@time - time
    hms = [remaining / 3600 % 24, remaining / 60 % 60]
    hms = hms.map { |t| t.to_s.rjust(2,'0') }.join(":") if hms[0] >= 1
    hms = ("#{hms[1].to_s} minute#{:s if hms[1] != 1} now" if hms[0] === 0) || ("#{hms} hours now")
    # day in seconds = 86400 
    day = remaining/86400
    days = " #{:a if day < 2 }#{day if day >= 2 } day#{:s if day > 1 } and"
    puts "Cup clean for#{days if day >= 1} #{hms}"
  end

  # these if options have to be after the method or else it fails to call

  ARGV << '-l' if ARGV.empty?
  ARGV.options do |opts|
    opts.banner = "Usage: coffee.rb [options]"

    opts.on("-l") { Coffee.new.coffee_last }
    opts.on("-d") { Coffee.new.coffee_drink }
    opts.on("--hours=val") { |val| Coffee.new.coffee_old(val) }
    opts.on("-r") { Coffee.new.coffee_remove }
    opts.on("-a") { Coffee.new.coffee_all }
    opts.on("--all") { Coffee.new.coffee_date_all }
    opts.on("-p") { Coffee.new.coffee_past_day }
    opts.parse!
  end
end
