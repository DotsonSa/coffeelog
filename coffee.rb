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
    
    opts.on( '-c', 'Run method "tmp_clear"') do |v|
      options[:c] = true
    end

    opts.on( '-a', 'Run method "coffee_all"') do |v|
      options[:a] = true
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

  # @time is unix time, nice because it's in seconds and an integer, which makes it nice to change into a string or do math with
  @@time = Time.now.to_i
  @@tmp_path = "/home/mine/workspace/practice/ruby/tmp/tmp_coffee"
 
  # writes an object to tmp file
  # it marshals the object first then writes
  # added the message because this is only used when adding a time stamp to it
  def tmp_write(obj)
    File.open(@@tmp_path, 'wb') {|f| f.write(Marshal.dump(obj))}
    puts "Coffee time added"
  end

  # more or less a reduction and makes the Marshal loading easier to read
  # also don't have to write it out so much even with only one line, less chance for a bug
  def tmp_read
    Marshal.load(File.binread(@@tmp_path))
  end

  # clears out the tmp file while also writing one item to it so it's not completely empty
  def tmp_clear
    coffees = []
    coffees << @@time
    puts "Coffee file cleared"
    # to clear out tmp file
    File.open(@@tmp_path, 'w') {}
    tmp_write(coffees)
  end

  # checks for the amount of items in the array then removes the oldest until there's only 2
  # then it adds a third item into the array
  def coffee_drink
    coffees = tmp_read

    coffees << @@time

    #Limiter for tmp array length
    #change limit to change the number of total items allowed in the array
    limit = 3
    if coffees.length > limit
      until coffees.length <= limit
	coffees.shift
      end
    end

    tmp_write(coffees)
  end

  # reads tmp file and then prints out message method with selected array item
  def coffee_last
    coffees = tmp_read
    Coffee.message(coffees.last)
  end

  # reads out all items within the tmp array
  def coffee_all
    coffees = tmp_read

    # iterates over the tmp array and writes out each time stamp
    coffees.each do |coffee|
      Coffee.message(coffee)
    end
  end
  
  # reads the file with the integer and takes the current time integer and subtracts for
  # the seconds between the two, the time since the drank_at command was entered
  def self.message(time)
    # time being an integer object that is already a unix time stamp
    # then the current time is taken away from the time stamp
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

  if options[:l]
    Coffee.new.coffee_last
  end

  if options[:c]
    Coffee.new.tmp_clear
  end
end
