# A Simple CLI Coffee Logger

  It marks down the time and puts it an array, where it's stored in an external file. Then it's able to be read the time stamps inside the array, and output it in a message.
  There's a limiter to the amount of time stamps inside the array, and it's the number set by the limiter variable inside the coffee drink method. 
  Lists last coffee logged when ran with no option.
  For first runs, it's required to log one coffee of course, and by doing that it will create the file on the log path class variable.
  This script uses Marshal so it's best that this is used with the same ruby version every time it's ran, otherwise it's unable to read or write to the file.


  The version that was used to make this:


    ruby 2.3.3p222 (2016-11-21) [x86_64-linux-gnu]

### Changes to implement
1. Class variables
  * Have them be unset compared to what's on my own computer
  * Or have a config file for setting variables
  * Or set them via ruby ENV variables

2. Set up having multiple logs
  * Various methods to create new logs and paths
  * Method to either switch or set up options to read other time stamps/logs/files

3. Set up config options
  * For setting path/s
  * Setting past coffee time
  * Setting limiter in coffee write
