# A Simple Coffee Script Timer

## Not for timing coffee, but it's consumption

  It marks down the time and puts it an array, where it's stored in an external file. Then it's able to be read the time stamps inside the array, and output it in a message.
  There's a built in limiter to the amount of time stamps inside the array, and it's the number set by the limiter variable inside the coffee drink method. 
  A host of options is available, and more to be added for doing math on the array to check for coffee drank in the past history.
  Automatically lists last coffee logged when ran with no option instead of the usual help option.

### Changes to implement

1. Math function to check for 24 hour past coffee
  * Perform math on the array for checking items that have been added within the past 24 hours
  * Return the value in a neat message

2. Names
  * Change option naming and arguments
  * Change method names to reflect what the method does
  * Also, change the messages 

3. Change tmp file into a log file
  * Need to look into the correct type, and local, of the log file
  * Change naming and also the location of tmp path class variable

4. Read all time stamps in a date format
  * Alike the read all time stamps method, -a, it reads the time stamps in a date format instead of 'time since coffee drank' message
