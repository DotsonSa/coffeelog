# A Simple Coffee Script Timer

## Not for timing coffee, but it's consumption

  Two methods for listing time since last coffee entry/drinking, with the other just being coffee drank/entered as the time stamp. 
  It marks down the time when the drank command is entered as a unix time stamp, and reads it out. Currently only supports one time stamp.

### Changes to implement

1. Make use of Marshal library
  * To use it rather than File write and read
  * To convert an array item into the tmp file
  * Longer kept history of time stamps

2. Break up last coffee method
  * Take apart the strings and time math
  * More modular for use of marshalizing and allows differnt methods easier creation/coding
